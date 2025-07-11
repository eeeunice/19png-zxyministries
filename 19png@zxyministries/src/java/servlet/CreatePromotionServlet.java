package servlet;

import da.PromotionDAO;
import domain.Promotion;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class CreatePromotionServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        PromotionDAO promotionDAO = null;
        
        try {
            // Get form parameters
            String promotionName = request.getParameter("promotionName");
            String promotionType = request.getParameter("discountType");
            String discountValue = request.getParameter("discountValue");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String promotionCode = request.getParameter("promotionCode");
            String applicableProducts = request.getParameter("applicableProducts");
            String minPurchaseStr = request.getParameter("minPurchase");
            String maxUsesStr = request.getParameter("maxUses");
            String description = request.getParameter("description");
            
            // Validate required fields
            if (promotionName == null || promotionName.trim().isEmpty() ||
                promotionType == null || promotionType.trim().isEmpty() ||
                discountValue == null || discountValue.trim().isEmpty() ||
                startDateStr == null || startDateStr.trim().isEmpty() ||
                endDateStr == null || endDateStr.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "All required fields must be filled");
                request.getRequestDispatcher("Promotion_Discount_Manager.jsp").forward(request, response);
                return;
            }
            
            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = dateFormat.parse(startDateStr);
            Date endDate = dateFormat.parse(endDateStr);
            
            // Validate date range
            if (endDate.before(startDate)) {
                request.setAttribute("errorMessage", "End date cannot be before start date");
                request.getRequestDispatcher("Promotion_Discount_Manager.jsp").forward(request, response);
                return;
            }
            
            // Generate unique promotion ID
            String promotionId = "PROMO" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            // Get manager ID from session
            HttpSession session = request.getSession();
            String managerId = (String) session.getAttribute("managerId");
            
            // Check if managerId is null and handle it
            if (managerId == null) {
                // Either redirect to login or use a default value
                request.setAttribute("errorMessage", "Your session has expired. Please log in again.");
                request.getRequestDispatcher("Login_mgn.jsp").forward(request, response);
                return;
            }
            
            // Create Promotion object
            Promotion promotion = new Promotion();
            promotion.setPromotionId(promotionId);
            promotion.setPromotionName(promotionName);
            promotion.setPromotionType(promotionType);
            
            // Fix: Use the actual promotion code if provided, otherwise use a truncated discount value
            if (promotionCode != null && !promotionCode.trim().isEmpty()) {
                // Ensure the promotion code doesn't exceed 10 characters
                if (promotionCode.length() > 10) {
                    promotionCode = promotionCode.substring(0, 10);
                }
                promotion.setPromotionCode(promotionCode);
            } else {
                // If no promotion code provided, use a truncated version of the discount value
                String codeValue = discountValue;
                if (codeValue.length() > 10) {
                    codeValue = codeValue.substring(0, 10);
                }
                promotion.setPromotionCode(codeValue);
            }
            
            promotion.setStartDate(new Timestamp(startDate.getTime()));
            promotion.setEndDate(new Timestamp(endDate.getTime()));
            promotion.setDescription(description);
            promotion.setManagerId(managerId);
            
            // Save to database
            promotionDAO = new PromotionDAO();
            boolean success = promotionDAO.createPromotion(promotion);
            
            if (success) {
                // Handle associations with specific products or categories
                if ("category".equals(applicableProducts)) {
                    // Get the selected category ID from the form
                    String categoryId = request.getParameter("categoryId");
                    if (categoryId != null && !categoryId.trim().isEmpty()) {
                        // Create association between promotion and category
                        boolean categoryAssociated = promotionDAO.associatePromotionWithCategory(promotionId, categoryId);
                        if (!categoryAssociated) {
                            // Log the issue but continue with success message
                            System.out.println("Warning: Failed to associate promotion with category");
                        }
                    }
                } else if ("product".equals(applicableProducts)) {
                    // Get the selected product IDs from the form
                    String[] productIds = request.getParameterValues("productIds");
                    if (productIds != null && productIds.length > 0) {
                        // Create associations between promotion and products
                        boolean allProductsAssociated = true;
                        for (String productId : productIds) {
                            boolean productAssociated = promotionDAO.associatePromotionWithProduct(promotionId, productId);
                            if (!productAssociated) {
                                allProductsAssociated = false;
                                // Log the issue but continue with other products
                                System.out.println("Warning: Failed to associate promotion with product: " + productId);
                            }
                        }
                        if (!allProductsAssociated) {
                            // Log the overall issue but continue with success message
                            System.out.println("Warning: Some products could not be associated with the promotion");
                        }
                    }
                }
                
                // Set success message in session instead of request
                session.setAttribute("successMessage", "Promotion created successfully!");
                
                // Redirect back to promotion page instead of forwarding
                response.sendRedirect("Promotion_Discount_Manager.jsp");
                return; // Important: stop processing after redirect
            } else {
                request.setAttribute("errorMessage", "Failed to create promotion. Please try again.");
                // Forward to the page in case of error
                request.getRequestDispatcher("Promotion_Discount_Manager.jsp").forward(request, response);
                return;
            }
            
        } catch (ParseException e) {
            request.setAttribute("errorMessage", "Invalid date format");
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close database connection in finally block to ensure it always executes
            if (promotionDAO != null) {
                promotionDAO.closeConnection();
            }
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
        return "Handles creation of new promotions";
    }
}