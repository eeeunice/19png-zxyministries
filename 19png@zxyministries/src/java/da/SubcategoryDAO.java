package da;
import domain.Subcategories;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubcategoryDAO {
    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private String tableName = "Subcategories";
    private Connection conn;
    private PreparedStatement stmt;
    private ResultSet rs;
    
    public SubcategoryDAO() {
        createConnection();
    }
    
    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            System.out.println("Database connected successfully");
        } catch (ClassNotFoundException ex) {
            System.out.println("Database driver not found: " + ex.getMessage());
        } catch (SQLException ex) {
            System.out.println("Database connection error: " + ex.getMessage());
        }
    }

    public List<Subcategories> getAllSubcategories() {
        List<Subcategories> subcategories = new ArrayList<>();
        String queryStr = "SELECT s.*, c.category_name FROM " + tableName + 
                         " s JOIN Categories c ON s.category_id = c.category_id " +
                         "WHERE s.status = 'active' ORDER BY s.subcategory_name";
        
        try {
            if (conn == null || conn.isClosed()) {
                createConnection();
            }
            stmt = conn.prepareStatement(queryStr);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                subcategories.add(extractSubcategoryFromResultSet(rs));
            }
        } catch (SQLException ex) {
            handleSQLException(ex);
        } finally {
            closeResources();
        }
        return subcategories;
    }

    public List<Subcategories> getSubcategoriesByCategory(String categoryId) {
        List<Subcategories> subcategories = new ArrayList<>();
        String queryStr = "SELECT s.*, c.category_name FROM " + tableName + 
                         " s JOIN Categories c ON s.category_id = c.category_id " +
                         "WHERE s.category_id = ? AND s.status = 'active' " +
                         "ORDER BY s.subcategory_name";
        
        try {
            if (conn == null || conn.isClosed()) {
                createConnection();
            }
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, categoryId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                subcategories.add(extractSubcategoryFromResultSet(rs));
            }
            System.out.println("Found " + subcategories.size() + " subcategories for category: " + categoryId);
        } catch (SQLException ex) {
            handleSQLException(ex);
        } finally {
            closeResources();
        }
        return subcategories;
    }

    public Subcategories getSubcategoryById(String subcategoryId) {
        String queryStr = "SELECT s.*, c.category_name FROM " + tableName + 
                         " s JOIN Categories c ON s.category_id = c.category_id " +
                         "WHERE s.subcategory_id = ? AND s.status = 'active'";
        Subcategories subcategory = null;
        
        try {
            if (conn == null || conn.isClosed()) {
                createConnection();
            }
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, subcategoryId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                subcategory = extractSubcategoryFromResultSet(rs);
            }
        } catch (SQLException ex) {
            handleSQLException(ex);
        } finally {
            closeResources();
        }
        return subcategory;
    }

    private Subcategories extractSubcategoryFromResultSet(ResultSet rs) throws SQLException {
        Subcategories subcategory = new Subcategories();
        subcategory.setSubcategoryId(rs.getString("subcategory_id"));
        subcategory.setCategoryId(rs.getString("category_id"));
        subcategory.setSubcategoryName(rs.getString("subcategory_name"));
        subcategory.setDescription(rs.getString("description"));
        subcategory.setStatus(rs.getString("status"));
        return subcategory;
    }

    private void handleSQLException(SQLException ex) {
        System.out.println("SQL Error: " + ex.getMessage());
        ex.printStackTrace();
    }

    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        } catch (SQLException ex) {
            handleSQLException(ex);
        }
    }
}