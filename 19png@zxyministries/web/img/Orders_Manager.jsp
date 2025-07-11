<%@ page import="java.util.*, da.OrderDAO, domain.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
    <%
        // Check if user is logged in
        if (session.getAttribute("managerId") == null) {
            response.sendRedirect("Login_mgn.jsp");
            return;
        }
        
        // Initialize order data
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = null;
        int totalOrders = 0;
        int pendingOrders = 0;
        int completedOrders = 0;
        double totalRevenue = 0.0;
        
        try {
            orders = orderDAO.getAllOrders();
            
            if (orders != null && !orders.isEmpty()) {
                totalOrders = orders.size();
                
                // Calculate metrics
                for (Order order : orders) {
                    if ("Processing".equalsIgnoreCase(order.getStatus())) {
                        pendingOrders++;
                    } else if ("shipping".equalsIgnoreCase(order.getStatus())) {
                        completedOrders++;
                        totalRevenue += order.getTotalAmount();
                    }
                }
            }
        } finally {
            // Ensure database connection is closed
            orderDAO.closeConnection();
        }
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-shopping-cart"></i>
                    <h1>Order Management</h1>
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
            
            <!-- Order Stats Cards -->
            <div class="dashboard-cards">
                <div class="card">
                    <h2>Total Orders</h2>
                    <div class="card-content">
                        <div class="card-value" id="totalOrders"><%= totalOrders %></div>
                        <i class="fas fa-shopping-cart card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Pending Orders</h2>
                    <div class="card-content">
                        <div class="card-value" id="pendingOrders"><%= pendingOrders %></div>
                        <i class="fas fa-clock card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Completed Orders</h2>
                    <div class="card-content">
                        <div class="card-value" id="completedOrders"><%= completedOrders %></div>
                        <i class="fas fa-check-circle card-icon"></i>
                    </div>
                </div>
            </div>
            
            <!-- Orders Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Order List</h2>
                    <div class="search-box">
                        <input type="text" placeholder="Search orders..." id="orderSearch">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                </div>
                
                <div class="filters">
                    <div class="filter-group">
                        <label for="sort"><i class="fas fa-sort"></i> Sort by:</label>
                        <select name="sort" class="filter-select" id="sort">
                            <option value="">Select...</option>
                            <optgroup label="Order Date">
                                <option value="date_asc">Date (Oldest)</option>
                                <option value="date_desc">Date (Newest)</option>
                            </optgroup>
                            <optgroup label="Amount">
                                <option value="amount_asc">Amount (Low to High)</option>
                                <option value="amount_desc">Amount (High to Low)</option>
                            </optgroup>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="status">Status:</label>
                        <select class="filter-select" id="status">
                            <option value="">All Statuses</option>
                            <option value="processing">Processing</option>
                            <option value="Delivery">Delivered</option>
                            <option value="shipping">Complete</option>
                        </select>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="products-table" id="ordersTable">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Order Date</th>
                                <th>Total Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (orders != null && !orders.isEmpty()) {
                                    for (Order order : orders) {
                            %>
                                <tr>
                                    <td><%= order.getOrderId() %></td>
                                    <td><%= order.getCustomerName() %></td>
                                    <td><%= order.getOrderDate() %></td>
                                    <td class="price">RM <%= String.format("%.2f", order.getTotalAmount()) %></td>
                                    <td>
                                        <span class="status-badge <%= order.getStatus().toLowerCase() %>"><%= order.getStatus() %></span>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="OrderDetails.jsp?id=<%= order.getOrderId() %>" class="action-btn view-btn">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr><td colspan="7" class="text-center">No order data found.</td></tr>
                                <%
                                    }
                                %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Enhanced Pagination -->
    <div class="pagination-container">
        <div class="pagination-info">
            Showing <span id="showing-start">1</span> to <span id="showing-end">10</span> of <span id="total-items"><%= totalOrders %></span> orders
        </div>
        <div class="pagination">
            <div class="page-item" id="prev-page" title="Previous Page"><i class="fas fa-angle-left"></i></div>
            <div class="page-numbers-container" id="page-numbers">
                <div class="page-item active">1</div>
                <div class="page-item">2</div>
                <div class="page-item">3</div>
                <% if (Math.ceil(totalOrders / 10.0) > 3) { %>
                    <div class="page-item page-dots">...</div>
                    <div class="page-item"><%= Math.ceil(totalOrders / 10.0) %></div>
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
        const searchInput = document.getElementById('orderSearch');
        const statusFilter = document.getElementById('status');
        const sortSelect = document.getElementById('sort');
        const table = document.getElementById('ordersTable');
        const rows = table.getElementsByTagName('tr');

        let currentPage = 1;
        let itemsPerPage = 10;
        const totalRows = <%= totalOrders %>;
        let filteredRows = [];

        // Apply all filters and update visible rows
        function applyFilters() {
            console.log("Applying filters...");
            console.log("Sort value:", sortSelect.value);
            
            // Get filter values
            const searchQuery = searchInput.value.toLowerCase();
            const statusValue = statusFilter.value.toLowerCase();
            const sortValue = sortSelect.value;
            
            // Reset filtered rows
            filteredRows = [];
            
            // Apply search and status filters
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                let matchesSearch = false;
                let matchesStatus = true; // Default to true if no status filter
                
                // Check search match
                if (searchQuery) {
                    for (let j = 0; j < cells.length; j++) {
                        const cellText = cells[j].textContent.toLowerCase();
                        if (cellText.indexOf(searchQuery) > -1) {
                            matchesSearch = true;
                            break;
                        }
                    }
                } else {
                    matchesSearch = true; // No search query means all match
                }
                
                // Check status match - make it case-insensitive
                if (statusValue && statusValue !== '') {
                    const statusCell = row.querySelector('.status-badge');
                    if (statusCell) {
                        const status = statusCell.textContent.toLowerCase();
                        matchesStatus = (status === statusValue.toLowerCase());
                    }
                }
                
                // If row matches all filters, add to filtered rows
                if (matchesSearch && matchesStatus) {
                    filteredRows.push(row);
                }
                
                // Hide all rows initially
                row.style.display = 'none';
            }
            
            if (sortValue && sortValue !== '') {
                filteredRows.sort((a, b) => {
                    if (sortValue === 'date_asc') {
                        return new Date(a.cells[2].textContent) - new Date(b.cells[2].textContent);
                    } else if (sortValue === 'date_desc') {
                        return new Date(b.cells[2].textContent) - new Date(a.cells[2].textContent);
                    } else if (sortValue === 'amount_asc') {
                        return parseFloat(a.cells[4].textContent.replace('RM ', '')) - 
                               parseFloat(b.cells[4].textContent.replace('RM ', ''));
                    } else if (sortValue === 'amount_desc') {
                        return parseFloat(b.cells[4].textContent.replace('RM ', '')) - 
                               parseFloat(a.cells[4].textContent.replace('RM ', ''));
                    }
                    return 0;
                });
            }
            
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
            console.log("DOM loaded, initializing filters...");
            
            // Initialize filtered rows with all rows
            for (let i = 1; i < rows.length; i++) {
                filteredRows.push(rows[i]);
            }
            
            // Set up event listeners
            prevPageBtn.addEventListener('click', function() {
                if (currentPage > 1) {
                    currentPage--;
                    updatePagination();
                }
            });
            
            nextPageBtn.addEventListener('click', function() {
                const maxPage = Math.ceil(filteredRows.length / itemsPerPage);
                if (currentPage < maxPage) {
                    currentPage++;
                    updatePagination();
                }
            });
            
            itemsPerPageSelect.addEventListener('change', function() {
                itemsPerPage = parseInt(this.value);
                currentPage = 1; // Reset to first page
                updatePagination();
            });
            
            searchInput.addEventListener('input', applyFilters);
            statusFilter.addEventListener('change', applyFilters);
            sortSelect.addEventListener('change', applyFilters);
            
            // Initial pagination update
            updatePagination();
        });
        
        // Add CSS for status badges
        document.head.insertAdjacentHTML('beforeend', `
            <style>
                .status-badge {
                    display: inline-block;
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: 500;
                    text-transform: capitalize;
                }
                .status-badge.pending {
                    background-color: #FFF3CD;
                    color: #856404;
                }
                .status-badge.processing {
                    background-color: #D1ECF1;
                    color: #0C5460;
                }
                .status-badge.shipped {
                    background-color: #D4EDDA;
                    color: #155724;
                }
                .status-badge.delivered {
                    background-color: #CCE5FF;
                    color: #004085;
                }
                .status-badge.completed {
                    background-color: #D4EDDA;
                    color: #155724;
                }
                .status-badge.cancelled {
                    background-color: #F8D7DA;
                    color: #721C24;
                }
            </style>
        `);
    </script>
</body>
</html>