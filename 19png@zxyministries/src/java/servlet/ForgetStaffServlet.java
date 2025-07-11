package servlet;

import da.StaffForg;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ForgetStaffServlets")
public class ForgetStaffServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForgetStaffServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        StaffForg staffForg = new StaffForg();

        if (email == null || email.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your email.");
            request.getRequestDispatcher("forgot_staff.jsp").forward(request, response);
            return;
        }

        try {
            // Check if email exists in the STAFF table
            boolean exists = staffForg.doesEmailExist(email);

            if (exists) {
                // Save email to session for future reset step
                HttpSession session = request.getSession();
                session.setAttribute("resetEmail", email);

                request.setAttribute("successMessage", "Email found. You will receive a reset link or continue to reset password.");
                request.getRequestDispatcher("reset_staff.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Email not found. Please try again.");
                request.getRequestDispatcher("forgot_staff.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database query failed", e);
            request.setAttribute("errorMessage", "An error occurred while processing your request. Please try again later.");
            request.getRequestDispatcher("forgot_staff.jsp").forward(request, response);
        } finally {
            staffForg.shutDown();
        }
    }
}
