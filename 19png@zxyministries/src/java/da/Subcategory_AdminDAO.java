package da;

import domain.Subcategories;
import utils.DatabaseUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Subcategory_AdminDAO {
    
    public List<Subcategories> getAllSubcategories() {
        List<Subcategories> subcategories = new ArrayList<>();
        String sql = "SELECT s.*, c.category_name FROM Subcategories s " +
                     "JOIN Categories c ON s.category_id = c.category_id " +
                     "ORDER BY s.subcategory_name";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Subcategories subcategory = mapResultSetToSubcategory(rs);
                subcategories.add(subcategory);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subcategories;
    }
    
    public List<Subcategories> getSubcategoriesByCategory(String categoryId) {
        List<Subcategories> subcategories = new ArrayList<>();
        String sql = "SELECT s.*, c.category_name FROM Subcategories s " +
                     "JOIN Categories c ON s.category_id = c.category_id " +
                     "WHERE s.category_id = ? " +
                     "ORDER BY s.subcategory_name";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Subcategories subcategory = mapResultSetToSubcategory(rs);
                    subcategories.add(subcategory);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subcategories;
    }
    
    public Subcategories getSubcategoryById(String subcategoryId) {
        String sql = "SELECT s.*, c.category_name FROM Subcategories s " +
                     "JOIN Categories c ON s.category_id = c.category_id " +
                     "WHERE s.subcategory_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, subcategoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSubcategory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addSubcategory(Subcategories subcategory) {
        String sql = "INSERT INTO Subcategories (subcategory_id, category_id, subcategory_name, " +
                     "description, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, subcategory.getSubcategoryId());
            stmt.setString(2, subcategory.getCategoryId());
            stmt.setString(3, subcategory.getSubcategoryName());
            stmt.setString(4, subcategory.getDescription());
            stmt.setString(5, "active");
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateSubcategory(Subcategories subcategory) {
        String sql = "UPDATE Subcategories SET category_id = ?, subcategory_name = ?, " +
                     "description = ?, status = ? WHERE subcategory_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, subcategory.getCategoryId());
            stmt.setString(2, subcategory.getSubcategoryName());
            stmt.setString(3, subcategory.getDescription());
            stmt.setString(4, subcategory.getStatus());
            stmt.setString(5, subcategory.getSubcategoryId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteSubcategory(String subcategoryId) {
        // First check if there are any products using this subcategory
        if (hasRelatedProducts(subcategoryId)) {
            return false;
        }
        
        String sql = "DELETE FROM Subcategories WHERE subcategory_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, subcategoryId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private boolean hasRelatedProducts(String subcategoryId) {
        String sql = "SELECT COUNT(*) FROM Products WHERE subcategory_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, subcategoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public String generateSubcategoryId() {
        String sql = "SELECT MAX(CAST(SUBSTRING(subcategory_id, 3) AS UNSIGNED)) as max_id FROM Subcategories";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                return String.format("SC%03d", maxId + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "SC001";
    }
    
    private Subcategories mapResultSetToSubcategory(ResultSet rs) throws SQLException {
        Subcategories subcategory = new Subcategories();
        subcategory.setSubcategoryId(rs.getString("subcategory_id"));
        subcategory.setCategoryId(rs.getString("category_id"));
        subcategory.setSubcategoryName(rs.getString("subcategory_name"));
        subcategory.setDescription(rs.getString("description"));
        subcategory.setStatus(rs.getString("status"));
        
        // Set category name
        subcategory.setCategoryName(rs.getString("category_name"));
        
        // Handle timestamps if they exist in your table
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            subcategory.setCreatedAt(createdAt);
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            subcategory.setUpdatedAt(updatedAt);
        }
        
        // Handle created_by and updated_by if they exist
        String createdBy = rs.getString("created_by");
        if (createdBy != null) {
            subcategory.setCreatedBy(createdBy);
        }
        
        String updatedBy = rs.getString("updated_by");
        if (updatedBy != null) {
            subcategory.setUpdatedBy(updatedBy);
        }
        
        return subcategory;
    }
}