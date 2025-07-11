//package servlet;
//
//import da.ReviewDAO;
//import domain.Review;
//import java.io.IOException;
//import java.util.Date;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//@WebServlet(name = "ReviewServlet", urlPatterns = {"/ReviewServlet"})
//public class ReviewServlet extends HttpServlet {
//    
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        HttpSession session = request.getSession();
//        String action = request.getParameter("action");
//        ReviewDAO reviewDAO = new ReviewDAO();
//        
//        if ("addReview".equals(action)) {
//            String customerId = (String) session.getAttribute("customerId");
//            if (customerId == null) {
//                response.sendRedirect("Login_cust.jsp");
//                return;
//            }
//            
//            Review review = new Review();
//            review.setReviewId(reviewDAO.generateReviewId());
//            review.setCustomerId(customerId);
//            review.setOrderId(request.getParameter("orderId"));
//            review.setRating(Integer.parseInt(request.getParameter("rating")));
//            review.setComments(request.getParameter("comments"));
//            review.setReviewDate(new Date());
//            review.setImageUrl(request.getParameter("imageUrl"));
//            
//            if (reviewDAO.addReview(review)) {
//                session.setAttribute("successMessage", "Review submitted successfully!");
//            } else {
//                session.setAttribute("errorMessage", "Failed to submit review. Please try again.");
//            }
//            response.sendRedirect("CustomerReviews.jsp");
//            
//        } else if ("addReply".equals(action)) {
//            String staffId = (String) session.getAttribute("staffId");
//            String managerId = (String) session.getAttribute("managerId");
//            
//            if (staffId == null && managerId == null) {
//                response.sendRedirect("Login_staff.jsp");
//                return;
//            }
//            
//            String reviewId = request.getParameter("reviewId");
//            String reply = request.getParameter("reply");
//            String replyBy = staffId != null ? staffId : managerId;
//            
//            if (reviewDAO.addReply(reviewId, reply, replyBy)) {
//                session.setAttribute("successMessage", "Reply added successfully!");
//            } else {
//                session.setAttribute("errorMessage", "Failed to add reply. Please try again.");
//            }
//            response.sendRedirect("ViewReviews.jsp");
//        }
//    }
//}