<%@ page import="java.util.*, da.OrderDAO, domain.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Orders</title>
        <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="./css/Product_Admin.css" rel="stylesheet">
        <link rel="stylesheet" href="css/orders.css">
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

            // Initialize order data
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = null;
            int totalOrders = 0;
            int pendingOrders = 0;
            int completedOrders = 0;

            try {
                orders = orderDAO.getAllOrders();

                if (orders != null && !orders.isEmpty()) {
                    totalOrders = orders.size();

                    // Calculate metrics
                    for (Order order : orders) {
                        if ("Processing".equalsIgnoreCase(order.getStatus())) {
                            pendingOrders++;
                        } else if ("shipping".equalsIgnoreCase(order.getStatus())
                                || "Shipping".equalsIgnoreCase(order.getStatus())) {
                            completedOrders++;
                        }
                    }
                }
            } finally {
                // Ensure database connection is closed
                orderDAO.closeConnection();
            }


            // Get status message if any
            String statusMessage = (String) session.getAttribute("statusMessage");
            String statusType = (String) session.getAttribute("statusType");

            // Clear session attributes after displaying
            if (statusMessage != null) {
                session.removeAttribute("statusMessage");
                session.removeAttribute("statusType");
            }
        %>

        <!-- Header -->
        <header class="header">
            <div class="container">
                <div class="header-content">
                    <div class="logo">
                        <i class="fas fa-shopping-cart"></i>
                        <h1>Staff Orders</h1>
                    </div>
                    <div class="user-area">
                        <a href="staffProfile.jsp?id=<%= session.getAttribute("staffId")%>" class="user-profile-link">
                            <div class="user-profile">
                                <div class="user-avatar">S</div>
                                <span><%= session.getAttribute("staffName") != null ? session.getAttribute("staffName") : "Staff"%></span>
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
                    <a href="Staff_Dashboard.jsp" class="nav-item"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                    <a href="staffdisplaycust.jsp" class="nav-item"><i class="fas fa-users"></i> Customers</a>
                    <a href="Staff_Product.jsp" class="nav-item"><i class="fas fa-boxes"></i> Products </a>
                    <a href="Staff_Orders.jsp" class="nav-item active"><i class="fas fa-shopping-cart"></i> Orders </a>
                    <a href="ViewFeedback.jsp" class="nav-item"><i class="fas fa-comments"></i> Feedback </a>
                    <a href="ReviewManagement.jsp" class="nav-item"><i class="fas fa-comments"></i> Reviews</a>
                    <a href="adminContact" class="nav-item"><i class="fas fa-comments"></i> Contact Us</a>
                    <a href="Logout.jsp" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>

                <!-- Status Message -->
                <% if (statusMessage != null) {%>
                <div class="alert alert-<%= statusType%>">
                    <%= statusMessage%>
                </div>
                <% }%>

                <!-- Order Stats Cards -->
                <div class="dashboard-cards">
                    <div class="card">
                        <h2>Total Orders</h2>
                        <div class="card-content">
                            <div class="card-value" id="totalOrders"><%= totalOrders%></div>
                            <i class="fas fa-shopping-cart card-icon"></i>
                        </div>
                    </div>
                    <div class="card">
                        <h2>Pending Orders</h2>
                        <div class="card-content">
                            <div class="card-value" id="pendingOrders"><%= pendingOrders%></div>
                            <i class="fas fa-clock card-icon"></i>
                        </div>
                    </div>
                    <div class="card">
                        <h2>Completed Orders</h2>
                        <div class="card-content">
                            <div class="card-value" id="completedOrders"><%= completedOrders%></div>
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
                            <label for="status">Status:</label>
                            <select class="filter-select" id="status">
                                <option value="">All Statuses</option>
                                <option value="processing">Processing</option>
                                <option value="Delivery">Delivered</option>
                                <option value="shipping">Shipping</option>
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
                                    // Reopen connection to get fresh data
                                    orderDAO = new OrderDAO();
                                    try {
                                        orders = orderDAO.getAllOrders();

                                        if (orders != null && !orders.isEmpty()) {
                                            for (Order order : orders) {
                                                String statusClass = "";
                                                if (order.getStatus().equalsIgnoreCase("completed")
                                                        || order.getStatus().equalsIgnoreCase("Delivery")) {
                                                    statusClass = "status-completed";
                                                } else if (order.getStatus().equalsIgnoreCase("processing")) {
                                                    statusClass = "status-processing";
                                                } else if (order.getStatus().equalsIgnoreCase("shipped")
                                                        || order.getStatus().equalsIgnoreCase("shipping")) {
                                                    statusClass = "status-shipped";
                                                } else if (order.getStatus().equalsIgnoreCase("cancelled")) {
                                                    statusClass = "status-cancelled";
                                                }
                                %>
                                <tr>
                                    <td><%= order.getOrderId()%></td>
                                    <td><%= order.getCustomerName()%></td>
                                    <td><%= order.getOrderDate()%></td>
                                    <td class="price">RM <%= String.format("%.2f", order.getTotalAmount())%></td>
                                    <td>
                                        <span class="status-badge <%= statusClass%>"><%= order.getStatus()%></span>
                                    </td> 
                                    <td>
                                        <div class="actions">
                                            <!-- Status Update Form -->
                                            <form action="UpdateOrderStatusServlet" method="POST" style="display:inline;">
                                                <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">
                                                <input type="hidden" name="source" value="staff">
                                                <select name="status" class="status-select">
                                                    <option value="Processing" <%= order.getStatus().equalsIgnoreCase("Processing") ? "selected" : ""%>>Processing</option>
                                                    <option value="Shipped" <%= order.getStatus().equalsIgnoreCase("Shipping") ? "selected" : ""%>>Shipped</option>
                                                    <option value="Delivered" <%= order.getStatus().equalsIgnoreCase("Delivery") ? "selected" : ""%>>Delivered</option>
                                                </select>
                                                <button type="submit" class="action-btn update-btn">
                                                    <i class="fas fa-save"></i>
                                                </button>
                                            </form>
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
                                    } finally {
                                        orderDAO.closeConnection();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Filter and search functionality
            $(document).ready(function () {
                $("#orderSearch").on("keyup", function () {
                    var value = $(this).val().toLowerCase();
                    $("#ordersTable tbody tr").filter(function () {
                        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                    });
                    updateOrderCounts();
                });

                $("#status").on("change", function () {
                    var value = $(this).val().toLowerCase();
                    if (value === "") {
                        $("#ordersTable tbody tr").show();
                    } else {
                        $("#ordersTable tbody tr").filter(function () {
                            var statusText = $(this).find(".status-badge").text().toLowerCase();
                            $(this).toggle(statusText.indexOf(value) > -1);
                        });
                    }
                    updateOrderCounts();
                });

                function updateOrderCounts() {
                    var totalVisible = $("#ordersTable tbody tr:visible").length;
                    var pendingVisible = $("#ordersTable tbody tr:visible .status-badge:contains('Processing')").length;
                    var completedVisible = $("#ordersTable tbody tr:visible .status-badge:contains('Delivery')").length;

                    $("#totalOrders").text(totalVisible);
                    $("#pendingOrders").text(pendingVisible);
                    $("#completedOrders").text(completedVisible);
                }
            });
        </script>
    </body>
</html>