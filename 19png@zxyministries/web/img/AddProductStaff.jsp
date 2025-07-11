<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="domain.Categories"%>
<%@page import="domain.Subcategories"%>
<%@page import="da.CategoryDAO"%>
<%@page import="da.Subcategory_AdminDAO"%>
<%@page import="da.DashboardDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product - Staff</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <style>
        .form-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
        }
        
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 0.9rem;
        }
        
        textarea.form-control {
            min-height: 120px;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        #imagePreview img {
            max-width: 200px;
            max-height: 200px;
            border-radius: 5px;
            border: 1px solid #ddd;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        if (session.getAttribute("staffId") == null) {
            response.sendRedirect("Login_Staff.jsp");
            return;
        }
        
        // Initialize the DAO
        DashboardDAO dashboardDAO = new DashboardDAO();
        
        // Get category data
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Categories> categories = categoryDAO.getAllCategories();
        
        // Get selected category if any
        String selectedCategoryId = request.getParameter("categoryId");
        
        // Get subcategories if category is selected
        List<Subcategories> subcategories = null;
        if (selectedCategoryId != null && !selectedCategoryId.isEmpty()) {
            Subcategory_AdminDAO subcategoryDAO = new Subcategory_AdminDAO();
            subcategories = subcategoryDAO.getSubcategoriesByCategory(selectedCategoryId);
        }
        
        // Close connections
        dashboardDAO.closeConnection();
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-boxes"></i>
                    <h1>Add New Product</h1>
                </div>
                <div class="user-area">
                    <a href="staffProfile.jsp?id=<%= session.getAttribute("staffId") %>" class="user-profile-link">
                        <div class="user-profile">
                            <div class="user-avatar">S</div>
                            <span><%= session.getAttribute("staffName") != null ? session.getAttribute("staffName") : "Staff" %></span>
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
            <!-- Form Section -->
            <div class="form-container">
                <div class="section-header">
                    <h2 class="section-title">Add New Product</h2>
                </div>
                
                <% 
                    // Get messages from session
                    String errorMessage = (String) request.getSession().getAttribute("errorMessage");
                    String successMessage = (String) request.getSession().getAttribute("successMessage");
                    
                    // Clear messages after displaying
                    request.getSession().removeAttribute("errorMessage");
                    request.getSession().removeAttribute("successMessage");
                %>
                
                <% if (successMessage != null) { %>
                    <div class="message success-message">
                        <i class="fas fa-check-circle"></i>
                        <%= successMessage %>
                    </div>
                <% } %>
                <% if (errorMessage != null) { %>
                    <div class="message error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMessage %>
                    </div>
                <% } %>

                <form action="AddProductServlet" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="productName"><i class="fas fa-tag"></i> Product Name</label>
                        <input type="text" class="form-control" id="productName" name="productName" required>
                    </div>

                    <div class="form-group">
                        <label for="categoryId"><i class="fas fa-folder"></i> Category</label>
                        <select class="form-control" id="categoryId" name="categoryId" required onchange="updateSubcategories(this.value)">
                            <option value="">Select Category</option>
                            <% for (Categories category : categories) { %>
                                <option value="<%= category.getCategoryId() %>" 
                                    <%= (selectedCategoryId != null && selectedCategoryId.equals(category.getCategoryId())) ? "selected" : "" %>>
                                    <%= category.getCategoryName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="subcategoryId"><i class="fas fa-folder-open"></i> Subcategory</label>
                        <select class="form-control" id="subcategoryId" name="subcategoryId" required>
                            <option value="">Select Subcategory</option>
                            <% if (subcategories != null) {
                                for (Subcategories subcategory : subcategories) { %>
                                    <option value="<%= subcategory.getSubcategoryId() %>">
                                        <%= subcategory.getSubcategoryName() %>
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="price"><i class="fas fa-dollar-sign"></i> Price (RM)</label>
                        <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="stockQty"><i class="fas fa-warehouse"></i> Stock Quantity</label>
                        <input type="number" class="form-control" id="stockQty" name="stockQty" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="description"><i class="fas fa-align-left"></i> Description</label>
                        <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="image"><i class="fas fa-image"></i> Product Image</label>
                        <input type="file" class="form-control-file" id="image" name="image" accept="image/*" required>
                        <div id="imagePreview" class="mt-2"></div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add Product</button>
                        <a href="Staff_Product.jsp" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Image preview functionality
        document.getElementById('image').addEventListener('change', function(e) {
            const file = e.target.files[0];
            const preview = document.getElementById('imagePreview');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = `<img src="${e.target.result}" alt="Image Preview">`;
                }
                reader.readAsDataURL(file);
            } else {
                preview.innerHTML = '';
            }
        });

        // Function to update subcategories when category changes
        function updateSubcategories(categoryId) {
            if (categoryId) {
                window.location.href = 'AddProductStaff.jsp?categoryId=' + categoryId;
            }
        }
    </script>
</body>
</html>