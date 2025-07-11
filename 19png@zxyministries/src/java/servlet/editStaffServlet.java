package servlet;

import da.staffpro;
import domain.staffprofile;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;


public class editStaffServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String staffId = request.getParameter("staffId");
        String staffName = request.getParameter("staffName");
        String staffEmail = request.getParameter("staffEmail");
        String staffPhone = request.getParameter("staffPhone");
        String staffPassword = request.getParameter("staffPassword");

        // Create updated staff object
        staffprofile updatedStaff = new staffprofile(staffId, staffName, staffEmail, staffPhone, staffPassword, ""); // Role unchanged

        boolean success = staffpro.updateStaffProfile(updatedStaff);

        if (success) {
            // Update session
            HttpSession session = request.getSession();
            session.setAttribute("staffId", staffId);
            session.setAttribute("staffName", staffName);
            session.setAttribute("staffEmail", staffEmail);
            session.setAttribute("staffPhone", staffPhone);
            session.setAttribute("staffPassword", staffPassword);
            // Redirect to profile page
            response.sendRedirect("staffProfileServlets");
        } else {
            request.setAttribute("errorMessage", "Failed to update profile.");
            request.getRequestDispatcher("editStaff.jsp").forward(request, response);
        }
    }
}
