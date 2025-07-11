package da;

import domain.Categories;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Category_AdminDAO {

    private DatabaseLink db;

    public Category_AdminDAO() {
        this.db = new DatabaseLink(); // Create one DB link only
    }

    public List<Categories> getAllCategories() {
        List<Categories> categories = new ArrayList<>();
        String sql = "SELECT * FROM Categories ORDER BY category_name";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Categories category = mapResultSetToCategory(rs);
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public Categories getCategoryById(String categoryId) {
        String sql = "SELECT * FROM Categories WHERE category_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addCategory(Categories category) {
        String sql = "INSERT INTO Categories (category_id, category_name, description, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category.getCategoryId());
            stmt.setString(2, category.getCategoryName());
            stmt.setString(3, category.getDescription());
            stmt.setString(4, "active");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCategory(Categories category) {
        String sql = "UPDATE Categories SET category_name = ?, description = ?, status = ? WHERE category_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setString(3, category.getStatus());
            stmt.setString(4, category.getCategoryId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCategory(String categoryId) {
        // Ensure no related subcategories or products exist
        if (hasRelatedSubcategories(categoryId) || hasRelatedProducts(categoryId)) {
            return false;
        }

        String sql = "DELETE FROM Categories WHERE category_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, categoryId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean hasRelatedSubcategories(String categoryId) {
        String sql = "SELECT COUNT(*) FROM Subcategories WHERE category_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, categoryId);
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

    private boolean hasRelatedProducts(String categoryId) {
        String sql = "SELECT COUNT(*) FROM Products WHERE category_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, categoryId);
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

    public String generateCategoryId() {
        String sql = "SELECT MAX(CAST(SUBSTRING(category_id, 2) AS INT)) as max_id FROM Categories";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                return String.format("C%03d", maxId + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "C001";
    }

    private Categories mapResultSetToCategory(ResultSet rs) throws SQLException {
        Categories category = new Categories();
        category.setCategoryId(rs.getString("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getString("status"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) category.setCreatedAt(createdAt);

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) category.setUpdatedAt(updatedAt);

        String createdBy = rs.getString("created_by");
        if (createdBy != null) category.setCreatedBy(createdBy);

        String updatedBy = rs.getString("updated_by");
        if (updatedBy != null) category.setUpdatedBy(updatedBy);

        return category;
    }
}
