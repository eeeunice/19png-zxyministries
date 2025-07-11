package servlet;

import da.FeedbackDAO;
import domain.Feedback;
import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "FeedbackServlet", urlPatterns = {"/FeedbackServlet"})
public class FeedbackServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String customerId = (String) session.getAttribute("customerId");
        
        if (customerId == null) {
            response.sendRedirect("Login_cust.jsp");
            return;
        }
        
        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            
            // Create new feedback
            Feedback feedback = new Feedback();
            feedback.setFeedbackId(request.getParameter("feedbackId"));
            feedback.setCustomerId(customerId);
            feedback.setRating(Integer.parseInt(request.getParameter("rating")));
            feedback.setComment(request.getParameter("comment"));
            feedback.setFeedbackDate(new Date());
            
            boolean success = feedbackDAO.addFeedback(feedback);
            
            if (success) {
                session.setAttribute("successMessage", "Thank you for your feedback!");
                response.sendRedirect("damn.jsp"); // Redirect to damm.jsp after successful submission
            } else {
                session.setAttribute("errorMessage", "Failed to submit feedback. Please try again.");
                response.sendRedirect("CustomerFeedback.jsp");
            }
            
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect("CustomerFeedback.jsp");
        }
    }
}