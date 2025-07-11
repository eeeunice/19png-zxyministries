package da;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    private static final String TABLE_NAME = "ADMIN.PAYMENT";
    private Connection conn;
    private PreparedStatement stmt;

    public PaymentDAO() {
        createConnection();
    }

    private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
            System.out.println("Database Connected");
        } catch (ClassNotFoundException | SQLException ex) {
            System.err.println("Database Connect Failed");
            ex.printStackTrace();
        }
    }

    public boolean addPayment(String paymentId, String addressId, String paymentMethod, 
                             Timestamp paymentDate, double paymentAmount, String paymentStatus,
                             String paymentToken, String paymentConfirmation, 
                             String shippingAddress, double shippingCost, String orderId) {
        
        String query = "INSERT INTO " + TABLE_NAME + 
                      " (PAYMENTID, ADDRESSID, PAYMENTMETHOD, PAYMENTDATE, PAYMENTAMOUNT, " +
                      "PAYMENTSTATUS, PAYMENTTOKEN, PAYMENTCONFIRMATION, SHIPPINGADDRESS, " +
                      "SHIPPINGCOST, ORDERID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, paymentId);
            stmt.setString(2, addressId);
            stmt.setString(3, paymentMethod);
            stmt.setTimestamp(4, paymentDate);
            stmt.setDouble(5, paymentAmount);
            stmt.setString(6, paymentStatus);
            stmt.setString(7, paymentToken);
            stmt.setString(8, paymentConfirmation);
            stmt.setString(9, shippingAddress);
            stmt.setDouble(10, shippingCost);
            stmt.setString(11, orderId);
            
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException ex) {
            System.err.println("Payment Failed List");
            ex.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    public boolean updatePaymentStatus(String paymentId, String newStatus) {
        String query = "UPDATE " + TABLE_NAME + " SET PAYMENTSTATUS = ? WHERE PAYMENTID = ?";
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, newStatus);
            stmt.setString(2, paymentId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    public boolean getPaymentByOrderId(String orderId) {
        String query = "SELECT * FROM " + TABLE_NAME + " WHERE ORDERID = ?";
        try {
            stmt = conn.prepareStatement(query);
            stmt.setString(1, orderId);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // 如果有记录则返回true
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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