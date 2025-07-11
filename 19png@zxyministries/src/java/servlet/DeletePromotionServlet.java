package servlet;

import da.PromotionDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class DeletePromotionServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Get promotion ID from request
            String promotionId = request.getParameter("id");
            
            if (promotionId == null || promotionId.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Invalid promotion ID");
                request.getRequestDispatcher("Promotion_Discount_Manager.jsp").forward(request, response);
                return;
            }
            
            // Delete promotion from database
            PromotionDAO promotionDAO = new PromotionDAO();
            boolean success = promotionDAO.deletePromotion(promotionId);
            
            if (success) {
                request.setAttribute("successMessage", "Promotion deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete promotion. Please try again.");
            }
            
            // Close database connection
            promotionDAO.closeConnection();
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Redirect back to promotion page
        request.getRequestDispatcher("Promotion_Discount_Manager.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles deletion of promotions";
    }
}