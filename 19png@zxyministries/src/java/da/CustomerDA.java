package da;

import domain.Customer;
import java.sql.*;

public class CustomerDA {   

    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private String tableName = "CUSTOMER";
    private Connection conn;
    private PreparedStatement stmt;

    public CustomerDA() {
        createConnection();
    }

    public Customer validateLogin(String username, String password) {
        String queryStr = "SELECT * FROM " + tableName + " WHERE USERNAME = ? AND PASSWORD = ?";
        Customer customer = null;
        try {
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Return a Customer object with all fields if login is successful
                customer = new Customer(
                    rs.getString("CUSTOMERID"),
                    rs.getString("CUSTNAME"),
                    rs.getString("EMAIL"),
                    rs.getString("PHONENUM"),
                    rs.getDate("DATEOFBIRTH"),
                    rs.getString("ADDRESSID"),
                    rs.getString("GENDER"),
                    rs.getString("USERNAME"),
                    rs.getString("PASSWORD"),
                    rs.getTimestamp("REGISTRATIONDATE")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return customer;
    }

    public Customer validateLoginByUsername(String username, String password) {
        String queryStr = "SELECT * FROM " + tableName + " WHERE USERNAME = ? AND PASSWORD = ?";
        Customer customer = null;
        try {
            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Return a Customer object with all fields if login is successful
                customer = new Customer(
                    rs.getString("CUSTOMERID"),
                    rs.getString("CUSTNAME"),
                    rs.getString("EMAIL"),
                    rs.getString("PHONENUM"),
                    rs.getDate("DATEOFBIRTH"),
                    rs.getString("ADDRESSID"),
                    rs.getString("GENDER"),
                    rs.getString("USERNAME"),
                    rs.getString("PASSWORD"),
                    rs.getTimestamp("REGISTRATIONDATE")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return customer;
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