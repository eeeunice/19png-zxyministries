package servlet;

import da.staffpro;
import domain.staffprofile;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class editStaffManagerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String staffId = request.getParameter("staffId");
        String staffName = request.getParameter("staffName");
        String staffEmail = request.getParameter("staffEmail");
        String staffPhone = request.getParameter("staffPhone");
        String staffPassword = request.getParameter("staffPassword");
        String staffRole = request.getParameter("staffRole");
        
        // Check if custom role was selected
        if ("custom".equals(staffRole)) {
            staffRole = request.getParameter("customRole");
        }

        // Create updated staff object
        staffprofile updatedStaff = new staffprofile(staffId, staffName, staffEmail, staffPhone, staffPassword, staffRole);

        boolean success = staffpro.updateStaffProfile(updatedStaff);

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", "Staff information updated successfully!");
            // Redirect back to staff management page
            response.sendRedirect("Staff_Management.jsp");
        } else {
            session.setAttribute("errorMessage", "Failed to update staff information.");
            response.sendRedirect("editStaffManager.jsp?id=" + staffId);
        }
    }
}