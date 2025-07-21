package servlet;

import da.StaffLog;
import domain.StaffLogin;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServletStaff")
public class LoginServletStaff extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve email and password from form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Create StaffLog object to validate login
        StaffLog staffLog = new StaffLog();
        StaffLogin staff = staffLog.validateLogin(username, password);

        // Check if staff exists
        if (staff != null) {
            // Set session attributes and redirect to submit.jsp
            HttpSession session = request.getSession();
            session.setAttribute("staffId", staff.getStaffId());
            session.setAttribute("staffName", staff.getStaffName());
            session.setAttribute("staffEmail", staff.getStaffEmail());
            session.setAttribute("staffPhone", staff.getStaffPhone());
            session.setAttribute("staffPassword", staff.getStaffPassword());
            session.setAttribute("staffRole", staff.getRole());
            response.sendRedirect("Staff_Dashboard.jsp"); // ✅ Redirect to submit.jsp
        } else {
            // If login fails, show error and return to login page
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("Login_staff.jsp").forward(request, response);
        }

        // Close the database connection
        staffLog.shutDown();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Login_staff.jsp");
    }
}
