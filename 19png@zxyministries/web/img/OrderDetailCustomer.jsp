        <%@page import="java.util.*, da.OrderDAO, domain.Order"%>
        <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <!DOCTYPE html>
        <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Order Details</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                body {
                    background-color: #f8f9fa;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .order-card {
                    border-radius: 15px;
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                    border: none;
                    overflow: hidden;
                    margin-top:100px;
                }

                .order-header {
                    background: linear-gradient(135deg, #14532d 0%, #065f46 100%);
                    color: white;
                    padding: 20px;
                }

                .order-id {
                    font-weight: 700;
                    letter-spacing: 1px;
                }

                .status-badge {
                    font-size: 0.9rem;
                    padding: 8px 15px;
                    border-radius: 20px;
                }

                .info-section {
                    padding: 25px;
                    border-bottom: 1px solid #eee;
                }

                .info-title {
                    color: #4b6cb7;
                    font-weight: 600;
                    margin-bottom: 15px;
                    display: flex;
                    align-items: center;
                }

                .info-title i {
                    margin-right: 10px;
                }

                .info-item {
                    display: flex;
                    margin-bottom: 10px;
                }

                .info-label {
                    font-weight: 600;
                    width: 150px;
                    color: #495057;
                }

                .info-value {
                    color: #212529;
                }

                .timeline-section {
                    padding: 25px;
                }

                .timeline-container {
                    position: relative;
                    padding: 20px 0;
                }

                .timeline-track {
                    height: 5px;
                    background-color: #e9ecef;
                    position: relative;
                    margin: 30px 0;
                    border-radius: 5px;
                }

                .timeline-progress {
                    height: 5px;
                    border-radius: 5px;
                    position: absolute;
                    top: 0;
                    left: 0;
                }

                .timeline-steps {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 10px;
                }

                .timeline-step {
                    position: relative;
                    text-align: center;
                    width: 33%;
                }

                .step-icon {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background-color: #e9ecef;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 10px;
                    color: white;
                }

                .step-label {
                    font-size: 0.9rem;
                    font-weight: 600;
                }

                .actions-section {
                    padding: 25px;
                    display: flex;
                    gap: 15px;
                }

                .btn-action {
                    border-radius: 8px;
                    padding: 10px 25px;
                    font-weight: 600;
                    letter-spacing: 0.5px;
                    transition: all 0.3s;
                }

                .btn-review {
                    background-color: #4b6cb7;
                    border: none;
                }

                .btn-review:hover {
                    background-color: #3a5a9b;
                    transform: translateY(-2px);
                }

                .btn-back {
                    background-color: #6c757d;
                    border: none;
                }

                .btn-back:hover {
                    background-color: #5a6268;
                    transform: translateY(-2px);
                }

                .discount-tag {
                    display: inline-block;
                    background-color: #ff7043;
                    color: white;
                    padding: 3px 10px;
                    border-radius: 12px;
                    font-size: 0.8rem;
                    margin-left: 10px;
                    font-weight: 600;
                }

                .final-amount {
                    font-size: 1.3rem;
                    font-weight: 700;
                    color: #2e7d32;
                }

                @media (max-width: 768px) {
                    .info-item {
                        flex-direction: column;
                        margin-bottom: 15px;
                    }

                    .info-label {
                        width: 100%;
                        margin-bottom: 5px;
                    }
                }
            </style>
        </head>
        <body>
            <jsp:include page="header.jsp"/>

            <div class="container py-5">
                <%
                    String orderId = request.getParameter("orderId");
                    if (orderId == null || orderId.trim().isEmpty()) {
                        response.sendRedirect("orderCustomer.jsp");
                        return;
                    }

                    // Get customer ID from session
                    String customerId = (String) session.getAttribute("customerId");
                    if (customerId == null) {
                        response.sendRedirect("Login_cust.jsp");
                        return;
                    }

                    OrderDAO orderDAO = new OrderDAO();
                    Order order = orderDAO.getOrderById(orderId);

                    if (order == null || !order.getCustomerId().equals(customerId)) {
                %>
                    <div class="alert alert-danger shadow-sm" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        Order not found or you don't have permission to view this order.
                        <a href="orderCustomer.jsp" class="alert-link">Return to Orders</a>
                    </div>
                <%
                    } else {
                        // Define status variables
                        boolean isPackaging = order.getStatus().equals("Packaging");
                        boolean isShipping = order.getStatus().equals("Shipping");
                        boolean isDelivery = order.getStatus().equals("Delivery");

                        // Set progress width based on status
                        String progressWidth = isPackaging ? "33%" : isShipping ? "66%" : "100%";

                        // Set status color
                        String statusColor = isPackaging ? "warning" : 
                                            isShipping ? "info" : 
                                            isDelivery ? "success" : "secondary";
                %>
                    <div class="order-card card mb-4">
                        <div class="order-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h3 class="order-id m-0">ORDER #<%= order.getOrderId() %></h3>
                                <span class="status-badge bg-<%= statusColor %>">
                                    <i class="fas fa-<%= 
                                        isPackaging ? "box" : 
                                        isShipping ? "truck" : 
                                        isDelivery ? "check-circle" : "circle" %>"></i>
                                    <%= order.getStatus() %>
                                </span>
                            </div>
                        </div>

                        <div class="row g-0">
                            <div class="col-md-6">
                                <div class="info-section">
                                    <h5 class="info-title"><i class="fas fa-info-circle"></i> Order Information</h5>
                                    <div class="info-item">
                                        <div class="info-label">Order Date:</div>
                                        <div class="info-value"><i class="far fa-calendar-alt me-2"></i><%= order.getOrderDate() %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Customer Name:</div>
                                        <div class="info-value"><i class="far fa-user me-2"></i><%= order.getCustomerName() %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Items in Order:</div>
                                        <div class="info-value"><i class="fas fa-shopping-basket me-2"></i><%= order.getItemCount() %></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="info-section">
                                    <h5 class="info-title"><i class="fas fa-credit-card"></i> Payment Information</h5>
                                    <div class="info-item">
                                        <div class="info-label">Total Amount:</div>
                                        <div class="info-value">RM <%= String.format("%.2f", order.getTotalAmount()) %></div>
                                    </div>
                                    <% if (order.getDiscountAmountOrder() > 0) { %>
                                        <div class="info-item">
                                            <div class="info-label">Discount:</div>
                                            <div class="info-value text-danger">
                                                - RM <%= String.format("%.2f", order.getDiscountAmountOrder()) %>
                                                <span class="discount-tag"><i class="fas fa-tag me-1"></i>SAVINGS</span>
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Final Amount:</div>
                                            <div class="info-value final-amount">RM <%= String.format("%.2f", order.getPayAmount()) %></div>
                                        </div>
                                    <% } else { %>
                                        <div class="info-item">
                                            <div class="info-label">Final Amount:</div>
                                            <div class="info-value final-amount">RM <%= String.format("%.2f", order.getTotalAmount()) %></div>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <div class="timeline-section">
                            <h5 class="info-title"><i class="fas fa-map-marker-alt"></i> Order Status Timeline</h5>

                            <div class="timeline-container">
                                <div class="timeline-steps">
                                    <div class="timeline-step">
                                        <div class="step-icon <%= isPackaging || isShipping || isDelivery ? "bg-success" : "bg-secondary" %>">
                                            <i class="fas fa-box"></i>
                                        </div>
                                        <div class="step-label">Packaging</div>
                                    </div>
                                    <div class="timeline-step">
                                        <div class="step-icon <%= isShipping || isDelivery ? "bg-success" : "bg-secondary" %>">
                                            <i class="fas fa-truck"></i>
                                        </div>
                                        <div class="step-label">Shipping</div>
                                    </div>
                                    <div class="timeline-step">
                                        <div class="step-icon <%= isDelivery ? "bg-success" : "bg-secondary" %>">
                                            <i class="fas fa-home"></i>
                                        </div>
                                        <div class="step-label">Delivered</div>
                                    </div>
                                </div>

                                <div class="timeline-track">
                                    <div class="timeline-progress bg-success" style="width: <%= progressWidth %>;"></div>
                                </div>
                            </div>
                        </div>

                     
        </div><div class="actions-section">
            <% if (order.getStatus().equals("Delivery")) { %>
                <a href="CustomerReview.jsp?orderId=<%= order.getOrderId() %>" class="btn btn-review btn-action">
                    <i class="fas fa-star me-2"></i>Write Review
                </a>
                <a href="ViewReview.jsp?orderId=<%= order.getOrderId() %>" class="btn btn-info btn-action ms-2">
                    <i class="fas fa-comments me-2"></i>View Reviews
                </a>
            <% } %>
            <a href="orderCustomer.jsp" class="btn btn-back btn-action">
                <i class="fas fa-arrow-left me-2"></i>Back to Orders
            </a>
    
                <%
                    }
                    orderDAO.closeConnection();
                %>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>
         <script src="js/header.js"></script>
        </html>