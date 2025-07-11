package servlet;

import da.ManagerDAO;
import domain.Manager;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateManagerServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Get form data
            String managerId = request.getParameter("managerId");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String username = request.getParameter("username");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            
            // Create manager object
            Manager manager = new Manager();
            manager.setManagerId(managerId);
            manager.setName(name);
            manager.setEmail(email);
            manager.setPhone(phone);
            manager.setUsername(username);
            
            // Update manager information
            ManagerDAO managerDAO = new ManagerDAO();
            boolean success = managerDAO.updateManager(manager, currentPassword);
            
            if (success) {
                // Update session data
                HttpSession session = request.getSession();
                session.setAttribute("managerName", name);
                
                // Update password if provided
                if (newPassword != null && !newPassword.isEmpty()) {
                    boolean passwordUpdated = managerDAO.updateManagerPassword(managerId, currentPassword, newPassword);
                    if (passwordUpdated) {
                        request.setAttribute("successMessage", "Profile and password updated successfully!");
                    } else {
                        request.setAttribute("successMessage", "Profile updated successfully, but password update failed.");
                    }
                } else {
                    request.setAttribute("successMessage", "Profile updated successfully!");
                }
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please check your current password.");
            }
            
            // Close database connection
            managerDAO.closeConnection();
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Redirect back to profile page
        request.getRequestDispatcher("ManagerProfile.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Updates manager profile information";
    }
}