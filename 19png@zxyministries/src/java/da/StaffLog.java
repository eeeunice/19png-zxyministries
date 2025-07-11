package da;

import domain.StaffLogin;
import java.sql.*;

public class StaffLog {

   private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private String tableName = "STAFF";
    private Connection conn;
    private PreparedStatement stmt;

    public StaffLog() {
        createConnection();
    }

    public StaffLogin validateLogin(String email, String password) {
        String queryStr = "SELECT * FROM " + tableName + " WHERE STAFFEMAIL = ? AND STAFFPASSWORD = ?";
        StaffLogin staff = null;
        try {
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                staff = new StaffLogin(
                    rs.getString("STAFFID"),
                    rs.getString("MANAGERID"),
                    rs.getString("STAFFNAME"),
                    rs.getString("STAFFEMAIL"),
                    rs.getString("STAFFPHONE"),
                    rs.getString("STAFFPASSWORD"),
                    rs.getString("ROLE")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return staff;
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void shutDown() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
