<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="domain.Categories"%>
<%@page import="domain.Subcategories"%>
<%@page import="domain.Products"%>
<%@page import="domain.DashboardMetrics"%>
<%@page import="domain.Order"%>
<%@page import="domain.LowStockProduct"%>
<%@page import="domain.CustomerActivity"%>
<%@page import="domain.TopCategory"%>
<%@page import="da.Category_AdminDAO"%>
<%@page import="da.Subcategory_AdminDAO"%>
<%@page import="da.Product_AdminDAO"%>
<%@page import="da.DashboardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard</title>
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
        
        // Initialize the DAO and get dashboard metrics
        DashboardDAO dashboardDAO = new DashboardDAO();
        DashboardMetrics metrics = dashboardDAO.getDashboardMetrics();
        
        // Get monthly sales data for chart
        Map<String, Double> monthlySales = dashboardDAO.getMonthlySalesData();
        
        // Get recent orders
        List<Order> recentOrders = dashboardDAO.getRecentOrders(5);
        
        // Get low stock products
        List<LowStockProduct> lowStockProducts = dashboardDAO.getLowStockProducts();
        
        // Get top categories - updated to use the new TopCategory class
        List<TopCategory> topCategories = dashboardDAO.getTopCategories();
        
        // Get customer activity log
        List<CustomerActivity> activityLog = dashboardDAO.getCustomerActivityLog(10);
        
        // Close the database connection
        dashboardDAO.closeConnection();
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-tachometer-alt"></i>
                    <h1>Manager Dashboard</h1>
                </div>
                <div class="user-area">
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
                    <h2>Total Revenue</h2>
                    <div class="card-content">
                        <div class="card-value">RM <%= String.format("%.2f", metrics.getTotalRevenue()) %></div>
                        <i class="fas fa-dollar-sign card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Total Orders</h2>
                    <div class="card-content">
                        <div class="card-value"><%= metrics.getTotalOrders() %></div>
                        <i class="fas fa-shopping-cart card-icon"></i>
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

            <!-- Charts Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Sales Trends</h2>
                </div>
                <div style="height: 300px;">
                    <canvas id="salesTrendsChart"></canvas>
                </div>
            </div>

            <!-- Recent Orders Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Recent Orders</h2>
                    <a href="Orders_Admin.jsp" class="btn btn-primary">
                        <i class="fas fa-eye"></i> View All Orders
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (recentOrders != null && !recentOrders.isEmpty()) { %>
                                <% for (Order order : recentOrders) { %>
                                    <tr>
                                        <td><%= order.getOrderId() %></td>
                                        <td><%= order.getCustomerName() %></td>
                                        <td><%= order.getOrderDate() %></td>
                                        <td class="price">RM <%= String.format("%.2f", order.getTotalAmount()) %></td>
                                        <td>
                                            <% 
                                            String status = order.getStatus(); 
                                            String statusClass = "";
                                            if (status.equalsIgnoreCase("completed")) statusClass = "status-completed";
                                            else if (status.equalsIgnoreCase("processing")) statusClass = "status-processing";
                                            else if (status.equalsIgnoreCase("shipped")) statusClass = "status-shipped";
                                            else if (status.equalsIgnoreCase("cancelled")) statusClass = "status-cancelled";
                                            %>
                                            <span class="status-badge <%= statusClass %>"><%= status %></span>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <a href="OrderDetails.jsp?id=<%= order.getOrderId() %>" class="action-btn view-btn">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } else { %>
                                <tr>
                                    <td colspan="6" class="text-center">No recent orders found</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Customer Activity Section removed as requested -->

            <!-- Low Stock Products -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Low Stock Products</h2>
                    <a href="Product_Admin.jsp" class="btn btn-primary">
                        <i class="fas fa-boxes"></i> Manage Inventory
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>Product ID</th>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Current Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (lowStockProducts != null && !lowStockProducts.isEmpty()) { %>
                                <% for (LowStockProduct product : lowStockProducts) { %>
                                    <tr>
                                        <td><%= product.getProductId() %></td>
                                        <td class="product-name"><%= product.getProductName() %></td>
                                        <td><span class="category-badge"><%= product.getCategory() %></span></td>
                                        <td>
                                            <div class="stock-status">
                                                <div class="stock-indicator low-stock"></div>
                                                <%= product.getStockQty() %>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <a href="ProductEdit.jsp?product_id=<%= product.getProductId() %>" class="action-btn edit-btn">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } else { %>
                                <tr>
                                    <td colspan="5" class="text-center">No low stock products found</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Initialize charts with data from JSP
        document.addEventListener('DOMContentLoaded', function() {
            // Sales Trends Chart
            const salesCtx = document.getElementById('salesTrendsChart').getContext('2d');
            const salesLabels = [<% 
                boolean first = true;
                for (String month : monthlySales.keySet()) {
                    if (!first) out.print(", ");
                    out.print("'" + month + "'");
                    first = false;
                }
            %>];
            
            const salesData = [<% 
                first = true;
                for (Double value : monthlySales.values()) {
                    if (!first) out.print(", ");
                    out.print(value);
                    first = false;
                }
            %>];
            
            new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: salesLabels,
                    datasets: [{
                        label: 'Sales (RM)',
                        data: salesData,
                        backgroundColor: 'rgba(26, 93, 66, 0.2)',
                        borderColor: 'rgba(26, 93, 66, 1)',
                        borderWidth: 2,
                        pointBackgroundColor: 'rgba(26, 93, 66, 1)',
                        pointBorderColor: '#fff',
                        pointRadius: 4,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'RM ' + context.parsed.y.toFixed(2);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return 'RM ' + value;
                                }
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>