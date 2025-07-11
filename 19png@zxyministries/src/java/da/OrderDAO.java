package da;

import domain.Order;
import domain.OrderDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;

public class OrderDAO {
    private Connection connection;

    public OrderDAO() {
        try {
            DatabaseLink db = new DatabaseLink();
            connection = db.getConnection();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<Order>(); // Initialize with empty list instead of null
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return orders; // Return empty list instead of null
            }

            String query = "SELECT o.ORDERID, o.CUSTOMERID, c.CUSTNAME, o.ORDERDATE, " +
                    "(SELECT COUNT(*) FROM \"ADMIN\".\"ORDERDETAILS\" od WHERE od.ORDERDETAILSID = o.ORDERID) AS ITEM_COUNT, "
                    +
                    "o.PAYAMOUNT, os.STATUS " +
                    "FROM \"ADMIN\".\"ORDER\" o " +
                    "JOIN \"ADMIN\".\"CUSTOMER\" c ON o.CUSTOMERID = c.CUSTOMERID " +
                    "JOIN \"ADMIN\".\"ORDERSTATUS\" os ON o.ORDERSTATUSID = os.ORDERSTATUSID " +
                    "ORDER BY ORDERID";

            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("ORDERID"));
                order.setCustomerId(rs.getString("CUSTOMERID"));
                order.setCustomerName(rs.getString("CUSTNAME"));
                order.setOrderDate(rs.getTimestamp("ORDERDATE"));
                order.setItemCount(rs.getInt("ITEM_COUNT"));
                order.setTotalAmount(rs.getDouble("PAYAMOUNT"));
                order.setStatus(rs.getString("STATUS"));

