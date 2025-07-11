package da;

import java.sql.*;

public class StaffForg {
   private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private static final String TABLE_NAME = "STAFF";
    private Connection conn;
    private PreparedStatement stmt;

    public StaffForg() {
        createConnection();
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception ex) {
            ex.printStackTrace();  // Log exception details
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
            ex.printStackTrace();  // Log SQL exception details
        }
        return false;
    }

    public void shutDown() {
        try {
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();  // Log exception details
        }
    }
}
