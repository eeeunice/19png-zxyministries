<%@page import="java.util.*, da.OrderDAO, domain.Order, java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <title>Header and Footer Only</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        :root {
            --primary: #1a5d42;
            --primary-light: #2d8e6a;
            --primary-dark: #154733;
            --secondary: #f8f9fa;
            --accent: #3cb878;
            --light-bg: #f5f7f9;
            --border-radius: 12px;
            --box-shadow: 0 4px 20px rgba(26, 93, 66, 0.1);
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
            color: #333;
        }
        
        .page-container {
            padding: 40px 20px;
        }
        
        .orders-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 25px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            box-shadow: var(--box-shadow);
            position: relative;
            overflow: hidden;
        }
        
        .orders-header::before {
            content: '';
            position: absolute;
            top: -10px;
            right: -10px;
            width: 150px;
            height: 150px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        
        .header-content {
            position: relative;
            z-index: 2;
        }
        
        .order-summary {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .order-summary:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(26, 93, 66, 0.15);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            margin-bottom: 15px;
        }
        
        .order-id {
            font-weight: 600;
            color: var(--primary);
            font-size: 1.1em;
        }
        
        .order-date {
            color: #6c757d;
            font-size: 0.9em;
        }
        
        .order-details {
            display: flex;
            justify-content: space-between; /* Aligns items to the ends */
            flex-wrap: wrap;
            gap: 30px;
        }

        .total-amount {
            margin-left: 900px; /* Pushes the total amount to the right */
        }
        
        .order-detail-item {
            flex: 1;
            min-width: 120px;
        }
        
        .detail-label {
            font-size: 0.85em;
            color: #6c757d;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-weight: 600;
            font-size: 1.05em;
        }
        
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .status-badge {
            padding: 8px 14px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.85em;
        }
        
        .status-completed {
            background-color: rgba(60, 184, 120, 0.15);
            color: #2a9d8f;
        }
        
        .status-pending {
            background-color: rgba(247, 183, 49, 0.15);
            color: #e9c46a;
        }
        
        .status-processing {
            background-color: rgba(45, 149, 150, 0.15);
            color: #2d9596;
        }
        
        .status-cancelled {
            background-color: rgba(231, 76, 60, 0.15);
            color: #e63946;
        }
        
        .action-btn {
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .action-btn-primary {
            background-color: var(--primary);
            color: white;
            border: none;
        }
        
        .action-btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            color: white;
        }
        
        .action-btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }
        
        .action-btn-outline:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .empty-orders {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 50px 20px;
            text-align: center;
        }
        
        .empty-icon {
            font-size: 60px;
            color: #dee2e6;
            margin-bottom: 20px;
        }
        
        .footer-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .item-count-badge {
            background-color: var(--primary-light);
            color: white;
            border-radius: 50px;
            padding: 5px 12px;
            font-size: 0.85em;
            font-weight: 600;
        }
        
        .price-tag {
            font-weight: 700;
            color: var(--primary);
            font-size: 1.2em;
        }
        
        .loading-skeleton {
            animation: pulse 1.5s infinite;
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            border-radius: 4px;
        }
        
        @keyframes pulse {
            0% {
                background-position: 200% 0;
            }
            100% {
                background-position: -200% 0;
            }
        }
        
        @media (max-width: 768px) {
            .order-details {
                flex-direction: column;
                gap: 15px;
            }
            
            .order-footer {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .action-btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
     
</head>
<script src="js/header.js"></script>
<body>
    <%
        // Check if user is logged in
        String customerId = (String) session.getAttribute("customerId");
        if (customerId == null) {
            response.sendRedirect("Login_cust.jsp");
            return;
        }
        
        // Get customer's orders
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByCustomer(customerId);
        
        // Format dates
        SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat outputDateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        
         // Count orders by status
        int deliveryOrders = 0;
        int shippingOrders = 0;
        int packagingOrders = 0;
        
        for (Order order : orders) {
            String status = order.getStatus();
            if ("Delivery".equals(status)) {
                deliveryOrders++;
            } else if ("Shipping".equals(status)) {
                shippingOrders++;
            } else if ("Packaging".equals(status)) {
                packagingOrders++;
            }
        }
    %>

    
     <div class="container page-container">
        <div class="orders-header">
            <div class="header-content">
                <h2 class="mb-2"><i class="fas fa-box me-2"></i>My Orders</h2>
                <p class="mb-0">Track and manage your order history</p>
                
                <% if (!orders.isEmpty()) { %>
                <div class="row mt-4">
                    <div class="col-md-4 mb-2">
                        <div class="bg-white bg-opacity-10 p-3 rounded">
                            <div class="d-flex align-items-center">
                                <div class="me-3">
                                    <i class="fas fa-truck fa-2x text-white opacity-75"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold"><%= deliveryOrders %></div>
                                    <div class="small">In Delivery</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-2">
                        <div class="bg-white bg-opacity-10 p-3 rounded">
                            <div class="d-flex align-items-center">
                                <div class="me-3">
                                    <i class="fas fa-shipping-fast fa-2x text-white opacity-75"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold"><%= shippingOrders %></div>
                                    <div class="small">In Shipping</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-2">
                        <div class="bg-white bg-opacity-10 p-3 rounded">
                            <div class="d-flex align-items-center">
                                <div class="me-3">
                                    <i class="fas fa-box-open fa-2x text-white opacity-75"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold"><%= packagingOrders %></div>
                                    <div class="small">In Packaging</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        
        <% if (orders.isEmpty()) { %>
            <div class="empty-orders">
                <div class="empty-icon">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <h3>No Orders Yet</h3>
                <p class="text-muted mb-4">You haven't placed any orders yet. Start shopping to see your orders here.</p>
                <a href="Product_Customer.jsp" class="action-btn action-btn-primary">
                    <i class="fas fa-store me-2"></i>Browse Products
                </a>
            </div>
        <% } else { %>
            <div class="mb-4">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" class="form-control border-start-0" id="orderSearch" placeholder="Search orders by ID or status...">
                </div>
            </div>
            
            <div id="ordersList">
               <% for (Order order : orders) { 
                        String statusClass = "";
                        String status = order.getStatus();
                        if ("Delivery".equals(status)) {
                            statusClass = "status-completed";
                        } else if ("Shipping".equals(status)) {
                            statusClass = "status-processing";
                        } else if ("Packaging".equals(status)) {
                            statusClass = "status-pending";
                        } else {
                            statusClass = "status-cancelled";
                        }
                    
                    // Format date if it's not null
                    String formattedDate = "";
                    try {
                        if (order.getOrderDate() != null) {
                            Date parsedDate = inputDateFormat.parse(order.getOrderDate().toString());
                            formattedDate = outputDateFormat.format(parsedDate);
                        }
                    } catch (Exception e) {
                        // Use original date if parsing fails
                        formattedDate = order.getOrderDate().toString();
                    }
                %>
                <div class="order-summary">
                    <div class="order-header">
                        <div class="order-id">
                            <i class="fas fa-hashtag me-1"></i> Order #<%= order.getOrderId() %>
                        </div>
                        <div class="order-date">
                            <i class="far fa-calendar-alt me-1"></i> <%= formattedDate %>
                        </div>
                    </div>
                    
                                <div class="order-details">
                  <div class="order-detail-item">
                      <div class="detail-label">Items</div>
                      <div class="detail-value">
                          <span class="item-count-badge"><%= order.getItemCount() %></span>
                      </div>
                  </div>
                  <div class="order-detail-item total-amount">
                      <div class="detail-label">Total Amount</div>
                      <div class="detail-value price-tag">
                          RM <%= String.format("%.2f", order.getTotalAmount()) %>
                      </div>
                  </div>
              </div>
                      <br>
                     <div class="order-detail-item">
                    <div class="detail-label">Status</div>
                   <div class="detail-value">
                    <span class="status-badge <%= statusClass %>">
                        <% if ("Delivery".equals(order.getStatus())) { %>
                            <i class="fas fa-truck me-1"></i>
                        <% } else if ("Shipping".equals(order.getStatus())) { %>
                            <i class="fas fa-shipping-fast me-1"></i>
                        <% } else if ("Packaging".equals(order.getStatus())) { %>
                            <i class="fas fa-box-open me-1"></i>
                        <% } %>
                        <%= order.getStatus() %>
                    </span>
                </div>
                </div>
                    
                    <div class="order-footer">
                        <div>
                            <% if ("Pending".equals(order.getStatus())) { %>
                                <button class="btn btn-sm btn-outline-danger me-2">
                                    <i class="fas fa-times me-1"></i> Cancel
                                </button>
                            <% } %>
                        </div>
                        
                        <a href="OrderDetailCustomer.jsp?orderId=<%= order.getOrderId() %>" class="action-btn action-btn-primary">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
        
        <div class="footer-actions">
            <a href="Product_Customer.jsp" class="action-btn action-btn-outline">
                <i class="fas fa-arrow-left me-2"></i> Continue Shopping
            </a>
            
           
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Search functionality
        document.getElementById('orderSearch').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const orderItems = document.querySelectorAll('.order-summary');
            
            orderItems.forEach(item => {
                const text = item.textContent.toLowerCase();
                if(text.includes(searchValue)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });
        
        // Add loading effect simulation (for demo purposes)
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                document.querySelectorAll('.loading-skeleton').forEach(function(el) {
                    el.classList.remove('loading-skeleton');
                });
            }, 1000);
        });
    </script>
     <script src="js/footer.js"></script>
</body>
</html>