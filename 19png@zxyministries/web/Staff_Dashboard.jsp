<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="domain.Products"%>
<%@page import="domain.CustomerActivity"%>
<%@page import="domain.DashboardMetrics"%>
<%@page import="domain.Order"%>
<%@page import="domain.LowStockProduct"%>
<%@page import="da.Product_AdminDAO"%>
<%@page import="da.DashboardDAO"%>
<%@page import="da.OrderDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard</title>
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
        if (session.getAttribute("staffId") == null) {
            response.sendRedirect("Login_Staff.jsp");
            return;
        }
        
        // Initialize the DAO and get dashboard metrics
        DashboardDAO dashboardDAO = new DashboardDAO();
        
        // Get customer activity log
        List<CustomerActivity> activityLog = dashboardDAO.getCustomerActivityLog(10);
        
        // Get recent orders
        List<Order> recentOrders = dashboardDAO.getRecentOrders(5);
        
        // Get low stock products
        List<LowStockProduct> lowStockProducts = dashboardDAO.getLowStockProducts();
        
        // Get pending orders count
        OrderDAO orderDAO = new OrderDAO();
        int pendingOrdersCount = orderDAO.countOrdersByStatus("Processing");
        orderDAO.closeConnection();
        
        // Close the database connection
        dashboardDAO.closeConnection();
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-tachometer-alt"></i>
                    <h1>Staff Dashboard</h1>
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
                    <h2>Pending Orders</h2>
                    <div class="card-content">
                        <div class="card-value"><%= pendingOrdersCount %></div>
                        <i class="fas fa-clock card-icon"></i>
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

            <!-- Recent Orders Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Recent Orders</h2>
                    <a href="Staff_Orders.jsp" class="btn btn-primary">
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

            <!-- Customer Activity Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Customer Activity</h2>
                </div>
                <div class="activity-list">
                    <% if (activityLog != null && !activityLog.isEmpty()) { %>
                        <% for (CustomerActivity activity : activityLog) { %>
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="activity-details">
                                    <div class="activity-message">
                                        <%= activity.getCustomerName() %> made a purchase of RM <%= String.format("%.2f", activity.getAmount()) %>
                                    </div>
                                    <div class="activity-meta">
                                        <div class="activity-time"><%= activity.getDate() %></div>
                                        <div class="activity-status">Status: <%= activity.getStatus() %></div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="text-center py-3">No recent activity found</div>
                    <% } %>
                </div>
            </div>

        </div>
    </div>

    <style>
        /* Additional styles to match Manager Dashboard */
        .activity-list {
            margin-top: 15px;
        }
        
        .activity-item {
            display: flex;
            padding: 15px;
            border-bottom: 1px solid #eee;
            background-color: #fff;
            border-radius: 5px;
            margin-bottom: 10px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .task-list, .announcement-list {
            margin-top: 15px;
        }
        
        .task-item, .announcement-item {
            padding: 15px;
            background-color: #fff;
            border-radius: 5px;
            margin-bottom: 10px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .status-urgent {
            background-color: #dc3545;
            color: white;
        }
        
        .status-completed {
            background-color: #28a745;
            color: white;
        }
        
        .status-processing {
            background-color: #007bff;
            color: white;
        }
        
        .status-shipped {
            background-color: #6f42c1;
            color: white;
        }
        
        .status-cancelled {
            background-color: #6c757d;
            color: white;
        }
        
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .d-flex {
            display: flex;
        }
        
        .justify-content-between {
            justify-content: space-between;
        }
        
        .mb-1 {
            margin-bottom: 0.25rem;
        }
        
        .small {
            font-size: 85%;
        }
        
        .text-muted {
            color: #6c757d;
        }
    </style>
</body>
</html>