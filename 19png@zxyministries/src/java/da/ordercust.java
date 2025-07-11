package da;

import domain.Order;
import java.sql.*;

public class ordercust {
   private  String host = "jdbc:derby://localhost:1527/SkincareDB";
    private  String user = "admin";
    private  String password = "secret";
    
    public void insertOrder(Order order) throws SQLException {
        String sql = "INSERT INTO Order (orderId, customerId, customerName, orderDate, itemCount, totalAmount, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(host, user, password);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, order.getOrderId());
            stmt.setString(2, order.getCustomerId());
            stmt.setString(3, order.getCustomerName());
            stmt.setTimestamp(4, order.getOrderDate());
            stmt.setInt(5, order.getItemCount());
            stmt.setDouble(6, order.getTotalAmount());
            stmt.setString(7, order.getStatus());

            stmt.executeUpdate();
        }
    }
}
