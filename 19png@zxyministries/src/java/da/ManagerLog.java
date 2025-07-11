package da;

import domain.ManagerLogin;
import java.sql.*;

public class ManagerLog {

    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private String tableName = "MANAGER";
    private Connection conn;
    private PreparedStatement stmt;

    public ManagerLog() {
        createConnection();
    }

    public ManagerLogin validateLogin(String email, String password) {
        String queryStr = "SELECT * FROM " + tableName + " WHERE MANAGEREMAIL = ? AND MANAGERPASSWORD = ?";
        ManagerLogin manager = null;
        try {
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                manager = new ManagerLogin(
                    rs.getString("MANAGERID"),
                    rs.getString("MANAGERNAME"),
                    rs.getString("MANAGEREMAIL"),
                    rs.getString("MANAGERPHONE"),
                    rs.getString("MANAGERUSERNAME"),
                    rs.getString("MANAGERPASSWORD")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return manager;
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
