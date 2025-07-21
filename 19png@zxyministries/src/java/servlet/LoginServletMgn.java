package servlet;

import da.ManagerLog;
import domain.ManagerLogin;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServletMgn")
public class LoginServletMgn extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve email and password from form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Create ManagerLog object to validate login
        ManagerLog managerLog = new ManagerLog();
        ManagerLogin manager = managerLog.validateLogin(email, password);

        // Check if manager exists
        if (manager != null) {
            // Set session attributes and redirect to Manager_Dashboard.jsp
            HttpSession session = request.getSession();
            session.setAttribute("managerId", manager.getManagerId());
            session.setAttribute("managerName", manager.getManagerName());
            session.setAttribute("managerEmail", manager.getManagerEmail());
            session.setAttribute("managerUsername", manager.getManagerUsername());
            response.sendRedirect("Manager_Dashboard.jsp"); // Changed from submit.jsp
        } else {
            // If login fails, show error and return to login page
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("Login_mgn.jsp").forward(request, response);
        }

        // Close the database connection
        managerLog.shutDown();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Login_mgn.jsp");
    }
}
