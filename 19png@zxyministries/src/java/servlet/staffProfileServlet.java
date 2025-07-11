package servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/staffProfileServlets")
public class staffProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session data
        HttpSession session = request.getSession();
        String staffId = (String) session.getAttribute("staffId");
        String staffName = (String) session.getAttribute("staffName");
        String staffEmail = (String) session.getAttribute("staffEmail");
        String staffPhone = (String) session.getAttribute("staffPhone");
        String staffPassword = (String) session.getAttribute("staffPassword");
        String staffRole = (String) session.getAttribute("staffRole");

        // If session data is not available (not logged in), redirect to login
        if (staffId == null) {
            response.sendRedirect("Login_staff.jsp");
            return;
        }

        // Forward to the profile page
        request.setAttribute("staffId", staffId);
        request.setAttribute("staffName", staffName);
        request.setAttribute("staffEmail", staffEmail);
        request.setAttribute("staffPhone", staffPhone);
        request.setAttribute("staffPassword", staffPassword);
        request.setAttribute("staffRole", staffRole);
        request.getRequestDispatcher("staffProfile.jsp").forward(request, response);
    }
}
