//package servlet;
//
//import da.ReviewDAO;
//import domain.Order;
//import domain.Review;
//import java.io.File;
//import java.io.IOException;
//import java.sql.Timestamp;
//import java.time.Instant;
//import java.util.UUID;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.Part;
//
//@WebServlet(name = "CAddReviewServlet", urlPatterns = {"/CAddReviewServlet"})
//@MultipartConfig(
//    fileSizeThreshold = 1024 * 1024,    // 1MB
//    maxFileSize = 1024 * 1024 * 10,     // 10MB
//    maxRequestSize = 1024 * 1024 * 15    // 15MB
//)
//public class CAddReviewServlet extends HttpServlet {
//
//    private static final Logger logger = Logger.getLogger(CAddReviewServlet.class.getName());
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        response.setContentType("text/html;charset=UTF-8");
//        request.setCharacterEncoding("UTF-8");
//
//        String orderId = request.getParameter("orderId"); // Get orderId here
//        try {
//            // Get parameters from the form
//            String customerId = request.getParameter("customerId");
//            String productId = request.getParameter("productId");
//            double rating = Double.parseDouble(request.getParameter("rating"));
//            String comments = request.getParameter("comments");
//
//            // Handle image upload
//            Part filePart = request.getPart("image");
//            String imageUrl = null;
//
//            if (filePart != null && filePart.getSize() > 0) {
//                String fileName = getSubmittedFileName(filePart);
//                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
//                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "images";
//
//                File uploadDir = new File(uploadPath);
//                if (!uploadDir.exists()) {
//                    uploadDir.mkdir();
//                }
//
//                String filePath = uploadPath + File.separator + uniqueFileName;
//                filePart.write(filePath);
//                imageUrl = "images/" + uniqueFileName;
//            }
//
//            // Create a Review object
//            Review review = new Review();
//            review.setReviewId(UUID.randomUUID().toString().substring(0, 10)); // Generate a unique ReviewID
//            review.setCustomerId(customerId);
//            review.setProductId(productId);
//            review.setRating(rating);
//            review.setComments(comments);
//            review.setImageUrl(imageUrl);
//            review.setReviewDate(Timestamp.from(Instant.now())); // Set current timestamp
//            review.setCreatedAt(Timestamp.from(Instant.now()));
//            review.setOrderId(orderId);
//
//            // Add the review to the database
//            ReviewDAO reviewDAO = new ReviewDAO();
//            boolean success = reviewDAO.addReview(review);
//
//            if (success) {
//                // Redirect with success parameter
//                response.sendRedirect("CustomerReview.jsp?orderId=" + orderId + "&success=true");
//                return; // Important: Exit the method after redirecting
//            } else {
//                request.setAttribute("errorMessage", "Failed to add review.");
//            }
//
//        } catch (Exception e) {
//            logger.log(Level.SEVERE, "An exception occurred", e);
//            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
//        }
//
//        // If there was an error, forward back to the CustomerReview.jsp with the error message
//        ReviewDAO reviewDAO = new ReviewDAO();
//        Review existingReview = reviewDAO.getReviewByOrderId(orderId);
//        request.setAttribute("review", existingReview);
//        request.getRequestDispatcher("CustomerReview.jsp?orderId=" + orderId).forward(request, response);
//    }
//
//    private String getSubmittedFileName(Part part) {
//        String contentDisp = part.getHeader("content-disposition");
//        String[] tokens = contentDisp.split(";");
//        for (String token : tokens) {
//            if (token.trim().startsWith("filename")) {
//                String filename = token.substring(token.indexOf("=") + 2, token.length() - 1);
//                return filename.replace("\"", "");
//            }
//        }
//        return "";
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String orderId;
//        orderId = request.getParameter("orderId");
//        ReviewDAO reviewDAO = new ReviewDAO();
//        Review existingReview = reviewDAO.getReviewByOrderId(orderId);
//        request.setAttribute("review", existingReview);
//        request.setAttribute("orderId",orderId);
//        request.getRequestDispatcher("CustomerReview.jsp").forward(request, response);
//    }
//}