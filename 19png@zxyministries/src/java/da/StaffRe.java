package da;

import java.sql.*;

public class StaffRe {
   private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private static final String TABLE_NAME = "STAFF";

    private Connection conn;
    private PreparedStatement stmt;

    public StaffRe() {
        createConnection();
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }

    public boolean doesEmailExist(String email) {
        String query = "SELECT STAFFEMAIL FROM " + TABLE_NAME + " WHERE STAFFEMAIL = ?";
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean resetPassword(String email, String newPassword) {
        String query = "UPDATE " + TABLE_NAME + " SET STAFFPASSWORD = ? WHERE STAFFEMAIL = ?";
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void shutDown() {
        try {
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}
