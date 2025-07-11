<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="domain.Products" %>
<%@ page import="da.ProductDAO" %>
<%@ page import="domain.Categories" %>
<%@ page import="da.CategoryDAO" %>
<%@ page import="domain.Promotion" %>
<%@ page import="da.PromotionDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Get promotion ID from request
    String promotionId = request.getParameter("id");
    
    if (promotionId == null || promotionId.trim().isEmpty()) {
        response.sendRedirect("Promotion_Discount_Manager.jsp");
        return;
    }
    
    // Get promotion details
    PromotionDAO promotionDAO = new PromotionDAO();
    Promotion promotion = promotionDAO.getPromotionById(promotionId);
    
    if (promotion == null) {
        response.sendRedirect("Promotion_Discount_Manager.jsp");
        return;
    }
    
    // Format dates for form
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String startDate = dateFormat.format(promotion.getStartDate());
    String endDate = dateFormat.format(promotion.getEndDate());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Promotion</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <style>
        /* Additional styles for promotion management */
        .promotion-form {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }
        
        .form-group {
            flex: 1;
            min-width: 200px;
            margin-right: 15px;
        }
        
        .form-group:last-child {
            margin-right: 0;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .form-group textarea {
            height: 80px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-percent"></i>
                    <h1>Edit Promotion</h1>
                </div>
                <div class="user-area">
                    <a href="ManagerProfile.jsp?id=<%= session.getAttribute("managerId") %>" class="user-profile-link">
                        <div class="user-profile">
                            <div class="user-avatar">M</div>
                            <span><%= session.getAttribute("managerName") != null ? session.getAttribute("managerName") : "Manager" %></span>
                            <i class="fas fa-user-cog profile-icon"></i>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <!-- Edit Promotion Form -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Edit Promotion</h2>
                </div>
                
                <div class="promotion-form">
                    <form action="UpdatePromotionServlet" method="post" id="promotionForm" onsubmit="return validateForm()">
                        <input type="hidden" name="promotionId" value="<%= promotion.getPromotionId() %>">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="promotionName">Promotion Name*</label>
                                <input type="text" id="promotionName" name="promotionName" required 
                                       value="<%= promotion.getPromotionName() %>" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="discountType">Discount Type*</label>
                                <select id="discountType" name="discountType" required class="form-control">
                                    <option value="percentage" <%= "percentage".equals(promotion.getPromotionType()) ? "selected" : "" %>>Percentage (%)</option>
                                    <option value="fixed" <%= "fixed".equals(promotion.getPromotionType()) ? "selected" : "" %>>Fixed Amount (RM)</option>
                                    <option value="bogo" <%= "bogo".equals(promotion.getPromotionType()) ? "selected" : "" %>>Buy One Get One</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="discountValue">Discount Value*</label>
                                <input type="number" id="discountValue" name="discountValue" step="0.01" required 
                                       value="<%= promotion.getPromotionCode() %>" class="form-control">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="startDate">Start Date*</label>
                                <input type="date" id="startDate" name="startDate" required class="form-control" 
                                       value="<%= startDate %>">
                            </div>
                            <div class="form-group">
                                <label for="endDate">End Date*</label>
                                <input type="date" id="endDate" name="endDate" required class="form-control" 
                                       value="<%= endDate %>">
                            </div>
                            <div class="form-group">
                                <label for="promotionCode">Promotion Code</label>
                                <input type="text" id="promotionCode" name="promotionCode" 
                                       value="<%= promotion.getPromotionCode() %>" 
                                       class="form-control" pattern="[A-Za-z0-9]{3,10}" maxlength="10">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group" style="flex: 100%;">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" class="form-control" rows="4"><%= promotion.getDescription() != null ? promotion.getDescription() : "" %></textarea>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Promotion
                            </button>
                            <a href="Promotion_Discount_Manager.jsp" class="btn btn-secondary ml-2">
                                <i class="fas fa-arrow-left"></i> Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for form validation -->
    <script>
        function validateForm() {
            let isValid = true;
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(document.getElementById('endDate').value);
            
            // Validate dates
            if (endDate < startDate) {
                alert('End date cannot be earlier than start date');
                document.getElementById('endDate').focus();
                return false;
            }
            
            // Validate discount value based on type
            const discountType = document.getElementById('discountType').value;
            const discountValue = parseFloat(document.getElementById('discountValue').value);
            
            if (discountType === 'percentage' && (discountValue <= 0 || discountValue > 100)) {
                alert('Percentage discount must be between 1 and 100');
                document.getElementById('discountValue').focus();
                return false;
            } else if ((discountType === 'fixed' || discountType === 'bogo') && discountValue <= 0) {
                alert('Discount value must be greater than 0');
                document.getElementById('discountValue').focus();
                return false;
            }
            
            return isValid;
        }
        
        // Discount type change handler
        document.getElementById('discountType').addEventListener('change', function() {
            const valueField = document.getElementById('discountValue');
            const valueLabel = valueField.previousElementSibling;
            
            if (this.value === 'percentage') {
                valueLabel.textContent = 'Discount Percentage (%)';
                valueField.placeholder = 'e.g. 15';
                valueField.min = 0;
                valueField.max = 100;
            } else if (this.value === 'fixed') {
                valueLabel.textContent = 'Discount Amount (RM)';
                valueField.placeholder = 'e.g. 10.00';
                valueField.min = 0;
                valueField.removeAttribute('max');
            } else if (this.value === 'bogo') {
                valueLabel.textContent = 'Buy X Get Y (Enter X)';
                valueField.placeholder = 'e.g. 1';
                valueField.min = 1;
                valueField.removeAttribute('max');
            }
        });
    </script>
</body>
</html>