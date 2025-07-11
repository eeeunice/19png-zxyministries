package servlet;

import da.staffpro;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class DeleteStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DeleteStaffServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String staffId = request.getParameter("id");
        LOGGER.info("Received request to delete staff with ID: " + staffId);

        if (staffId == null || staffId.trim().isEmpty()) {
            response.sendRedirect("Staff_Management.jsp");
            return;
        }

        HttpSession session = request.getSession();

        try {
            boolean success = staffpro.deleteStaff(staffId);

            if (success) {
                session.setAttribute("successMessage", "Staff deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Staff deletion failed. Staff not found.");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during staff deletion", e);
            session.setAttribute("errorMessage", "Staff deletion failed due to an error: " + e.getMessage());
        }

        response.sendRedirect("Staff_Management.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests the same as GET
        doGet(request, response);
    }
}