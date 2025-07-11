package da;

import domain.Promotion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {
    private Connection conn;
    
    public PromotionDAO() {
            DatabaseLink db = new DatabaseLink();
            conn = db.getConnection();
    }
    
    public List<Promotion> getAllPromotions() {
        List<Promotion> promotions = new ArrayList<>();
        try {
            String sql = "SELECT * FROM ADMIN.PROMOTION ORDER BY STARTDATE DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Promotion promotion = new Promotion();
                promotion.setPromotionId(rs.getString("PROMOTIONID"));
                promotion.setPromotionName(rs.getString("PROMOTIONNAME"));
                promotion.setPromotionType(rs.getString("PROMOTIONTYPE"));
                promotion.setPromotionCode(rs.getString("PROMOTIONCODE"));
                promotion.setStartDate(rs.getTimestamp("STARTDATE"));
                promotion.setEndDate(rs.getTimestamp("ENDDATE"));
                promotion.setDescription(rs.getString("DESCRIPTION"));
                promotion.setManagerId(rs.getString("MANAGERID"));
                promotions.add(promotion);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promotions;
    }
    
    public Promotion getPromotionById(String promotionId) {
        Promotion promotion = null;
        try {
            String sql = "SELECT * FROM ADMIN.PROMOTION WHERE PROMOTIONID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, promotionId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                promotion = new Promotion();
                promotion.setPromotionId(rs.getString("PROMOTIONID"));
                promotion.setPromotionName(rs.getString("PROMOTIONNAME"));
                promotion.setPromotionType(rs.getString("PROMOTIONTYPE"));
                promotion.setPromotionCode(rs.getString("PROMOTIONCODE"));
                promotion.setStartDate(rs.getTimestamp("STARTDATE"));
                promotion.setEndDate(rs.getTimestamp("ENDDATE"));
                promotion.setDescription(rs.getString("DESCRIPTION"));
                promotion.setManagerId(rs.getString("MANAGERID"));
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promotion;
    }
    
    public void closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Method to associate a discount with a product
    public boolean addDiscountToProduct(String discountId, String productId) {
        try {
            // Generate a unique ID for the discount_product record
            String discountProductId = generateDiscountProductId();

            String sql = "INSERT INTO ADMIN.DISCOUNT_PRODUCT (DISCOUNT_PRODUCT_ID, DISCOUNTID, PRODUCT_ID, STATUS) " +
                         "VALUES (?, ?, ?, 'active')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, discountProductId);
            stmt.setString(2, discountId);
            stmt.setString(3, productId);
            int result = stmt.executeUpdate();
            stmt.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to generate a unique ID for discount_product
    private String generateDiscountProductId() {
        // Combine current time and a random number for uniqueness
        return "DP" + System.currentTimeMillis() + (int)(Math.random() * 1000);
    }
    
    // Method to create a new promotion
    public boolean createPromotion(Promotion promotion) {
        try {
            String sql = "INSERT INTO ADMIN.PROMOTION (PROMOTIONID, PROMOTIONNAME, PROMOTIONTYPE, PROMOTIONCODE, STARTDATE, ENDDATE, DESCRIPTION, MANAGERID) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, promotion.getPromotionId());
            stmt.setString(2, promotion.getPromotionName());
            stmt.setString(3, promotion.getPromotionType());
            stmt.setString(4, promotion.getPromotionCode());
            stmt.setTimestamp(5, promotion.getStartDate());
            stmt.setTimestamp(6, promotion.getEndDate());
            stmt.setString(7, promotion.getDescription());
            stmt.setString(8, promotion.getManagerId());
            
            int result = stmt.executeUpdate();
            stmt.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to delete a promotion
    public boolean deletePromotion(String promotionId) {
        try {
            String sql = "DELETE FROM ADMIN.PROMOTION WHERE PROMOTIONID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, promotionId);
            
            int result = stmt.executeUpdate();
            stmt.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to update an existing promotion
    public boolean updatePromotion(Promotion promotion) {
        try {
            String sql = "UPDATE ADMIN.PROMOTION SET PROMOTIONNAME = ?, PROMOTIONTYPE = ?, PROMOTIONCODE = ?, " +
                         "STARTDATE = ?, ENDDATE = ?, DESCRIPTION = ? WHERE PROMOTIONID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, promotion.getPromotionName());
            stmt.setString(2, promotion.getPromotionType());
            stmt.setString(3, promotion.getPromotionCode());
            stmt.setTimestamp(4, promotion.getStartDate());
            stmt.setTimestamp(5, promotion.getEndDate());
            stmt.setString(6, promotion.getDescription());
            stmt.setString(7, promotion.getPromotionId());
            
            int result = stmt.executeUpdate();
            stmt.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to associate a promotion with a category
    public boolean associatePromotionWithCategory(String promotionId, String categoryId) {
        try {
            // Generate a unique ID for the promotion_category record
            String promotionCategoryId = "PC" + System.currentTimeMillis() + (int)(Math.random() * 1000);
            
            String sql = "INSERT INTO ADMIN.PROMOTION_CATEGORY (PROMOTION_CATEGORY_ID, PROMOTIONID, CATEGORY_ID, STATUS) " +
                         "VALUES (?, ?, ?, 'active')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, promotionCategoryId);
            stmt.setString(2, promotionId);
            stmt.setString(3, categoryId);
            int result = stmt.executeUpdate();
            stmt.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to associate a promotion with a product
    public boolean associatePromotionWithProduct(String promotionId, String productId) {
        try {
            // Generate a unique ID for the promotion_product record
            String promotionProductId = "PP" + System.currentTimeMillis() + (int)(Math.random() * 1000);
            
            String sql = "INSERT INTO ADMIN.PROMOTION_PRODUCT (PROMOTION_PRODUCT_ID, PROMOTIONID, PRODUCT_ID, STATUS) " +
                         "VALUES (?, ?, ?, 'active')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, promotionProductId);
            stmt.setString(2, promotionId);
            stmt.setString(3, productId);
            int result = stmt.executeUpdate();
            stmt.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}