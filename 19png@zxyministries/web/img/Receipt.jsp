<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Payment Receipt</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="./css/Product_Customer.css">
    <style>
        body {
            background-color: #fff;
            font-family: Arial, sans-serif;
        }
        
        .receipt-success i{
            color: #008000;
        }
        
        .receipt-success h3{
            color: #008000;
        }
        
        .receipt-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-radius: 8px;
        }
        
        .receipt-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .receipt-details {
            margin: 20px 0;
        }
        
        .receipt-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding: 5px 0;
        }
        
        .receipt-label {
            font-weight: 500;
            color: #333;
        }
        
        .receipt-value {
            text-align: right;
            color: #666;
        }
        
        .receipt-total {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #008000;
            font-weight: bold;
            font-size: larger;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }


        .thank-you {
            text-align: center;
            margin-top: 40px;
            color: #008000;
        }
        
        .btn-continue {
            display: block;
            width: 200px;
            margin: 30px auto;
            padding: 12px;
            background-color: #008000;
            color: white;
            text-align: center;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
        }
        
        .btn-continue:hover {
            background-color: #008000;
            color: white;
            text-decoration: none;
        }
        
        /* 添加订单项目表格样式 */
        .receipt-details-section {
            background-color: #f8f9fa;
            padding: 25px;
            margin: 30px 0;
            border-radius: 8px;
            border: 1px solid #eee;
        }
        
        .receipt-details-section h4 {
            color: #333;
            font-size: 18px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .receipt-details-table {
            width: 100%;
            border-collapse: collapse;
        }
                
        .order-items-table tr:last-child td {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <a href="Product_Customer.jsp">
              <img src="img/Logo/logo2.png" width="280" height="190" alt="Logo"/>
            </a>
        </div>
    </header>
    
    <div class="container receipt-container">
        <div class="receipt-header">
            <h2>Payment Receipt</h2>
            <p>Thank you for your purchase!</p>
        </div>
        
        <div class="receipt-success">
            <i class="fas fa-check-circle" style="font-size: 30px;"></i>
            <h3>Payment Successful</h3>
            <p>Your order has been placed successfully.</p>
        </div>
        
        <div class="receipt-details">
            <div class="receipt-row">
                <span class="receipt-label">Transaction Number</span>
                <span class="receipt-value">${param.orderId}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Customer Name</span>
                <span class="receipt-value">${sessionScope.customer.name}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Payment Method</span>
                <span class="receipt-value">${param.paymentMethod}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Date</span>
                <span class="receipt-value">
                    <jsp:useBean id="now" class="java.util.Date" />
                    <fmt:formatDate value="${now}" pattern="dd/MM/yyyy"/>
                </span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Shipping Address</span>
                <span class="receipt-value">${param.shippingAddress}</span>
            </div>
            
            <!-- 添加折扣代码显示 -->
            <c:if test="${not empty param.discountCode}">
            <div class="receipt-row">
                <span class="receipt-label">Promo Code</span>
                <span class="receipt-value">${param.discountCode}</span>
            </div>
            </c:if>
        </div>
    
 <div class="receipt-details-section">
    <table class="receipt-details-table">       
        <div class="receipt-details">
            <div class="receipt-row">
                <span class="receipt-label">Subtotal</span>
                <span class="receipt-value">${param.totalPrice}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Shipping Cost</span>
                <span class="receipt-value">${param.shippingCost}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Sales Tax</span>
                <span class="receipt-value">${param.salesTax}</span>
            </div>
            
            <!-- 添加折扣金额显示 -->
            <c:if test="${not empty param.discountAmount && param.discountAmount != '0'}">
            <div class="receipt-row" style="color: #008000; font-weight: bold;">
                <span class="receipt-label">Discount</span>
                <span class="receipt-value">- RM ${param.discountAmount}</span>
            </div>
            </c:if>
            
            <div class="receipt-row receipt-total">
                <span class="receipt-label">Total Amount</span>
                <span class="receipt-value">${param.finalTotal}</span>
            </div>
        </div>
    </table>
</div>
        
        <div class="thank-you">
            <h3>Thank you for shopping with us!</h3>
            <p>Your order has been confirmed and will be shipped soon.</p>
            <p>Expected delivery date: 
                <jsp:useBean id="deliveryDate" class="java.util.Date" />
                <c:set var="fiveDays" value="${5 * 24 * 60 * 60 * 1000}" />
                <c:set target="${deliveryDate}" property="time" value="${deliveryDate.time + fiveDays}" />
                <fmt:formatDate value="${deliveryDate}" pattern="dd/MM/yyyy"/>
            </p>
        </div>
        
        <div class="text-center mt-4">
            <a href="Product_Customer.jsp" class="btn-continue">Continue Shopping</a>
        </div>
    </div>
</body>
</html>