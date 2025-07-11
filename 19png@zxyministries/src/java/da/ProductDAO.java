package da;

import domain.Products;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private String tableName = "Products";
    private Connection conn;

    public ProductDAO() {
        createConnection();
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            System.out.println("Database connected successfully");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Database connection error: " + ex.getMessage());
        }
    }

    private void ensureConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                createConnection();
            }
        } catch (SQLException ex) {
            System.out.println("Connection check failed: " + ex.getMessage());
            createConnection();
        }
    }

    public Products getProductById(String productId) {
        String queryStr = "SELECT p.*, c.category_name, s.subcategory_name " +
                         "FROM " + tableName + " p " +
                         "JOIN Categories c ON p.category_id = c.category_id " +
                         "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                         "WHERE p.product_id = ? AND p.status = 'active'";
        Products product = null;
        
        try {
            ensureConnection();
            try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
                stmt.setString(1, productId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        product = extractProductFromResultSet(rs);
                    }
                }
            }
        } catch (SQLException ex) {
            handleSQLException(ex);
        }
        return product;
    }

    public List<Products> getAllProducts() {
        List<Products> products = new ArrayList<>();
        String queryStr = "SELECT p.*, c.category_name, s.subcategory_name " +
                         "FROM " + tableName + " p " +
                         "JOIN Categories c ON p.category_id = c.category_id " +
                         "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                         "WHERE p.status = 'active' " +
                         "ORDER BY p.product_name";
        
        try {
            ensureConnection();
            try (PreparedStatement stmt = conn.prepareStatement(queryStr);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(extractProductFromResultSet(rs));
                }
                System.out.println("Retrieved " + products.size() + " products");
            }
        } catch (SQLException ex) {
            handleSQLException(ex);
        }
        return products;
    }

    public List<Products> getProductsByCategory(String categoryId) {
        List<Products> products = new ArrayList<>();
        String queryStr = "SELECT p.*, c.category_name, s.subcategory_name " +
                         "FROM " + tableName + " p " +
                         "JOIN Categories c ON p.category_id = c.category_id " +
                         "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                         "WHERE p.category_id = ? AND p.status = 'active' " +
                         "ORDER BY p.product_name";
        
        try {
            ensureConnection();
            try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
                stmt.setString(1, categoryId);
                System.out.println("Executing category query for: " + categoryId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        products.add(extractProductFromResultSet(rs));
                    }
                }
            }
            System.out.println("Found " + products.size() + " products for category: " + categoryId);
        } catch (SQLException ex) {
            handleSQLException(ex);
        }
        return products;
    }

    public List<Products> getAllProducts(String sort) {
        List<Products> products = new ArrayList<>();
        String queryStr = "SELECT * FROM " + tableName + " WHERE status = 'active'";

        // Append sorting conditions based on the input parameter
        if ("id_asc".equals(sort)) {
            queryStr += " ORDER BY product_id ASC";
        } else if ("id_desc".equals(sort)) {
            queryStr += " ORDER BY product_id DESC";
        } else if ("price_asc".equals(sort)) {
            queryStr += " ORDER BY price ASC";
        } else if ("price_desc".equals(sort)) {
            queryStr += " ORDER BY price DESC";
        }

        try {
            ensureConnection();
            try (PreparedStatement stmt = conn.prepareStatement(queryStr);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(extractProductFromResultSet(rs));
                }
            }
        } catch (SQLException ex) {
            handleSQLException(ex);
        }
        return products;
    }

    public List<Products> getProductsByCategoryAndSubcategory(String categoryId, String subcategoryId) {
        List<Products> products = new ArrayList<>();
        String queryStr = "SELECT p.*, c.category_name, s.subcategory_name " +
                         "FROM " + tableName + " p " +
                         "JOIN Categories c ON p.category_id = c.category_id " +
                         "JOIN Subcategories s ON p.subcategory_id = s.subcategory_id " +
                         "WHERE p.category_id = ? AND p.subcategory_id = ? " +
                         "AND p.status = 'active' " +
                         "ORDER BY p.product_name";
        
        try {
            ensureConnection();
            try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
                stmt.setString(1, categoryId);
                stmt.setString(2, subcategoryId);
                System.out.println("Executing query for Category: " + categoryId + ", Subcategory: " + subcategoryId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Products product = extractProductFromResultSet(rs);
                        products.add(product);
                        System.out.println("Found product: " + product.getProductName());
                    }
                }
            }
            System.out.println("Total products found: " + products.size());
        } catch (SQLException ex) {
            handleSQLException(ex);
        }
        return products;
    }

    private Products extractProductFromResultSet(ResultSet rs) throws SQLException {
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
        return product;
    }

    public boolean addProduct(Products product) {
        String queryStr = "INSERT INTO " + tableName + 
                         " (product_id, category_id, subcategory_id, product_name, description, " +
                         "price, stock_qty, image_url, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            ensureConnection();
            try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
                setProductParameters(stmt, product, true);
                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException ex) {
            handleSQLException(ex);
            return false;
        }
    }
