<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="domain.Products" %>
<%@ page import="da.ProductDAO" %>
<%@page import="da.DashboardDAO"%>
<%@page import="domain.LowStockProduct"%>
<%@page import="domain.DashboardMetrics"%>
<%@ page import="da.CategoryDAO, domain.Categories" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management Dashboard</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
</head>
<body>
    <%
    DashboardDAO dashboardDAO = new DashboardDAO();
    DashboardMetrics metrics = dashboardDAO.getDashboardMetrics();
    
    // Get low stock products
    List<LowStockProduct> lowStockProducts = dashboardDAO.getLowStockProducts();
    
    // Get category count and total stock
    int categoryCount = dashboardDAO.getCategoryCount();
    int totalStock = dashboardDAO.getTotalStock();
    %>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-box"></i>
                    <h1>Product Manager</h1>
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
                    <h2>Total Products</h2>
                    <div class="card-content">
                        <div class="card-value"><%= metrics.getTotalProducts() %></div>
                        <i class="fas fa-box card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Categories</h2>
                    <div class="card-content">
                        <div class="card-value"><%= categoryCount %></div>
                        <i class="fas fa-tag card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Total Stock</h2>
                    <div class="card-content">
                        <div class="card-value"><%= totalStock %></div>
                        <i class="fas fa-warehouse card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Low Stock Items</h2>
                    <div class="card-content">
                        <div class="card-value"><%= metrics.getLowStockCount() %></div>
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
                    <button class="btn btn-primary" onclick="location.href='AddProduct.jsp'">
                        <i class="fas fa-plus"></i> Add New Product
                    </button>
                </div>

                <div class="filters">
                    <div class="filter-group">
                        <label for="sort"><i class="fas fa-sort"></i> Sort by:</label>
                        <form method="GET" action="Product_Admin.jsp" id="sortForm">
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
                                <th>Category</th>
                                <th>Subcategory</th>
                                <th>Price (RM)</th>
                                <th>Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ProductDAO productDAO = new ProductDAO();
                                String sort = request.getParameter("sort");
                                List<Products> products = productDAO.getAllProducts(sort);

                                for (Products product : products) {
                                    // Determine stock status
                                    String stockStatusClass = "in-stock";
                                    if(product.getStockQty() <= 5) {
                                        stockStatusClass = "low-stock";
                                    } else if(product.getStockQty() <= 0) {
                                        stockStatusClass = "out-of-stock";
                                    }
                            %>
                            <tr>
                                <td><%= product.getProductId() %></td>
                                <td><img src="<%= product.getImageUrl() %>" alt="<%= product.getProductName() %>" class="table-img"></td>
                                <td class="product-name"><%= product.getProductName() %></td>
                                <td><span class="category-badge"><%= product.getCategoryId() %></span></td>
                                <td><%= product.getSubcategoryId() %></td>
                                <td class="price">RM <%= product.getPrice() %></td>
                                <td>
                                    <div class="stock-status">
                                        <div class="stock-indicator <%= stockStatusClass %>"></div>
                                        <%= product.getStockQty() %>
                                    </div>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a href="ProductEdit.jsp?product_id=<%= product.getProductId() %>" class="action-btn edit-btn">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                       <a href="DeleteProductServlet?product_id=<%= product.getProductId() %>" 
                                        onclick="return confirm('Are you sure you want to delete this product?');" 
                                        class="action-btn delete-btn">
                                         <i class="fas fa-trash"></i>
                                     </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- Enhanced Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Showing <span id="showing-start">1</span> to <span id="showing-end">10</span> of <span id="total-items"><%= products.size() %></span> products
                    </div>
                    <div class="pagination">
                        <div class="page-item" id="prev-page" title="Previous Page"><i class="fas fa-angle-left"></i></div>
                        <div class="page-numbers-container" id="page-numbers">
                            <div class="page-item active">1</div>
                            <div class="page-item">2</div>
                            <div class="page-item">3</div>
                            <% if (Math.ceil(products.size() / 10.0) > 3) { %>
                                <div class="page-item page-dots">...</div>
                                <div class="page-item"><%= Math.ceil(products.size() / 10.0) %></div>
                            <% } %>
                        </div>
                        <div class="page-item" id="next-page" title="Next Page"><i class="fas fa-angle-right"></i></div>
                    </div>
                    <div class="pagination-options">
                        <label for="items-per-page">Items per page:</label>
                        <select id="items-per-page" class="filter-select">
                            <option value="10">10</option>
                            <option value="25">25</option>
                            <option value="50">50</option>
                            <option value="100">100</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Enhanced pagination functionality with filter integration
        const itemsPerPageSelect = document.getElementById('items-per-page');
        const prevPageBtn = document.getElementById('prev-page');
        const nextPageBtn = document.getElementById('next-page');
        const showingStart = document.getElementById('showing-start');
        const showingEnd = document.getElementById('showing-end');
        const totalItems = document.getElementById('total-items');
        const pageNumbersContainer = document.getElementById('page-numbers');
        const productSearch = document.getElementById('product-search');
        const categoryFilter = document.getElementById('category');
        const stockFilter = document.getElementById('stock-status');
        const table = document.querySelector('.products-table');
        const rows = table.getElementsByTagName('tr');

        let currentPage = 1;
        let itemsPerPage = 10;
        const totalRows = <%= products.size() %>;
        let filteredRows = [];

        // Apply all filters and update visible rows
        function applyFilters() {
            // Get filter values
            const searchQuery = productSearch.value.toLowerCase();
            const categoryValue = categoryFilter.value;
            const stockValue = stockFilter.value;
            
            // Reset filtered rows
            filteredRows = [];
            
            // Apply search, category and stock filters
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                let matchesSearch = false;
                let matchesCategory = true; // Default to true if no category filter
                let matchesStock = true; // Default to true if no stock filter
                
                // Check search match
                if (searchQuery) {
                    const productName = row.querySelector('.product-name').textContent.toLowerCase();
                    const productId = row.querySelector('td:first-child').textContent.toLowerCase();
                    
                    if (productName.includes(searchQuery) || productId.includes(searchQuery)) {
                        matchesSearch = true;
                    }
                } else {
                    matchesSearch = true; // No search query means all match
                }
                
                // Check category match
                if (categoryValue && categoryValue !== '') {
                    const categoryCell = row.querySelector('td:nth-child(4)');
                    if (categoryCell) {
                        matchesCategory = categoryCell.textContent.includes(categoryValue);
                    }
                }
                
                // Check stock match
                if (stockValue && stockValue !== '') {
                    const stockCell = row.querySelector('.stock-status');
                    const stockQty = parseInt(stockCell.textContent.trim());
                    
                    if (stockValue === 'in-stock' && stockQty > 0) {
                        matchesStock = true;
                    } else if (stockValue === 'out-of-stock' && stockQty <= 0) {
                        matchesStock = true;
                    } else {
                        matchesStock = false;
                    }
                }
                
                // If row matches all filters, add to filtered rows
                if (matchesSearch && matchesCategory && matchesStock) {
                    filteredRows.push(row);
                }
                
                // Hide all rows initially
                row.style.display = 'none';
            }
            
            // Apply sorting if needed (handled by server-side sorting)
            
            // Reset to first page when filters change
            currentPage = 1;
            
            // Update pagination and display rows
            updatePagination();
        }

        function updatePagination() {
            const filteredCount = filteredRows.length;
            
            // Calculate showing range based on filtered rows
            const start = (currentPage - 1) * itemsPerPage + 1;
            const end = Math.min(start + itemsPerPage - 1, filteredCount);
            
            // Update pagination info
            showingStart.textContent = filteredCount > 0 ? start : 0;
            showingEnd.textContent = end;
            totalItems.textContent = filteredCount;
            
            // Show only the rows for current page
            filteredRows.forEach((row, index) => {
                const rowIndex = index + 1; // 1-based index
                if (rowIndex >= start && rowIndex <= end) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Update pagination buttons
            const maxPage = Math.ceil(filteredCount / itemsPerPage) || 1; // At least 1 page
            
            // Update prev/next button states
            if (currentPage <= 1) {
                prevPageBtn.classList.add('disabled');
            } else {
                prevPageBtn.classList.remove('disabled');
            }
            
            if (currentPage >= maxPage) {
                nextPageBtn.classList.add('disabled');
            } else {
                nextPageBtn.classList.remove('disabled');
            }
            
            // Update page numbers
            pageNumbersContainer.innerHTML = '';
            
            // Determine which page numbers to show
            let startPage = Math.max(1, currentPage - 1);
            let endPage = Math.min(maxPage, startPage + 2);
            
            // Adjust if we're at the end
            if (endPage - startPage < 2) {
                startPage = Math.max(1, endPage - 2);
            }
            
            // Create page number elements
            for (let i = startPage; i <= endPage; i++) {
                const pageItem = document.createElement('div');
                pageItem.className = 'page-item' + (i === currentPage ? ' active' : '');
                pageItem.textContent = i;
                pageItem.addEventListener('click', function() {
                    currentPage = i;
                    updatePagination();
                });
                pageNumbersContainer.appendChild(pageItem);
            }
            
            // Add dots and last page if needed
            if (endPage < maxPage) {
                if (endPage < maxPage - 1) {
                    const dots = document.createElement('div');
                    dots.className = 'page-item page-dots';
                    dots.textContent = '...';
                    pageNumbersContainer.appendChild(dots);
                }
                
                const lastPage = document.createElement('div');
                lastPage.className = 'page-item';
                lastPage.textContent = maxPage;
                lastPage.addEventListener('click', function() {
                    currentPage = maxPage;
                    updatePagination();
                });
                pageNumbersContainer.appendChild(lastPage);
            }
        }

        // Initialize with all rows
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const sortValue = urlParams.get('sort');
            if (sortValue) {
                document.getElementById('sort').value = sortValue;
            }
            
            // Initialize filtered rows with all rows
            for (let i = 1; i < rows.length; i++) {
                filteredRows.push(rows[i]);
            }
            
            // Initial pagination
            updatePagination();
            
            // Event listeners for filters
            if (productSearch) {
                productSearch.addEventListener('keyup', function(event) {
                    if (event.key === 'Enter') {
                        applyFilters();
                    }
                });
            }
            
            if (categoryFilter) {
                categoryFilter.addEventListener('change', applyFilters);
            }
            
            if (stockFilter) {
                stockFilter.addEventListener('change', applyFilters);
            }
            
            // Handle items per page change
            itemsPerPageSelect.addEventListener('change', function() {
                itemsPerPage = parseInt(this.value);
                currentPage = 1; // Reset to first page
                updatePagination();
            });
            
            // Handle previous page click
            prevPageBtn.addEventListener('click', function() {
                if (currentPage > 1) {
                    currentPage--;
                    updatePagination();
                }
            });
            
            // Handle next page click
            nextPageBtn.addEventListener('click', function() {
                const maxPage = Math.ceil(filteredRows.length / itemsPerPage);
                if (currentPage < maxPage) {
                    currentPage++;
                    updatePagination();
                }
            });
        });
        
        // Update the existing filter functions to call updateFilteredRows
        const originalFilterByCategory = filterByCategory;
        filterByCategory = function() {
            originalFilterByCategory();
            updateFilteredRows();
        };
        
        const originalFilterByStock = filterByStock;
        filterByStock = function() {
            originalFilterByStock();
            updateFilteredRows();
        };
        
        const originalSearchProducts = searchProducts;
        searchProducts = function() {
            originalSearchProducts();
            updateFilteredRows();
        };
        function filterByCategory() {
            const categoryValue = document.getElementById('category').value;
            const rows = document.querySelectorAll('.products-table tbody tr');
            
            rows.forEach(row => {
                const categoryCell = row.querySelector('td:nth-child(4)');
                if (!categoryValue || categoryCell.textContent.includes(categoryValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            updateVisibleCount();
        }
        
        function filterByStock() {
            const stockValue = document.getElementById('stock-status').value;
            const rows = document.querySelectorAll('.products-table tbody tr');
            
            rows.forEach(row => {
                const stockCell = row.querySelector('.stock-status');
                const stockQty = parseInt(stockCell.textContent.trim());
                
                if (!stockValue) {
                    // Show all if no filter selected
                    row.style.display = '';
                } else if (stockValue === 'in-stock' && stockQty > 0) {
                    // Show only in-stock items
                    row.style.display = '';
                } else if (stockValue === 'out-of-stock' && stockQty <= 0) {
                    // Show only out-of-stock items
                    row.style.display = '';
                } else {
                    // Hide if doesn't match filter
                    row.style.display = 'none';
                }
            });
        }
        
        function searchProducts() {
            const searchQuery = document.getElementById('product-search').value.toLowerCase();
            const rows = document.querySelectorAll('.products-table tbody tr');
            
            rows.forEach(row => {
                const productName = row.querySelector('.product-name').textContent.toLowerCase();
                const productId = row.querySelector('td:first-child').textContent.toLowerCase();
                
                if (productName.includes(searchQuery) || productId.includes(searchQuery)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            updateVisibleCount();
        }
        
        function updateVisibleCount() {
            const totalVisible = document.querySelectorAll('.products-table tbody tr:not([style*="display: none"])');
            // If you have a counter element, update it here
            // document.getElementById('visible-count').textContent = totalVisible.length;
        }
    </script>
</body>
</html>