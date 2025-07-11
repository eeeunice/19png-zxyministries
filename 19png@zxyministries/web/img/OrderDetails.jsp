<%@ page import="java.util.*, da.OrderDAO, da.OrderDetailDAO, domain.Order, domain.OrderDetail" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <link rel="stylesheet" href="css/orders.css">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <style>
        .order-details-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        
        .order-id {
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
        }
        
        .status-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .status-badge.processing {
            background-color: #FFF3CD;
            color: #856404;
        }
        
        .status-badge.shipped {
            background-color: #CCE5FF;
            color: #004085;
        }
        
        .status-badge.delivered {
            background-color: #D4EDDA;
            color: #155724;
        }
        
        .status-badge.cancelled {
            background-color: #F8D7DA;
            color: #721C24;
        }
        
        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-group {
            margin-bottom: 20px;
        }
        
        .info-label {
            font-weight: 600;
            color: #6c757d;
            margin-bottom: 5px;
            display: block;
        }
        
        .info-value {
            font-size: 1.1rem;
            color: #333;
        }
        
        .order-items {
            margin-bottom: 30px;
        }
        
        .items-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .items-table th {
            background-color: #f8f9fa;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }
        
        .items-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .product-name {
            font-weight: 600;
            color: #333;
        }
        
        .price {
            font-weight: 600;
            color: #28a745;
        }
        
        .order-summary {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .summary-label {
            font-weight: 600;
            color: #6c757d;
        }
        
        .summary-value {
            font-weight: 600;
            color: #333;
        }
        
        .total-row {
            border-top: 2px solid #dee2e6;
            padding-top: 10px;
            margin-top: 10px;
        }
        
        .total-label {
            font-weight: 700;
            font-size: 1.1rem;
            color: #333;
        }
        
        .total-value {
            font-weight: 700;
            font-size: 1.1rem;
            color: #28a745;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        
        .btn-update-status {
            background-color: #4b6cb7;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s;
        }
        
        .btn-update-status:hover {
            background-color: #3a5a9b;
        }
        
        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s;
        }
        
        .btn-delete:hover {
            background-color: #c82333;
        }
        
        .status-select {
            padding: 8px 15px;
            border-radius: 5px;
            border: 1px solid #ced4da;
            font-size: 1rem;
            margin-right: 10px;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .modal-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #333;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #333;
        }
        
        .modal-body {
            margin-bottom: 20px;
        }
        
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        .btn-cancel {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .btn-confirm {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        if (session.getAttribute("managerId") == null) {
            response.sendRedirect("Login_mgn.jsp");
            return;
        }
        
        // Get order ID from request parameter
        String orderId = request.getParameter("id");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect("Orders_Manager.jsp");
            return;
        }
        
        // Initialize order data
        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        Order order = null;
        List<OrderDetail> orderDetails = null;
        
        try {
            order = orderDAO.getOrderById(orderId);
            if (order != null) {
                orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);
                order.setOrderDetails(orderDetails);
            }
        } finally {
            // Ensure database connections are closed
            orderDAO.closeConnection();
            orderDetailDAO.closeConnection();
        }
        
        // Check if order exists
        if (order == null) {
            response.sendRedirect("Orders_Manager.jsp");
            return;
        }
        
        // Get status message from session if available
        String statusMessage = (String) session.getAttribute("statusMessage");
        String statusType = (String) session.getAttribute("statusType");
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
                    <h1>Order Details</h1>
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
            <!-- Status Message -->
            <% if (statusMessage != null) { %>
                <div class="alert alert-<%= statusType %>">
                    <%= statusMessage %>
                </div>
            <% } %>
            
            <!-- Order Details -->
            <div class="order-details-container">
                <div class="order-header">
                    <span class="status-badge status-<%= order.getStatus().toLowerCase() %>"><%= order.getStatus() %></span>
                </div>
                
                <div class="order-info">
                    <div class="info-group">
                        <span class="info-label">Customer</span>
                        <span class="info-value"><%= order.getCustomerName() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Order Date</span>
                        <span class="info-value"><%= order.getOrderDate() %></span>
                    </div>
                </div>
                
                <div class="order-items">
                    <h3>Order Items</h3>
                    <table class="items-table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Category</th>
                                <th>Description</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Discount</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                double subtotal = 0;
                                double totalDiscount = 0;
                                
                                if (orderDetails != null && !orderDetails.isEmpty()) {
                                    for (OrderDetail detail : orderDetails) {
                                        subtotal += detail.getTotalAmountProduct();
                                        totalDiscount += detail.getDiscountAmountProduct();
                            %>
                                <tr>
                                    <!-- Inside your product table row -->
                                    <td>
                                        <div class="product-info">
                                            <div class="product-image-container">
                                                <% if (detail.getProduct().getImageUrl() != null && !detail.getProduct().getImageUrl().isEmpty()) { %>
                                                    <img src="<%= detail.getProduct().getImageUrl() %>" alt="<%= detail.getProduct().getProductName() %>" class="product-thumbnail">
                                                <% } else { %>
                                                <% } %>
                                            </div>
                                            <span class="product-id"><%= detail.getProductId() %></span>
                                            <strong><%= detail.getProduct().getProductName() %></strong>
                                            <p class="product-description">
                                                <% 
                                                    String description = detail.getProduct().getDescription();
                                                    if (description != null && description.length() > 100) {
                                                        out.print(description.substring(0, 100) + "...");
                                                    } else {
                                                        out.print(description != null ? description : "");
                                                    }
                                                %>
                                            </p>
                                        </div>
                                    </td>
                                    </td>
                                    <td><%= detail.getProduct().getCategoryName() != null ? detail.getProduct().getCategoryName() : "N/A" %>
                                        <% if (detail.getProduct().getSubcategoryName() != null) { %>
                                            <br><small><%= detail.getProduct().getSubcategoryName() %></small>
                                        <% } %>
                                    </td>
                                    <td class="product-description">
                                        <% if (detail.getProduct().getDescription() != null && !detail.getProduct().getDescription().isEmpty()) { %>
                                            <%= detail.getProduct().getDescription().length() > 100 ? detail.getProduct().getDescription().substring(0, 100) + "..." : detail.getProduct().getDescription() %>
                                        <% } else { %>
                                            No description available
                                        <% } %>
                                    </td>
                                    <td><%= detail.getQuantity() %></td>
                                    <td>RM <%= String.format("%.2f", detail.getUnitPrice()) %></td>
                                    <td>RM <%= String.format("%.2f", detail.getDiscountAmountProduct()) %></td>
                                    <td class="price">RM <%= String.format("%.2f", detail.getTotalAmountProduct()) %></td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="7" class="text-center">No items found for this order</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <div class="order-summary">
                    <div class="summary-row">
                        <span class="summary-label">Subtotal</span>
                        <span class="summary-value">RM <%= String.format("%.2f", subtotal) %></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Discount</span>
                        <span class="summary-value">RM <%= String.format("%.2f", totalDiscount) %></span>
                    </div>
                    <div class="summary-row total-row">
                        <span class="total-label">Total</span>
                        <span class="total-value">RM <%= String.format("%.2f", order.getTotalAmount()) %></span>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="action-buttons">
                    <form action="UpdateOrderStatusServlet" method="post" style="display: flex; gap: 10px;">
                        <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                        <select name="status" id="status" class="status-select">
                            <option value="Processing" class="status-processing" <%= order.getStatus().equalsIgnoreCase("Processing") ? "selected" : "" %>>Processing</option>
                            <option value="Shipped" class="status-shipping" <%= order.getStatus().equalsIgnoreCase("Shipping") ? "selected" : "" %>>Completed</option>
                            <option value="Delivered" class="status-delivery" <%= order.getStatus().equalsIgnoreCase("Delivery") ? "selected" : "" %>>Delivered</option>
                        </select>
                        <button type="submit" class="btn-update-status">Update Status</button>
                    </form>
                    <button class="btn-delete" onclick="openDeleteModal()">Delete Order</button>
                </div>
            </div>
            
            <!-- Back Button -->
            <div style="margin-bottom: 30px;">
                <a href="Orders_Manager.jsp" class="btn-back" style="text-decoration: none; color: white; background-color: #6c757d; padding: 10px 20px; border-radius: 5px; display: inline-block;">
                    <i class="fas fa-arrow-left"></i> Back to Orders
                </a>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Confirm Deletion</h3>
                <span class="close" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete Order #<%= order.getOrderId() %>? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeDeleteModal()">Cancel</button>
                <form action="DeleteOrderServlet" method="post" style="margin: 0;">
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <button type="submit" class="btn-confirm">Delete</button>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Modal functions
        function openDeleteModal() {
            document.getElementById('deleteModal').style.display = 'block';
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }
        
        // Close modal when clicking outside of it
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                closeDeleteModal();
            }
        }
    </script>
</body>
</html>