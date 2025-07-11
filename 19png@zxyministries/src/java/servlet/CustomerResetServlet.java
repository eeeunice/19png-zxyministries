package servlet;

import da.CustomerRe;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/CustomerResetServlets")
public class CustomerResetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/reset_cust.jsp");
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
            request.getRequestDispatcher("/forgot_cust.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Password fields cannot be empty.");
            request.getRequestDispatcher("/reset_cust.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() != 8) {
            request.setAttribute("errorMessage", "Password must be exactly 8 characters.");
            request.getRequestDispatcher("/reset_cust.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/reset_cust.jsp").forward(request, response);
            return;
        }

        CustomerRe customerReset = new CustomerRe();
        boolean success = false;

        if (customerReset.doesEmailExist(email)) {
            success = customerReset.resetPassword(email, newPassword);
        } else {
            request.setAttribute("errorMessage", "Email not found.");
        }

        customerReset.shutDown();

        if (success) {
            session.removeAttribute("resetEmail");
            response.sendRedirect("Login_cust.jsp");
        } else {
            if (request.getAttribute("errorMessage") == null) {
                request.setAttribute("errorMessage", "Failed to reset password. Please try again.");
            }
            request.getRequestDispatcher("/reset_cust.jsp").forward(request, response);
        }
    }
}