<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="domain.Products" %>
<%@page import="domain.Categories" %>
<%@page import="da.ProductDAO" %>
<%@page import="da.CategoryDAO" %>
<%@page import="da.DashboardDAO" %>
<%@page import="domain.LowStockProduct" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Product Management</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
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
        
        // Get low stock products
        List<LowStockProduct> lowStockProducts = dashboardDAO.getLowStockProducts();
        
        // Get product data
        ProductDAO productDAO = new ProductDAO();
        List<Products> productsList = productDAO.getAllProducts();
        
        // Get sorting parameter if any
        String sortParam = request.getParameter("sort");
        if (sortParam != null && !sortParam.isEmpty()) {
            productsList = productDAO.getAllProducts(sortParam);
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
                    <h1>Staff Product Management</h1>
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
            <!-- Navigation Menu -->
            <div class="navigation-menu">
                <a href="Staff_Dashboard.jsp" class="nav-item active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="staffdisplaycust.jsp" class="nav-item"><i class="fas fa-users"></i> Customers</a>
                <a href="Staff_Product.jsp" class="nav-item"><i class="fas fa-boxes"></i> Products </a>
                <a href="Staff_Orders.jsp" class="nav-item"><i class="fas fa-shopping-cart"></i> Orders </a>
                <a href="ViewFeedbackStaff.jsp" class="nav-item"><i class="fas fa-comments"></i> Feedback </a>
                <a href="Staff_Review.jsp" class="nav-item"><i class="fas fa-comments"></i> Reviews</a>
                <a href="contactus_admin.jsp" class="nav-item"><i class="fas fa-comments"></i> Contact Us</a>
                <a href="Logout.jsp" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
            
            <!-- Dashboard Cards -->
            <div class="dashboard-cards">
                <div class="card">
                    <h2>Total Products</h2>
                    <div class="card-content">
                        <div class="card-value"><%= productsList.size() %></div>
                        <i class="fas fa-box card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Low Stock Items</h2>
                    <div class="card-content">
                        <div class="card-value"><%= lowStockProducts.size() %></div>
                        <i class="fas fa-exclamation-triangle card-icon"></i>
                    </div>
                </div>
            </div>

            <!-- Products Section -->
            <div class="products-section">
                <!-- Success/Error Messages -->
                <%
                    String successMessage = (String) session.getAttribute("successMessage");
                    String errorMessage = (String) session.getAttribute("errorMessage");
                    session.removeAttribute("successMessage");
                    session.removeAttribute("errorMessage");
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

                <div class="section-header">
                    <h2 class="section-title">Products List</h2>
                    <button class="btn btn-primary" onclick="location.href='AddProductStaff.jsp'">
                        <i class="fas fa-plus"></i> Add New Product
                    </button>
                </div>

                <div class="filters">
                    <div class="filter-group">
                        <label for="sort"><i class="fas fa-sort"></i> Sort by:</label>
                        <form method="GET" action="Staff_Product.jsp" id="sortForm">
                            <select name="sort" class="filter-select" onchange="this.form.submit()" id="sort">
                                <option value="">Select...</option>
                                <optgroup label="ID">
                                    <option value="id_asc">ID (Ascending)</option>
                                    <option value="id_desc">ID (Descending)</option>
                                </optgroup>
                                <optgroup label="Price">
                                    <option value="price_asc">Price (Low to High)</option>
                                    <option value="price_desc">Price (High to Low)</option>
                                </optgroup>
                                <optgroup label="Stock">
                                    <option value="stock_asc">Stock (Low to High)</option>
                                    <option value="stock_desc">Stock (High to Low)</option>
                                </optgroup>
                            </select>
                        </form>
                    </div>
                    
                    <div class="filter-group">
                        <label for="category"><i class="fas fa-tag"></i> Category:</label>
                        <select class="filter-select" id="category" onchange="filterByCategory()">
                            <option value="">All Categories</option>
                            <% 
                                // Get all categories from the database
                                CategoryDAO categoryDAO = new CategoryDAO();
                                List<Categories> categories = categoryDAO.getAllCategories();
                                for(Categories category : categories) {
                            %>
                                <option value="<%= category.getCategoryId() %>"><%= category.getCategoryName() %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="stock-status"><i class="fas fa-warehouse"></i> Stock Status:</label>
                        <select class="filter-select" id="stock-status" onchange="filterByStock()">
                            <option value="">All Items</option>
                            <option value="in-stock">In Stock</option>
                            <option value="out-of-stock">Out of Stock</option>
                        </select>
                    </div>
                    
                    <div class="search-box">
                        <input type="text" id="product-search" placeholder="Search products...">
                        <button onclick="searchProducts()"><i class="fas fa-search"></i></button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Product Name</th>
                                <th>CategoryID</th>
                                <th>Price (RM)</th>
                                <th>Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (productsList != null && !productsList.isEmpty()) { %>
                                <% for (Products product : productsList) { %>
                                    <tr class="product-row" 
                                        data-category="<%= product.getCategoryId() %>" 
                                        data-stock="<%= product.getStockQty() > 0 ? "in-stock" : "out-of-stock" %>">
                                        <td><%= product.getProductId() %></td>
                                        <td>
                                            <div class="product-image">
                                                <img src="<%= product.getImageUrl() %>" alt="<%= product.getProductName() %>" class="table-img">
                                            </div>
                                        </td>
                                        <td><%= product.getProductName() %></td>
                                        <td><%= product.getCategoryId() %></td>
                                        <td class="price">RM <%= String.format("%.2f", product.getPrice()) %></td>
                                        <td>
                                            <% if (product.getStockQty() <= 0) { %>
                                                <span class="stock-badge out-of-stock">Out of Stock</span>
                                            <% } else if (product.getStockQty() < 10) { %>
                                                <span class="stock-badge low-stock">Low Stock (<%= product.getStockQty() %>)</span>
                                            <% } else { %>
                                                <span class="stock-badge in-stock"><%= product.getStockQty() %> in stock</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <a href="ProductEditStaff.jsp?product_id=<%= product.getProductId() %>" class="action-btn edit-btn">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } else { %>
                                <tr>
                                    <td colspan="7" class="text-center">No products found</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Function to filter products by category
        function filterByCategory() {
            const categoryValue = document.getElementById('category').value;
            const rows = document.querySelectorAll('.product-row');
            
            rows.forEach(row => {
                if (!categoryValue || row.dataset.category === categoryValue) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        // Function to filter products by stock status
        function filterByStock() {
            const stockValue = document.getElementById('stock-status').value;
            const rows = document.querySelectorAll('.product-row');
            
            rows.forEach(row => {
                if (!stockValue || row.dataset.stock === stockValue) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        // Function to search products
        function searchProducts() {
            const searchValue = document.getElementById('product-search').value.toLowerCase();
            const rows = document.querySelectorAll('.product-row');
            
            rows.forEach(row => {
                const productName = row.children[2].textContent.toLowerCase();
                if (productName.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        // Event listener for search input
        document.getElementById('product-search').addEventListener('keyup', searchProducts);
    </script>
</body>
</html>