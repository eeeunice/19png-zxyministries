package servlet;

import da.StaffRe;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ResetStaffServlets")
public class ResetStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/reset_staff.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("resetEmail") : null;
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || email.isEmpty()) {
            request.setAttribute("errorMessage", "Session expired or invalid access. Please restart the reset process.");
            request.getRequestDispatcher("/forgot_staff.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Password fields cannot be empty.");
            request.getRequestDispatcher("/reset_staff.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() != 8) {
            request.setAttribute("errorMessage", "Password must be exactly 8 characters.");
            request.getRequestDispatcher("/reset_staff.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/reset_staff.jsp").forward(request, response);
            return;
        }

        StaffRe staffReset = new StaffRe();
        boolean success = false;

        if (staffReset.doesEmailExist(email)) {
            success = staffReset.resetPassword(email, newPassword);
        } else {
            request.setAttribute("errorMessage", "Email not found.");
            request.getRequestDispatcher("/reset_staff.jsp").forward(request, response);
            return;
        }

        staffReset.shutDown();

        if (success) {
            session.removeAttribute("resetEmail");
            response.sendRedirect("Login_Staff.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to reset password. Please try again.");
            request.getRequestDispatcher("/reset_staff.jsp").forward(request, response);
        }
    }
}
