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
import java.sql.Connection;

@WebServlet(name = "SubmitReviewServlet", urlPatterns = {"/SubmitReviewServlet"})
public class SubmitReviewServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String customerId = request.getParameter("customerId");
        
        if (customerId == null) {
            response.sendRedirect("Login_cust.jsp");
            return;
        }
        
        DatabaseLink dbLink = new DatabaseLink();
        Connection connection = dbLink.getConnection();
        
        try {
            ReviewDAO reviewDAO = new ReviewDAO(connection);
            
            // Create new review
            Review review = new Review();
            review.setReviewId(request.getParameter("reviewId")); // Get the review ID from the hidden field
            review.setCustomerId(customerId);
            review.setRating(Double.parseDouble(request.getParameter("rating")));
            review.setComments(request.getParameter("comments"));
            review.setReviewDate(new Date());
            review.setCreatedAt(new Date());
            review.setOrderId(request.getParameter("orderId")); // Set Order ID
            
            boolean success = reviewDAO.addReview(review);
            
            if (success) {
                session.setAttribute("successMessage", "Thank you for your review!");
            } else {
                session.setAttribute("errorMessage", "Failed to submit review. Please try again.");
            }
            
            response.sendRedirect("orderCustomer.jsp"); // Redirect to orderCustomer.jsp
            
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect("orderCustomer.jsp");
        } finally {
            dbLink.shutDown(); // Close the database connection
        }
    }
}