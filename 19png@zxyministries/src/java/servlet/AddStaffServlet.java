package servlet;

import da.staffpro;
import domain.staffprofile;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddStaffServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters
        String staffName = request.getParameter("staffName");
        String staffEmail = request.getParameter("staffEmail");
        String staffPhone = request.getParameter("staffPhone");
        String staffPassword = request.getParameter("staffPassword");
        String staffRole = request.getParameter("staffRole");
        
        // Check if custom role was selected
        if ("custom".equals(staffRole)) {
            String customRole = request.getParameter("customRole");
            if (customRole != null && !customRole.trim().isEmpty()) {
                staffRole = customRole.trim();
            }
        }
        
        // Create a new staff object (with empty ID as it will be generated)
        staffprofile newStaff = new staffprofile("", staffName, staffEmail, staffPhone, staffPassword, staffRole);
        
        // Add the staff to the database
        boolean success = staffpro.addStaff(newStaff);
        
        // Set session attribute for success message
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", "Staff member added successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to add staff member. Please try again.");
        }
        
        // Redirect back to staff management page
        response.sendRedirect("Staff_Management.jsp");
    }
}