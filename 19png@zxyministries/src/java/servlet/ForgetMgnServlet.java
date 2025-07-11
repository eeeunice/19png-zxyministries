package servlet;

import da.ManagerForg;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ForgetMgnServlets")
public class ForgetMgnServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForgetMgnServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        ManagerForg managerForg = new ManagerForg();

        if (email == null || email.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your email.");
            request.getRequestDispatcher("forgot_mgn.jsp").forward(request, response);
            return;
        }

        try {
            // Check if email exists in the database
            boolean exists = managerForg.doesEmailExist(email);

            if (exists) {
                // Save email to session for future reset step
                HttpSession session = request.getSession();
                session.setAttribute("resetEmail", email);

                request.setAttribute("successMessage", "Email found. You will receive a reset link or continue to reset password.");
                request.getRequestDispatcher("reset_mgn.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Email not found. Please try again.");
                request.getRequestDispatcher("forgot_mgn.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database query failed", e);
            request.setAttribute("errorMessage", "An error occurred while processing your request. Please try again later.");
            request.getRequestDispatcher("forgot_mgn.jsp").forward(request, response);
        } finally {
            // Ensure database connection is closed
            managerForg.shutDown();
        }
    }
}
