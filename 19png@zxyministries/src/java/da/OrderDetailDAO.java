package da;

import domain.OrderDetail;
import domain.Products;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO {
    private Connection connection;

    public OrderDetailDAO() {
        try {
            DatabaseLink db = new DatabaseLink();
            connection = db.getConnection();
        } catch (Exception e) {
            System.out.println("Connection error: " + e.getMessage());
        }
    }

    public String generateOrderDetailId() {
        String newId = "ORD001";
        try {
            String query = "SELECT MAX(ORDERDETAILSID) FROM ADMIN.ORDERDETAILS";
            PreparedStatement stmt = connection.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            if (rs.next() && rs.getString(1) != null) {
                String lastId = rs.getString(1);
                int number = Integer.parseInt(lastId.substring(2)) + 1;
                newId = String.format("ORD%03d", number);
            }
        } catch (SQLException e) {
            System.out.println("Error generating order detail ID: " + e.getMessage());
        }
        return newId;
    }

    public boolean addOrderDetail(OrderDetail orderDetail) {
        String query = "INSERT INTO ADMIN.ORDERDETAILS (ORDERDETAILSID, ORDERID, PRODUCT_ID, QUANTITY, " +
                "UNITPRICE, TOTALAMOUNTPRODUCT, DISCOUNTAMOUNTPRODUCT) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, orderDetail.getOrderDetailsId());
            stmt.setString(2, orderDetail.getOrderId());
            stmt.setString(3, orderDetail.getProductId());
            stmt.setInt(4, orderDetail.getQuantity());
            stmt.setDouble(5, orderDetail.getUnitPrice());
            stmt.setDouble(6, orderDetail.getTotalAmountProduct());
            stmt.setDouble(7, orderDetail.getDiscountAmountProduct());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding order detail: " + e.getMessage());
            return false;
        }
    }

    public List<OrderDetail> getOrderDetailsByOrderId(String orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String query = "SELECT od.*, p.PRODUCT_NAME, p.PRICE, p.BRAND, p.IMAGE_URL FROM ADMIN.ORDERDETAILS od " +
                  "JOIN ADMIN.PRODUCTS p ON od.PRODUCT_ID = p.PRODUCT_ID " +
                  "WHERE od.ORDERID = ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailsId(rs.getString("ORDERDETAILSID"));
                detail.setOrderId(rs.getString("ORDERID"));
                detail.setProductId(rs.getString("PRODUCT_ID"));
                detail.setQuantity(rs.getInt("QUANTITY"));
                detail.setUnitPrice(rs.getDouble("UNITPRICE"));
                detail.setTotalAmountProduct(rs.getDouble("TOTALAMOUNTPRODUCT"));
                detail.setDiscountAmountProduct(rs.getDouble("DISCOUNTAMOUNTPRODUCT"));

                // Set the associated product with additional fields
                Products product = new Products();
                product.setProductId(rs.getString("PRODUCT_ID"));
                product.setProductName(rs.getString("PRODUCT_NAME"));
                product.setPrice(rs.getDouble("PRICE"));
                product.setImageUrl(rs.getString("IMAGE_URL"));
                detail.setProduct(product);

                orderDetails.add(detail);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving order details: " + e.getMessage());
        }
        return orderDetails;
    }

    public boolean updateOrderDetail(OrderDetail orderDetail) {
        String query = "UPDATE ADMIN.ORDERDETAILS SET QUANTITY = ?, UNITPRICE = ?, " +
                "TOTALAMOUNTPRODUCT = ?, DISCOUNTAMOUNTPRODUCT = ? " +
                "WHERE ORDERDETAILSID = ?";
        try {
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, orderDetail.getQuantity());
            stmt.setDouble(2, orderDetail.getUnitPrice());
            stmt.setDouble(3, orderDetail.getTotalAmountProduct());
            stmt.setDouble(4, orderDetail.getDiscountAmountProduct());
            stmt.setString(5, orderDetail.getOrderDetailsId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating order detail: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteOrderDetail(String orderDetailId) {
        String query = "DELETE FROM ADMIN.ORDERDETAILS WHERE ORDERDETAILSID = ?";
        try {
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, orderDetailId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting order detail: " + e.getMessage());
            return false;
        }
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
}
