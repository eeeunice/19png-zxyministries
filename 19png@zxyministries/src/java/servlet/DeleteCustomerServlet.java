package servlet;
import service.CustomerDeletionService;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DeleteCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DeleteCustomerServlet.class.getName());

    private final CustomerDeletionService deletionService;

    public DeleteCustomerServlet() {
        this.deletionService = new CustomerDeletionService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerId = request.getParameter("id");
        LOGGER.info("Received request to delete customer with ID: " + customerId);

        if (customerId == null || customerId.trim().isEmpty()) {
            response.sendRedirect("Manager_Customers.jsp");
            return;
        }

        HttpSession session = request.getSession();

        try {
            boolean success = deletionService.deleteCustomer(customerId);

            if (success) {
                session.setAttribute("successMessage", "Customer deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Customer deletion failed. Customer not found.");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during customer deletion", e);

            // Check for remaining records that might be preventing deletion
            String remainingRecords = deletionService.checkRemainingRecords(customerId);

            if (remainingRecords != null) {
                LOGGER.info("Found remaining records: " + remainingRecords);
                session.setAttribute("errorMessage",
                        "Customer deletion failed due to related records: " + remainingRecords);
            } else {
                session.setAttribute("errorMessage", "Customer deletion failed due to an error: " + e.getMessage());
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during customer deletion", e);
            session.setAttribute("errorMessage",
                    "Customer deletion failed due to an unexpected error: " + e.getMessage());
        }

        response.sendRedirect("Manager_Customers.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests the same as GET
        doGet(request, response);
    }
}