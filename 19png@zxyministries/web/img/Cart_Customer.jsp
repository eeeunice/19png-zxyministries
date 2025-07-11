<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Your Shopping Cart - Beauty And Beast</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="./css/Product_Customer.css">
    <style>
        .cart-container { max-width: 1000px; margin: 20px auto; padding: 20px; background: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .cart-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .cart-table th, .cart-table td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        .cart-table th { background-color: #f2f2f2; }
        .cart-table img { max-width: 60px; height: auto; vertical-align: middle; margin-right: 10px; }
        .cart-summary { text-align: right; margin-top: 20px; }
        .checkout-btn { background-color: #023020; color: white; padding: 12px 25px; border: none; border-radius: 5px; cursor: pointer; font-size: 1.1em; text-decoration: none; }
        .checkout-btn:hover { background-color: #01251a; }
        .empty-cart { text-align: center; padding: 40px; color: #666; }
        .continue-shopping { display: inline-block; margin-top: 20px; color: #007bff; text-decoration: none; }
        .continue-shopping:hover { text-decoration: underline; }
        
        /* 美化删除按钮样式 */
        .remove-btn {
            background-color: #ff6b6b;
            color: white;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .remove-btn:hover {
            background-color: #ff5252;
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }
        
        .remove-btn i {
            font-size: 16px;
        }
        
        /* 添加列居中样式 */
        .cart-table td:last-child {
            text-align: center;
            vertical-align: middle;
        }
    </style>
    <script>
        function updateTotal() {
            let totalPrice = 0;
            const rows = document.querySelectorAll('.cart-table tbody tr');

            // 计算每个商品的总价
            rows.forEach(row => {
                const price = parseFloat(row.querySelector('.item-price').textContent.replace('RM ', '').replace(/,/g, ''));
                const quantity = parseInt(row.querySelector('.quantity-input').value);
                const total = price * quantity;
                row.querySelector('.item-total').textContent = 'RM ' + total.toLocaleString('en-MY', { minimumFractionDigits: 2 });
                totalPrice += total;
            });

            // 获取运费和销售税
            const shippingCost = totalPrice >= 1000 ? 0 : 25.00;
            const salesTax = totalPrice * 0.06; // 假设销售税为6%
            const finalTotal = totalPrice + shippingCost + salesTax;

            // 更新小计、运费、销售税和总计（含格式化）
            document.querySelector('.total-price').textContent = 'RM ' + totalPrice.toLocaleString('en-MY', { minimumFractionDigits: 2 });
            document.querySelector('.shipping-cost').textContent = shippingCost === 0 ? 'Free' : 'RM ' + shippingCost.toLocaleString('en-MY', { minimumFractionDigits: 2 });
            document.querySelector('.sales-tax').textContent = 'RM ' + salesTax.toLocaleString('en-MY', { minimumFractionDigits: 2 });
            document.querySelector('.final-total').textContent = 'RM ' + finalTotal.toLocaleString('en-MY', { minimumFractionDigits: 2 });
            
            // 存储计算值到隐藏字段，以便表单提交
            document.getElementById('hiddenTotalPrice').value = totalPrice.toFixed(2);
            document.getElementById('hiddenShippingCost').value = shippingCost.toFixed(2);
            document.getElementById('hiddenSalesTax').value = salesTax.toFixed(2);
            document.getElementById('hiddenFinalTotal').value = finalTotal.toFixed(2);
        }
        
        window.onload = function() {
            const quantityInputs = document.querySelectorAll('.quantity-input');
            quantityInputs.forEach(input => {
                input.addEventListener('input', updateTotal);
            });
            updateTotal(); // 初始化计算
        };
        
        function removeItem(productId) {
            fetch('DeleteCartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'productId=' + productId
            })
            .then(response => response.text())
            .then(data => {
                // Refresh the page to update cart totals
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to remove item from cart');
            });
        }
    </script>
</head>
<body>
    <%
        // Get customer ID from session
        String customerId = (String) session.getAttribute("customerId");
        if (customerId == null) {
            response.sendRedirect("Login_cust.jsp");
            return;
        }
    %>
    <header>
        <div class="header-content">
            <a href="Product_Customer.jsp">
              <img src="img/Logo/logo2.png" width="280" height="190" alt="Logo"/>
            </a>
        </div>
    </header>

    <main class="cart-container">
        <h2>Your Shopping Cart</h2>

        <c:if test="${empty cartItems}">
            <div class="empty-cart">
                <p>Your cart is currently empty.</p>
                <a href="ProductServlet" class="continue-shopping">Continue Shopping</a>
            </div>
        </c:if>

        <c:if test="${not empty cartItems}">
            <form action="UpdateCartServlet" method="post">
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th colspan="2">Product</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cartItems}" var="item">
                            <tr>
                                <td>
                                    <img src="${item.product.imageUrl}" alt="${item.product.productName}">
                                </td>
                                <td>
                                    <span class="item-name">${item.product.productName}</span>
                                </td>
                                <td class="item-price">
                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="RM " />
                                </td>
                                <td>
                                    <input type="number" name="quantity_${item.product.productId}" value="${item.quantity}" min="1" class="quantity-input">
                                    <input type="hidden" name="productId" value="${item.product.productId}">
                                </td>
                                <td class="item-total">
                                    <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="RM " />
                                </td>
                                <td>
                                    <button type="button" class="remove-btn" title="Remove Item" onclick="removeItem('${item.product.productId}')">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </form>

            <div class="cart-summary">
                <h3>Cart Total: <span class="total-price"><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="RM " /></span></h3>
                <p>Shipping Cost: <span class="shipping-cost"><fmt:formatNumber value="${shippingCost}" type="currency" currencySymbol="RM " /></span></p>
                <p>Sales Tax: <span class="sales-tax"><fmt:formatNumber value="${salesTax}" type="currency" currencySymbol="RM " /></span></p>
                <h3>Total Amount: <span class="final-total"><fmt:formatNumber value="${finalTotal}" type="currency" currencySymbol="RM " /></span></h3>
                
                <!-- 添加隐藏字段存储计算值 -->
                <input type="hidden" id="hiddenTotalPrice" name="totalPrice" value="${totalPrice}">
                <input type="hidden" id="hiddenShippingCost" name="shippingCost" value="${shippingCost}">
                <input type="hidden" id="hiddenSalesTax" name="salesTax" value="${salesTax}">
                <input type="hidden" id="hiddenFinalTotal" name="finalTotal" value="${finalTotal}">
                
                <div style="margin-bottom: 20px;"></div>
                
                <a href="ViewCartServlet?action=checkout" class="btn btn-primary" style="background-color: #027148; border: none; padding: 12px 30px; border-radius: 6px; font-weight: 500; font-size: 15px; color: white; text-decoration: none;">Proceed to Checkout</a><br>
                <a href="ProductServlet" class="continue-shopping">Continue Shopping</a>
            </div>
        </c:if>
    </main>

</body>
</html>