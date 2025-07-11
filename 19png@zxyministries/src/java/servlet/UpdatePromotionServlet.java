package servlet;

import da.PromotionDAO;
import domain.Promotion;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdatePromotionServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        PromotionDAO promotionDAO = null;
        
        try {
            // Get form parameters
            String promotionId = request.getParameter("promotionId");
            String promotionName = request.getParameter("promotionName");
            String promotionType = request.getParameter("discountType");
            String discountValue = request.getParameter("discountValue");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String promotionCode = request.getParameter("promotionCode");
            String description = request.getParameter("description");
            
            // Validate required fields
            if (promotionId == null || promotionId.trim().isEmpty() ||
                promotionName == null || promotionName.trim().isEmpty() ||
                promotionType == null || promotionType.trim().isEmpty() ||
                discountValue == null || discountValue.trim().isEmpty() ||
                startDateStr == null || startDateStr.trim().isEmpty() ||
                endDateStr == null || endDateStr.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "All required fields must be filled");
                request.getRequestDispatcher("EditPromotion.jsp?id=" + promotionId).forward(request, response);
                return;
            }
            
            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = dateFormat.parse(startDateStr);
            Date endDate = dateFormat.parse(endDateStr);
            
            // Validate date range
            if (endDate.before(startDate)) {
                request.setAttribute("errorMessage", "End date cannot be before start date");
                request.getRequestDispatcher("EditPromotion.jsp?id=" + promotionId).forward(request, response);
                return;
            }
            
            // Get manager ID from session
            HttpSession session = request.getSession();
            String managerId = (String) session.getAttribute("managerId");
            
            // Check if managerId is null and handle it
            if (managerId == null) {
                request.setAttribute("errorMessage", "Your session has expired. Please log in again.");
                request.getRequestDispatcher("Login_mgn.jsp").forward(request, response);
                return;
            }
            
            // Create Promotion object
            Promotion promotion = new Promotion();
            promotion.setPromotionId(promotionId);
            promotion.setPromotionName(promotionName);
            promotion.setPromotionType(promotionType);
            
            // Use the actual promotion code if provided
            if (promotionCode != null && !promotionCode.trim().isEmpty()) {
                promotion.setPromotionCode(promotionCode);
            } else {
                promotion.setPromotionCode(discountValue);
            }
            
            promotion.setStartDate(new Timestamp(startDate.getTime()));
            promotion.setEndDate(new Timestamp(endDate.getTime()));
            promotion.setDescription(description);
            promotion.setManagerId(managerId);
            
            // Update in database
            promotionDAO = new PromotionDAO();
            boolean success = promotionDAO.updatePromotion(promotion);
            
            if (success) {
                // Set success message in session
                session.setAttribute("successMessage", "Promotion updated successfully!");
                
                // Redirect back to promotion page
                response.sendRedirect("Promotion_Discount_Manager.jsp");
                return;
            } else {
                request.setAttribute("errorMessage", "Failed to update promotion. Please try again.");
                request.getRequestDispatcher("EditPromotion.jsp?id=" + promotionId).forward(request, response);
                return;
            }
            
        } catch (ParseException e) {
            request.setAttribute("errorMessage", "Invalid date format");
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close database connection
            if (promotionDAO != null) {
                promotionDAO.closeConnection();
            }
        }
        
        // Redirect back to edit page in case of error
        String promotionId = request.getParameter("promotionId");
        if (promotionId != null) {
            request.getRequestDispatcher("EditPromotion.jsp?id=" + promotionId).forward(request, response);
        } else {
            response.sendRedirect("Promotion_Discount_Manager.jsp");
        }
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
        return "Handles updating of promotions";
    }
}