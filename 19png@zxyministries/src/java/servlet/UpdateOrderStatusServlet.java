package servlet;

import da.OrderDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Get parameters
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status");
        String source = request.getParameter("source"); // New parameter to identify the source page

        // Map form values to database values
        if ("Delivered".equals(newStatus)) {
            newStatus = "Delivery";
        } else if ("Shipped".equals(newStatus)) {
            newStatus = "Shipping";
        }

        // Capitalize first letter of status to match database values
        if (newStatus != null && !newStatus.isEmpty()) {
            newStatus = newStatus.substring(0, 1).toUpperCase() + newStatus.substring(1);
        }

        // Validate parameters
        if (orderId == null || orderId.trim().isEmpty() || newStatus == null || newStatus.trim().isEmpty()) {
            session.setAttribute("statusMessage", "Invalid request parameters");
            session.setAttribute("statusType", "danger");
            
            // Redirect based on source
            if ("staff".equals(source)) {
                response.sendRedirect("Staff_Orders.jsp");
            } else {
                response.sendRedirect("Orders_Manager.jsp");
            }
            return;
        }

        // Update order status
        OrderDAO orderDAO = new OrderDAO();
        boolean success = false;

        try {
            success = orderDAO.updateOrderStatus(orderId, newStatus);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            orderDAO.closeConnection();
        }

        // Set response message
        if (success) {
            session.setAttribute("statusMessage", "Order status updated successfully");
            session.setAttribute("statusType", "success");
        } else {
            session.setAttribute("statusMessage", "Failed to update order status");
            session.setAttribute("statusType", "danger");
        }

        // Redirect based on source
        if ("staff".equals(source)) {
            response.sendRedirect("Staff_Orders.jsp");
        } else {
            // Default to order details page for manager
            response.sendRedirect("OrderDetails.jsp?id=" + orderId);
        }
    }
}