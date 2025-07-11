package servlet;

import da.OrderDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DeleteOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Get order ID parameter
        String orderId = request.getParameter("orderId");

        // Validate parameter
        if (orderId == null || orderId.trim().isEmpty()) {
            session.setAttribute("statusMessage", "Invalid order ID");
            session.setAttribute("statusType", "danger");
            response.sendRedirect("Orders_Manager.jsp");
            return;
        }

        // Delete order
        OrderDAO orderDAO = new OrderDAO();
        boolean success = false;

        try {
            // The deleteOrder method in OrderDAO already handles deleting related order
            // details
            success = orderDAO.deleteOrder(orderId);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error deleting order: " + e.getMessage());
        } finally {
            orderDAO.closeConnection();
        }

        // Set response message
        if (success) {
            session.setAttribute("statusMessage", "Order deleted successfully");
            session.setAttribute("statusType", "success");
        } else {
            session.setAttribute("statusMessage", "Failed to delete order. Check server logs for details.");
            session.setAttribute("statusType", "danger");
        }

        // Redirect to orders list
        response.sendRedirect("Orders_Manager.jsp");
    }
}