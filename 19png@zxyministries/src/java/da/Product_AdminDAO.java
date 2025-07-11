package da;

import domain.Products;
import utils.DatabaseUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Product_AdminDAO {
    
    public List<Products> getAllProducts() {
        List<Products> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, s.subcategory_name FROM Products p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                     "ORDER BY p.product_name";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Products product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Products> getProductsByCategory(String categoryId) {
        List<Products> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, s.subcategory_name FROM Products p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                     "WHERE p.category_id = ? " +
                     "ORDER BY p.product_name";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Products product = mapResultSetToProduct(rs);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Products> getProductsBySubcategory(String subcategoryId) {
        List<Products> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, s.subcategory_name FROM Products p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                     "WHERE p.subcategory_id = ? " +
                     "ORDER BY p.product_name";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, subcategoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Products product = mapResultSetToProduct(rs);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    public Products getProductById(String productId) {
        String sql = "SELECT p.*, c.category_name, s.subcategory_name FROM Products p " +
                     "JOIN Categories c ON p.category_id = c.category_id " +
                     "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                     "WHERE p.product_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addProduct(Products product) {
        String sql = "INSERT INTO Products (product_id, category_id, subcategory_id, product_name, " +
                     "description, price, stock_qty, image_url, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getProductId());
            stmt.setString(2, product.getCategoryId());
            stmt.setString(3, product.getSubcategoryId());
            stmt.setString(4, product.getProductName());
            stmt.setString(5, product.getDescription());
            stmt.setDouble(6, product.getPrice());
            stmt.setInt(7, product.getStockQty());
            stmt.setString(8, product.getImageUrl());
            stmt.setString(9, "active");
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateProduct(Products product) {
        String sql = "UPDATE Products SET category_id = ?, subcategory_id = ?, product_name = ?, " +
                     "description = ?, price = ?, stock_qty = ?, image_url = ?, status = ? " +
                     "WHERE product_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getCategoryId());
            stmt.setString(2, product.getSubcategoryId());
            stmt.setString(3, product.getProductName());
            stmt.setString(4, product.getDescription());
            stmt.setDouble(5, product.getPrice());
            stmt.setInt(6, product.getStockQty());
            stmt.setString(7, product.getImageUrl());
            stmt.setString(8, product.getStatus());
            stmt.setString(9, product.getProductId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteProduct(String productId) {
        // Soft delete - just update status to inactive
        String sql = "UPDATE Products SET status = 'inactive' WHERE product_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean hardDeleteProduct(String productId) {
        // Hard delete - remove from database
        // Use with caution as this permanently removes the record
        String sql = "DELETE FROM Products WHERE product_id = ?";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public String generateProductId() {
        String sql = "SELECT MAX(CAST(SUBSTRING(product_id, 2) AS UNSIGNED)) as max_id FROM Products";
        
        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                return String.format("P%03d", maxId + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "P001";
    }
    
    private Products mapResultSetToProduct(ResultSet rs) throws SQLException {
        Products product = new Products();
        product.setProductId(rs.getString("product_id"));
        product.setCategoryId(rs.getString("category_id"));
        product.setSubcategoryId(rs.getString("subcategory_id"));
        product.setProductName(rs.getString("product_name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setStockQty(rs.getInt("stock_qty"));
        product.setImageUrl(rs.getString("image_url"));
        product.setStatus(rs.getString("status"));
        
        // Set category and subcategory names if available
        try {
            product.setCategoryName(rs.getString("category_name"));
            product.setSubcategoryName(rs.getString("subcategory_name"));
        } catch (SQLException e) {
            // Ignore if these columns don't exist
        }
        
        // Handle timestamps if they exist in your table
        try {
            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                product.setCreatedAt(createdAt);
            }
            
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            if (updatedAt != null) {
                product.setUpdatedAt(updatedAt);
            }
            
            // Handle created_by and updated_by if they exist
            String createdBy = rs.getString("created_by");
            if (createdBy != null) {
                product.setCreatedBy(createdBy);
            }
            
            String updatedBy = rs.getString("updated_by");
            if (updatedBy != null) {
                product.setUpdatedBy(updatedBy);
            }
        } catch (SQLException e) {
            // Ignore if these columns don't exist
        }
        
        return product;
    }
}