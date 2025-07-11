package da;

import domain.Categories;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;

    public CategoryDAO() {
        createConnection();
    }

    private void createConnection() {
        try {
            DatabaseLink db = new DatabaseLink();
            conn = db.getConnection();
            if (conn != null) {
                System.out.println("Category DAO: Database connected successfully");
            }
        } catch (Exception ex) {
            System.err.println("Category DAO: Database connection error: " + ex.getMessage());
        }
    }

    private void ensureConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                createConnection();
            }
        } catch (SQLException ex) {
            System.err.println("Connection check failed: " + ex.getMessage());
            createConnection();
        }
    }

    public Categories getCategoryById(String categoryId) {
        String queryStr = "SELECT * FROM Categories WHERE category_id = ? AND status = 'active'";
        Categories category = null;

        try {
            ensureConnection();
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, categoryId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                category = extractCategoryFromResultSet(rs);
            }
        } catch (SQLException ex) {
            System.err.println("getCategoryById error: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return category;
    }

    public List<Categories> getAllCategories() {
        List<Categories> categories = new ArrayList<>();
        String queryStr = "SELECT * FROM Categories WHERE status = 'active' ORDER BY category_name";

        try {
            ensureConnection();
            stmt = conn.prepareStatement(queryStr);
            rs = stmt.executeQuery();

            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
        } catch (SQLException ex) {
            System.err.println("getAllCategories error: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    private Categories extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Categories category = new Categories();
        category.setCategoryId(rs.getString("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getString("status"));
        return category;
    }

    public boolean addCategory(Categories category) {
        String queryStr = "INSERT INTO Categories (category_id, category_name, description, status) VALUES (?, ?, ?, ?)";

        try {
            ensureConnection();
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, category.getCategoryId());
            stmt.setString(2, category.getCategoryName());
            stmt.setString(3, category.getDescription());
            stmt.setString(4, "active"); // Always set status to active for new categories

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            System.err.println("addCategory error: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updateCategory(Categories category) {
        String queryStr = "UPDATE Categories SET category_name = ?, description = ? WHERE category_id = ? AND status = 'active'";

        try {
            ensureConnection();
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setString(3, category.getCategoryId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            System.err.println("updateCategory error: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean deleteCategory(String categoryId) {
        String queryStr = "UPDATE Categories SET status = 'inactive' WHERE category_id = ? AND status = 'active'";

        try {
            ensureConnection();
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, categoryId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            System.err.println("deleteCategory error: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        } catch (SQLException ex) {
            System.err.println("Error closing resources: " + ex.getMessage());
        }
    }
}