public boolean updateProduct(Products product) {
    String queryStr = "UPDATE " + tableName + 
                     " SET product_name = ?, category_id = ?, subcategory_id = ?, " +
                     "description = ?, price = ?, stock_qty = ?, image_url = ? " +
                     "WHERE product_id = ?";
    try {
        ensureConnection();
        try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getCategoryId());
            stmt.setString(3, product.getSubcategoryId());
            stmt.setString(4, product.getDescription());
            stmt.setDouble(5, product.getPrice());
            stmt.setInt(6, product.getStockQty());
            stmt.setString(7, product.getImageUrl());
            stmt.setString(8, product.getProductId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    } catch (SQLException ex) {
        handleSQLException(ex);
        return false;
    }
}

    private void setProductParameters(PreparedStatement stmt, Products product, boolean isInsert) throws SQLException {
        if (isInsert) {
            stmt.setString(1, product.getProductId());
            stmt.setString(2, product.getCategoryId());
            stmt.setString(3, product.getSubcategoryId());
            stmt.setString(4, product.getProductName());
            stmt.setString(5, product.getDescription());
            stmt.setDouble(6, product.getPrice());
            stmt.setInt(7, product.getStockQty());
            stmt.setString(8, product.getImageUrl());
            stmt.setString(9, "active");
        } else {
            stmt.setString(1, product.getCategoryId());
            stmt.setString(2, product.getSubcategoryId());
            stmt.setString(3, product.getProductName());
            stmt.setString(4, product.getDescription());
            stmt.setDouble(5, product.getPrice());
            stmt.setInt(6, product.getStockQty());
            stmt.setString(7, product.getImageUrl());
            stmt.setString(8, product.getStatus());
            stmt.setString(9, product.getProductId());
        }
    }
    
  


    public boolean deleteProduct(String productId) {
        String queryStr = "UPDATE " + tableName + " SET status = 'inactive' WHERE product_id = ?";
        
        try {
            ensureConnection();
            try (PreparedStatement stmt = conn.prepareStatement(queryStr)) {
                stmt.setString(1, productId);
                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException ex) {
            handleSQLException(ex);
            return false;
        }
    }
   public List<Products> getProductsByCategory(String category, String sort) {
    List<Products> productList = new ArrayList<>();
    
    // Build the query string
    String query = "SELECT * FROM " + tableName + " WHERE category_id = ? AND status = 'active' ORDER BY " + sort;
    
    // Debugging: Print the query to verify correctness
    System.out.println("Executing query: " + query);
    
    try {
        ensureConnection(); // Ensure the connection is active
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category); // Set the category parameter
            
            // Execute query
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Products product = new Products();
                    product.setProductId(rs.getString("product_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setCategoryId(rs.getString("category_id"));
                    product.setSubcategoryId(rs.getString("subcategory_id"));
                    product.setDescription(rs.getString("description"));
                    product.setPrice(rs.getDouble("price"));
                    product.setStockQty(rs.getInt("stock_qty"));
                    product.setImageUrl(rs.getString("image_url"));
                    product.setStatus(rs.getString("status"));
                    productList.add(product);
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return productList;
}


    private void handleSQLException(SQLException ex) {
        System.out.println("SQL Error: " + ex.getMessage());
        ex.printStackTrace(); // Consider using a logging framework instead
    }

    public boolean testConnection() {
        try {
            ensureConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException ex) {
            System.out.println("Connection test failed: " + ex.getMessage());
            return false;
        }
    }
}