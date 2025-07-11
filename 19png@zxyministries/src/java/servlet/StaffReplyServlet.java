package servlet;

import da.DatabaseLink;
import da.ReviewDAO;
import domain.Review;
import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "StaffReplyServlet", urlPatterns = {"/StaffReplyServlet"})
public class StaffReplyServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String staffId = (String) session.getAttribute("staffId");
        
        // Check if staff is logged in
        if (staffId == null) {
            session.setAttribute("message", "Please login first!");
            session.setAttribute("messageType", "danger");
            response.sendRedirect("Login_Staff.jsp");
            return;
        }
        
        String reviewId = request.getParameter("reviewId");
        String replyText = request.getParameter("reply");
        
        // Validate input
        if (reviewId == null || reviewId.trim().isEmpty() || 
            replyText == null || replyText.trim().isEmpty()) {
            session.setAttribute("message", "Review ID and reply text are required.");
            session.setAttribute("messageType", "danger");
            response.sendRedirect("Staff_Review.jsp");
            return;
        }
        
        DatabaseLink dbLink = new DatabaseLink();
        
        try {
            ReviewDAO reviewDAO = new ReviewDAO(dbLink.getConnection());
            
            // Get the existing review
            Review review = reviewDAO.getReviewById(reviewId);
            
            if (review != null) {
                // Update the review with reply
                review.setReply(replyText);
                review.setReplyBy(staffId);
                review.setReplyAt(new Date());
                
                // Save the updated review
                boolean success = reviewDAO.updateReview(review);
                
                if (success) {
                    session.setAttribute("message", "Reply submitted successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to submit reply. Please try again.");
                    session.setAttribute("messageType", "danger");
                }
            } else {
                session.setAttribute("message", "Review not found.");
                session.setAttribute("messageType", "danger");
            }
            
        } catch (Exception e) {
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "danger");
            e.printStackTrace();
        } finally {
            dbLink.shutDown(); // Close the database connection
        }
        
        // Redirect back to the review management page
        response.sendRedirect("Staff_Review.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the review management page
        response.sendRedirect("Staff_Review.jsp");
    }
}