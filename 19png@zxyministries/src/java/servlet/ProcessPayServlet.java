package servlet;

import java.io.IOException;
import java.sql.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import domain.CartItem;
import da.CartDAO;
import java.util.List;
import java.util.Map;


public class ProcessPayServlet extends HttpServlet {
    
    private String host = "jdbc:derby://localhost:1527/SkincareDB";
    private String user = "admin";
    private String password = "secret";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // 获取表单数据
            String paymentMethod = request.getParameter("paymentMethod");
            String shippingAddress = request.getParameter("shippingAddress");
            String contactPhone = request.getParameter("contactPhone");
            String orderId = request.getParameter("orderId");
            
            // 生成支付ID
            String paymentId = "PAY" + UUID.randomUUID().toString().substring(0, 8);
            
            // 生成地址ID
            String addressId = "ADDR" + UUID.randomUUID().toString().substring(0, 8);
            
            // 获取支付金额
            String finalTotalStr = request.getParameter("finalTotal");
            if (finalTotalStr != null && finalTotalStr.startsWith("RM ")) {
                finalTotalStr = finalTotalStr.substring(3);
            }
            double paymentAmount = Double.parseDouble(finalTotalStr);
            
            // 获取当前时间作为支付时间
            Timestamp paymentDate = new Timestamp(new Date().getTime());
            
            // 支付状态
            String paymentStatus = "COMPLETED";
            
            // 支付令牌
            String paymentToken = UUID.randomUUID().toString();
            
            // 支付确认
            String paymentConfirmation = "CONFIRMED";
            
            // 保存地址信息
            saveAddress(addressId, shippingAddress, contactPhone, orderId);
            
            // 保存支付信息
            savePayment(paymentId, addressId, paymentMethod, paymentDate, paymentAmount, 
                    paymentStatus, paymentToken, paymentConfirmation, orderId);
            
            // 将购物车项目从原始购物车数据复制到会话中
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.getAllItems(
                (Map<String, CartItem>) session.getAttribute("cart")
            );
            session.setAttribute("cartItems", cartItems);
            
            // 将支付信息存储在会话中，以便在收据页面显示
            session.setAttribute("transactionId", paymentId);
            session.setAttribute("paymentDate", paymentDate);
            session.setAttribute("paymentMethod", paymentMethod);
            session.setAttribute("paymentAmount", paymentAmount);
            session.setAttribute("shippingAddress", shippingAddress);
            
            // 添加购物车项目到会话，以便在收据页面显示
            // 确保购物车项目已经在会话中
            session.setAttribute("cartItems", session.getAttribute("cart"));
            
            // 添加小计、运费和销售税到会话
            String totalPrice = request.getParameter("totalPrice");
            if (totalPrice != null && totalPrice.startsWith("RM ")) {
                totalPrice = totalPrice.substring(3);
            }
            session.setAttribute("subtotal", totalPrice);
            
            String shippingCost = request.getParameter("shippingCost");
            if (shippingCost != null && shippingCost.startsWith("RM ")) {
                shippingCost = shippingCost.substring(3);
            }
            session.setAttribute("shippingCost", shippingCost);
            
            String salesTax = request.getParameter("salesTax");
            if (salesTax != null && salesTax.startsWith("RM ")) {
                salesTax = salesTax.substring(3);
            }
            session.setAttribute("salesTax", salesTax);
            
            // 重定向到收据页面
            response.sendRedirect("Receipt.jsp");
            
        } catch (SQLException e) {
            // 记录错误
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("Payment.jsp").forward(request, response);
        }
    }
    
    private void saveAddress(String addressId, String shippingAddress, String contactPhone, String orderId) 
            throws SQLException {
        
        String sql = "INSERT INTO \"ADMIN\".\"SHIPPINGADDRESS\" (ADDRESSID, ADDRESS, CONTACTPHONE, ORDERID) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(host, user, password);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, addressId);
            stmt.setString(2, shippingAddress);
            stmt.setString(3, contactPhone);
            stmt.setString(4, orderId);
            
            stmt.executeUpdate();
        }
    }
    
    private void savePayment(String paymentId, String addressId, String paymentMethod, 
            Timestamp paymentDate, double paymentAmount, String paymentStatus, 
            String paymentToken, String paymentConfirmation, String orderId) throws SQLException {
        
        String sql = "INSERT INTO \"ADMIN\".\"PAYMENT\" (PAYMENTID, ADDRESSID, PAYMENTMETHOD, PAYMENTDATE, PAYMENTAMOUNT, PAYMENTSTATUS, PAYMENTTOKEN, PAYMENTCONFIRMATION, ORDERID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(host, user, password);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, paymentId);
            stmt.setString(2, addressId);
            stmt.setString(3, paymentMethod);
            stmt.setTimestamp(4, paymentDate);
            stmt.setDouble(5, paymentAmount);
            stmt.setString(6, paymentStatus);
            stmt.setString(7, paymentToken);
            stmt.setString(8, paymentConfirmation);
            stmt.setString(9, orderId);
            
            stmt.executeUpdate();
        }
    }
}