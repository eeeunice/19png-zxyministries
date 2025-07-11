<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="domain.Products" %>
<%@ page import="da.ProductDAO" %>
<%@page import="da.DashboardDAO"%>
<%@page import="domain.LowStockProduct"%>
<%@page import="domain.DashboardMetrics"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="domain.Promotion" %>
<%@ page import="da.PromotionDAO" %>
<%
    PromotionDAO promotionDAO = new PromotionDAO();
    List<Promotion> promotions = promotionDAO.getAllPromotions();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotion & Discount Manager</title>
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
        
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .status-active {
            color: #28a745;
            font-weight: bold;
        }
        
        .status-inactive {
            color: #dc3545;
            font-weight: bold;
        }
        
        .status-scheduled {
            color: #ffc107;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <%
    DashboardDAO dashboardDAO = new DashboardDAO();
    DashboardMetrics metrics = dashboardDAO.getDashboardMetrics();
    
    // Get low stock products
    List<LowStockProduct> lowStockProducts = dashboardDAO.getLowStockProducts();
    %>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-percent"></i>
                    <h1>Promotion & Discount Manager</h1>
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
            <!-- Navigation Menu -->
            <div class="navigation-menu">
                <a href="Manager_Dashboard.jsp" class="nav-item active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="Product_Admin.jsp" class="nav-item"><i class="fas fa-box"></i> Products</a>
                <a href="Manager_Customers.jsp" class="nav-item"><i class="fas fa-users"></i> Customers</a>
                <a href="Orders_Manager.jsp" class="nav-item"><i class="fas fa-shopping-cart"></i> Orders</a>
                <a href="Staff_Management.jsp" class="nav-item"><i class="fas fa-user-tie"></i> Staff</a>
                <a href="Reports.jsp" class="nav-item"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="Promotion_Discount_Manager.jsp" class="nav-item"><i class="fas fa-percent"></i> Promotions</a>
                <a href="ViewFeedback.jsp" class="nav-item"><i class="fa-solid fa-comments"></i>Feedback</a>
                <a href="ReviewManagement.jsp" class="nav-item"><i class="fa-solid fa-comments"></i>Reviews</a>
                <a href="contactus_admin.jsp" class="nav-item"><i class="fas fa-comments"></i> Contact Us</a>
                <a href="Logout.jsp" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
            
            <!-- Dashboard Cards -->
            <div class="dashboard-cards">
                <div class="card">
                    <h2>Active Promotions</h2>
                    <div class="card-content">
                        <div class="card-value"><%= dashboardDAO.getActivePromotionsCount() %></div>
                        <i class="fas fa-tag card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Scheduled</h2>
                    <div class="card-content">
                        <div class="card-value"><%= dashboardDAO.getScheduledPromotionsCount() %></div>
                        <i class="fas fa-calendar-alt card-icon"></i>
                    </div>
                </div>
            </div>
            <!-- Create Promotion Form -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Create New Promotion</h2>
                </div>
                
                <div class="promotion-form">
                    <form action="CreatePromotionServlet" method="post" id="promotionForm" onsubmit="return validateForm()">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="promotionName">Promotion Name*</label>
                                <input type="text" id="promotionName" name="promotionName" required placeholder="e.g. Summer Sale" class="form-control">
                                <small class="form-text text-muted">Enter a descriptive name for this promotion</small>
                            </div>
                            <div class="form-group">
                                <label for="discountType">Discount Type*</label>
                                <select id="discountType" name="discountType" required class="form-control">
                                    <option value="">Select Type</option>
                                    <option value="percentage">Percentage (%)</option>
                                    <option value="fixed">Fixed Amount (RM)</option>
                                    <option value="bogo">Buy One Get One</option>
                                </select>
                                <small class="form-text text-muted">Select how the discount will be applied</small>
                            </div>
                            <div class="form-group">
                                <label for="discountValue">Discount Value*</label>
                                <input type="number" id="discountValue" name="discountValue" step="0.01" required placeholder="e.g. 15.00" class="form-control">
                                <small id="valueHelp" class="form-text text-muted">Enter the discount amount</small>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="startDate">Start Date*</label>
                                <input type="date" id="startDate" name="startDate" required class="form-control" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                <small class="form-text text-muted">When the promotion begins</small>
                            </div>
                            <div class="form-group">
                                <label for="endDate">End Date*</label>
                                <input type="date" id="endDate" name="endDate" required class="form-control">
                                <small class="form-text text-muted">When the promotion expires</small>
                            </div>
                            <div class="form-group">
                                <label for="promotionCode">Promotion Code</label>
                                <input type="text" id="promotionCode" name="promotionCode" placeholder="e.g. SUMMER25" 
                                       class="form-control" pattern="[A-Za-z0-9]{3,10}" maxlength="10">
                                <small class="form-text text-muted">Optional: Code customers can enter at checkout (3-10 alphanumeric characters)</small>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="applicableProducts">Applicable Products/Categories*</label>
                                <select id="applicableProducts" name="applicableProducts" required class="form-control">
                                    <option value="all">All Products</option>
                                    <option value="category">Specific Category</option>
                                    <option value="product">Specific Products</option>
                                </select>
                                <small class="form-text text-muted">Select which products this promotion applies to</small>
                            </div>
                            <div class="form-group">
                                <label for="minPurchase">Minimum Purchase (RM)</label>
                                <input type="number" id="minPurchase" name="minPurchase" step="0.01" placeholder="e.g. 50.00" class="form-control" min="0">
                                <small class="form-text text-muted">Optional: Minimum order amount required</small>
                            </div>
                            <div class="form-group">
                                <label for="maxUses">Maximum Uses</label>
                                <input type="number" id="maxUses" name="maxUses" value="0" class="form-control" min="0">
                                <small class="form-text text-muted">0 for unlimited uses</small>
                            </div>
                        </div>
                        
                        <!-- Add Category Selection - Initially Hidden -->
                        <div id="categorySelection" style="display: none;" class="form-row">
                            <div class="form-group" style="flex: 100%;">
                                <label for="categoryId">Select Category</label>
                                <select id="categoryId" name="categoryId" class="form-control">
                                    <option value="">Select a Category</option>
                                    <% 
                                    // Get all categories from database
                                    da.CategoryDAO categoryDAO = new da.CategoryDAO();
                                    List<domain.Categories> categories = categoryDAO.getAllCategories();
                                    for (domain.Categories category : categories) {
                                    %>
                                        <option value="<%= category.getCategoryId() %>"><%= category.getCategoryName() %></option>
                                    <% } %>
                                </select>
                                <small class="form-text text-muted">Select which category this promotion applies to</small>
                            </div>
                        </div>
                        
                        <!-- Add Product Selection - Initially Hidden -->
                        <div id="productSelection" style="display: none;" class="form-row">
                            <div class="form-group" style="flex: 100%;">
                                <label for="productIds">Select Products</label>
                                <select id="productIds" name="productIds" multiple class="form-control" size="5">
                                    <% 
                                    // Get all products from database
                                    da.ProductDAO productDAO = new da.ProductDAO();
                                    List<domain.Products> products = productDAO.getAllProducts();
                                    for (domain.Products product : products) {
                                    %>
                                        <option value="<%= product.getProductId() %>"><%= product.getProductName() %> - RM<%= product.getPrice() %></option>
                                    <% } %>
                                </select>
                                <small class="form-text text-muted">Hold Ctrl/Cmd to select multiple products</small>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group" style="flex: 100%;">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" placeholder="Describe the promotion details..." class="form-control" rows="4"></textarea>
                                <small class="form-text text-muted">Provide additional details about this promotion</small>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Create Promotion
                            </button>
                            <button type="reset" class="btn btn-secondary ml-2">
                                <i class="fas fa-undo"></i> Reset Form
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <script>
                // Form validation function
                function validateForm() {
                    let isValid = true;
                    const startDate = new Date(document.getElementById('startDate').value);
                    const endDate = new Date(document.getElementById('endDate').value);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
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
                    
                    // Validate category selection if applicable
                    const applicableProducts = document.getElementById('applicableProducts').value;
                    if (applicableProducts === 'category') {
                        const categoryId = document.getElementById('categoryId').value;
                        if (!categoryId) {
                            alert('Please select a category');
                            document.getElementById('categoryId').focus();
                            return false;
                        }
                    } else if (applicableProducts === 'product') {
                        const productIds = document.getElementById('productIds');
                        let selected = false;
                        for (let i = 0; i < productIds.options.length; i++) {
                            if (productIds.options[i].selected) {
                                selected = true;
                                break;
                            }
                        }
                        if (!selected) {
                            alert('Please select at least one product');
                            document.getElementById('productIds').focus();
                            return false;
                        }
                    }
                    
                    return isValid;
                }
            </script>
            
            <!-- Active Promotions Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Active Promotions</h2>
                    <div class="search-box">
                        <input type="text" placeholder="Search promotions..." id="promotionSearch">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="products-table" id="promotionsTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Type</th>
                                <th>Value</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            // Display actual promotions from database
                            if (promotions != null && !promotions.isEmpty()) {
                                for (Promotion promotion : promotions) {
                                    // Determine promotion status
                                    String status = "";
                                    String statusClass = "";
                                    
                                    java.util.Date now = new java.util.Date();
                                    java.util.Date startDate = new java.util.Date(promotion.getStartDate().getTime());
                                    java.util.Date endDate = new java.util.Date(promotion.getEndDate().getTime());
                                    
                                    if (now.after(endDate)) {
                                        status = "Expired";
                                        statusClass = "status-inactive";
                                    } else if (now.before(startDate)) {
                                        status = "Scheduled";
                                        statusClass = "status-scheduled";
                                    } else {
                                        status = "Active";
                                        statusClass = "status-active";
                                    }
                                    
                                    // Format the value based on promotion type
                                    String displayValue = promotion.getPromotionType();
                                    if ("percentage".equalsIgnoreCase(promotion.getPromotionType())) {
                                        displayValue = promotion.getPromotionCode() + "%";
                                    } else if ("fixed".equalsIgnoreCase(promotion.getPromotionType())) {
                                        displayValue = "RM " + promotion.getPromotionCode();
                                    } else if ("bogo".equalsIgnoreCase(promotion.getPromotionType())) {
                                        displayValue = "Buy " + promotion.getPromotionCode() + " Get 1";
                                    }
                                    
                                    // Format dates for display
                                    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
                                    String formattedStartDate = dateFormat.format(startDate);
                                    String formattedEndDate = dateFormat.format(endDate);
                            %>
                            <tr>
                                <td><%= promotion.getPromotionId() %></td>
                                <td><%= promotion.getPromotionName() %></td>
                                <td><%= promotion.getPromotionType() %></td>
                                <td><%= displayValue %></td>
                                <td><%= formattedStartDate %></td>
                                <td><%= formattedEndDate %></td>
                                <td><span class="<%= statusClass %>"><%= status %></span></td>
                                <td>
                                    <div class="actions">
                                        <a href="EditPromotion.jsp?id=<%= promotion.getPromotionId() %>" class="action-btn view-btn">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a onclick="confirmDelete('<%= promotion.getPromotionId() %>')" class="action-btn delete-btn">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% 
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="8" style="text-align: center;">No promotions found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for the page functionality -->
    <script>
        // Search functionality
        document.getElementById('promotionSearch').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const table = document.getElementById('promotionsTable');
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                let found = false;
                
                for (let j = 0; j < cells.length - 1; j++) {
                    const cellText = cells[j].textContent.toLowerCase();
                    if (cellText.includes(searchValue)) {
                        found = true;
                        break;
                    }
                }
                
                row.style.display = found ? '' : 'none';
            }
        });
        
        // Delete confirmation
        function confirmDelete(id) {
            if (confirm('Are you sure you want to delete this promotion?')) {
                // Submit to delete servlet
                window.location.href = 'DeletePromotionServlet?id=' + id;
            }
        }
        
        // Date validation
        document.getElementById('endDate').addEventListener('change', function() {
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(this.value);
            
            if (endDate < startDate) {
                alert('End date cannot be earlier than start date');
                this.value = '';
            }
        });
        
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
    
        // Show/hide category and product selection based on applicableProducts dropdown
        document.addEventListener('DOMContentLoaded', function() {
            const applicableProductsSelect = document.getElementById('applicableProducts');
            const categorySelectionDiv = document.getElementById('categorySelection');
            const productSelectionDiv = document.getElementById('productSelection');
            
            function updateSelectionVisibility() {
                const selectedValue = applicableProductsSelect.value;
                
                if (selectedValue === 'category') {
                    categorySelectionDiv.style.display = 'flex';
                    productSelectionDiv.style.display = 'none';
                } else if (selectedValue === 'product') {
                    categorySelectionDiv.style.display = 'none';
                    productSelectionDiv.style.display = 'flex';
                } else {
                    categorySelectionDiv.style.display = 'none';
                    productSelectionDiv.style.display = 'none';
                }
            }
            
            // Initial setup
            updateSelectionVisibility();
            
            // Add event listener for changes
            applicableProductsSelect.addEventListener('change', updateSelectionVisibility);
        });
    </script>
</body>
</html>