                orders.add(order);
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println("SQL Exception in getAllOrders: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
        } catch (Exception e) {
            System.out.println("General Exception in getAllOrders: " + e.getMessage());
            e.printStackTrace(); // Add stack trace for better debugging
        }
        return orders; // Always return the list (empty if there was an error)
    }

    public List<OrderDetail> getOrderDetails(String orderId) {
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        return orderDetailDAO.getOrderDetailsByOrderId(orderId);
    }

    public Order getOrderById(String orderId) {
        Order order = null;
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return null;
            }

            String query = "SELECT o.ORDERID, o.CUSTOMERID, c.CUSTNAME, o.ORDERDATE, " +
                    "(SELECT COUNT(*) FROM \"ADMIN\".\"ORDERDETAILS\" od WHERE od.ORDERDETAILSID = o.ORDERID) AS ITEM_COUNT, "
                    +
                    "o.PAYAMOUNT, os.STATUS " +
                    "FROM \"ADMIN\".\"ORDER\" o " +
                    "JOIN \"ADMIN\".\"CUSTOMER\" c ON o.CUSTOMERID = c.CUSTOMERID " +
                    "JOIN \"ADMIN\".\"ORDERSTATUS\" os ON o.ORDERSTATUSID = os.ORDERSTATUSID " +
                    "WHERE o.ORDERID = ?";

            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getString("ORDERID"));
                order.setCustomerId(rs.getString("CUSTOMERID"));
                order.setCustomerName(rs.getString("CUSTNAME"));
                order.setOrderDate(rs.getTimestamp("ORDERDATE"));
                order.setItemCount(rs.getInt("ITEM_COUNT"));
                order.setTotalAmount(rs.getDouble("PAYAMOUNT"));
                order.setStatus(rs.getString("STATUS"));
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println("SQL Exception in getOrderById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("General Exception in getOrderById: " + e.getMessage());
            e.printStackTrace();
        }
        return order;
    }

    public int countOrdersByStatus(String status) {
        int count = 0;
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return 0;
            }

            String query = "SELECT COUNT(*) FROM \"ADMIN\".\"ORDER\" o " +
                    "JOIN \"ADMIN\".\"ORDERSTATUS\" os ON o.ORDERSTATUSID = os.ORDERSTATUSID " +
                    "WHERE os.STATUS = ?";

            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println("SQL Exception in countOrdersByStatus: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("General Exception in countOrdersByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    public double calculateTotalRevenue() {
        double revenue = 0;
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return 0;
            }

            String query = "SELECT SUM(PAYAMOUNT) FROM \"ADMIN\".\"ORDER\"";

            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                revenue = rs.getDouble(1);
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println("SQL Exception in calculateTotalRevenue: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("General Exception in calculateTotalRevenue: " + e.getMessage());
            e.printStackTrace();
        }
        return revenue;
    }

    // Get orders by customer ID
    public List<Order> getOrdersByCustomer(String customerId) {
        List<Order> orders = new ArrayList<>();
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return orders;
            }

            String query = "SELECT o.ORDERID, o.CUSTOMERID, c.CUSTNAME, o.ORDERDATE, " +
                    "o.TOTALAMOUNTORDER, o.DISCOUNTAMOUNTORDER, o.PAYAMOUNT, " +
                    "(SELECT COUNT(*) FROM \"ADMIN\".\"ORDERDETAILS\" od WHERE od.ORDERID = o.ORDERID) AS ITEM_COUNT, "
                    +
                    "os.STATUS " +
                    "FROM \"ADMIN\".\"ORDER\" o " +
                    "JOIN \"ADMIN\".\"CUSTOMER\" c ON o.CUSTOMERID = c.CUSTOMERID " +
                    "JOIN \"ADMIN\".\"ORDERSTATUS\" os ON o.ORDERSTATUSID = os.ORDERSTATUSID " +
                    "WHERE o.CUSTOMERID = ? " +
                    "ORDER BY o.ORDERDATE DESC";

            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("ORDERID"));
                order.setCustomerId(rs.getString("CUSTOMERID"));
                order.setCustomerName(rs.getString("CUSTNAME"));
                order.setOrderDate(rs.getTimestamp("ORDERDATE"));
                order.setItemCount(rs.getInt("ITEM_COUNT"));
                order.setTotalAmount(rs.getDouble("PAYAMOUNT"));
                order.setStatus(rs.getString("STATUS"));
                orders.add(order);

                // Add debug information
                System.out.println("Found order: " + order.getOrderId() + " for customer: " + customerId);
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println("SQL Exception in getOrdersByCustomer: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public boolean addOrder(Order order) {
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return false;
            }

            String query = "INSERT INTO \"ADMIN\".\"ORDER\" (ORDERID, CUSTOMERID, ORDERDATE, " +
                    "TOTALAMOUNTORDER, DISCOUNTAMOUNTORDER, PAYAMOUNT, ORDERSTATUSID) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, order.getOrderId());
            ps.setString(2, order.getCustomerId());
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis())); // Fixed Timestamp class name
            ps.setDouble(4, order.getTotalAmount());
            ps.setDouble(5, 0.0); // Default discount
            ps.setDouble(6, order.getTotalAmount());
            ps.setString(7, "OS001"); // Default status

            int result = ps.executeUpdate();
            ps.close();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("SQL Exception in addOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Generate new order ID
    public String generateOrderId() {
        String newId = "OR001";
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return newId;
            }

            String query = "SELECT MAX(ORDERID) FROM \"ADMIN\".\"ORDER\"";
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            if (rs.next() && rs.getString(1) != null) {
                String lastId = rs.getString(1);
                int number = Integer.parseInt(lastId.substring(2)) + 1;
                newId = String.format("OR%03d", number);
            }

            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.out.println("SQL Exception in generateOrderId: " + e.getMessage());
            e.printStackTrace();
        }
        return newId;
    }

    // Update order status
    public boolean updateOrderStatus(String orderId, String newStatus) {
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return false;
            }

            // First, get the ORDERSTATUSID for the given status
            String getStatusIdQuery = "SELECT ORDERSTATUSID FROM \"ADMIN\".\"ORDERSTATUS\" WHERE STATUS = ?";
            PreparedStatement psGetId = connection.prepareStatement(getStatusIdQuery);
            psGetId.setString(1, newStatus);

            String orderStatusId = null;

            // Try to get existing status ID
            try (java.sql.ResultSet rs = psGetId.executeQuery()) {
                if (rs.next()) {
                    orderStatusId = rs.getString("ORDERSTATUSID");
                }
            }

            // If no status ID exists for this status, create a new one
            if (orderStatusId == null) {
                // Generate a new ORDERSTATUSID (you may have a better way to generate IDs)
                orderStatusId = "OS" + System.currentTimeMillis();

                // Insert new status
                String insertStatusQuery = "INSERT INTO \"ADMIN\".\"ORDERSTATUS\" (ORDERSTATUSID, STATUS, UPDATED_AT) VALUES (?, ?, CURRENT_TIMESTAMP)";
                PreparedStatement psInsert = connection.prepareStatement(insertStatusQuery);
                psInsert.setString(1, orderStatusId);
                psInsert.setString(2, newStatus);
                psInsert.executeUpdate();
                psInsert.close();
            }

            // Now update the order with the status ID
            String updateOrderQuery = "UPDATE \"ADMIN\".\"ORDER\" SET ORDERSTATUSID = ? WHERE ORDERID = ?";
            PreparedStatement psUpdate = connection.prepareStatement(updateOrderQuery);
            psUpdate.setString(1, orderStatusId);
            psUpdate.setString(2, orderId);

            int result = psUpdate.executeUpdate();
            psUpdate.close();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("SQL Exception in updateOrderStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Delete order
    public boolean deleteOrder(String orderId) {
        try {
            if (connection == null) {
                System.out.println("Database connection is null");
                return false;
            }

            // First delete related reviews
            String deleteReviewsQuery = "DELETE FROM \"ADMIN\".\"REVIEW\" WHERE ORDERID = ?";
            PreparedStatement psReviews = connection.prepareStatement(deleteReviewsQuery);
            psReviews.setString(1, orderId);
            psReviews.executeUpdate();
            psReviews.close();

            // Then delete related order details
            String deleteDetailsQuery = "DELETE FROM \"ADMIN\".\"ORDERDETAILS\" WHERE ORDERID = ?";
            PreparedStatement psDetails = connection.prepareStatement(deleteDetailsQuery);
            psDetails.setString(1, orderId);
            psDetails.executeUpdate();
            psDetails.close();

            // Finally delete the order
            String deleteOrderQuery = "DELETE FROM \"ADMIN\".\"ORDER\" WHERE ORDERID = ?";
            PreparedStatement psOrder = connection.prepareStatement(deleteOrderQuery);
            psOrder.setString(1, orderId);

            int result = psOrder.executeUpdate();
            psOrder.close();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("SQL Exception in deleteOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
            e.printStackTrace();
        }
    }
}