<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="./css/Product_Customer.css">
    <!-- Auto-redirect if products are not loaded -->
    <c:if test="${empty products}">
        <c:redirect url="ProductServlet"/>
    </c:if>
</head>
<body>
     <script src="js/header.js"></script>
    <div id="notification" class="notification"></div>

   
    <jsp:include page="header.jsp"/>
    

    <!-- Main Header -->
    <header>
        <div class="header-content" style="margin-top:100px;">
            <a href="homepage.jsp">
                <img src="img/Logo/logo4.png" width="100" height="100" alt="Logo"/>
            </a>
            <div class="search-bar">
                <form action="SearchServlet" method="get">
                    <input type="text" name="query" placeholder="Search Skincare Products & More">
                    <button type="submit" class="search-btn">Search</button>
                </form>
            </div>
            <div class="header-icons">
               
                <div class="icon-wrapper">

                     <a href="ViewCartServlet" style="text-decoration: none; color: inherit;">
                         <i class="fas fa-shopping-cart"></i>
                         <span class="count" id="cartCount">
                             <c:out value="${sessionScope.cart.size() > 0 ? sessionScope.cart.size() : 0}" />
                         </span>
                     </a>

                </div>
                <div class="icon-wrapper">
                    <a href="UserProfile_Customer.jsp" style="text-decoration: none; color: inherit;">
                        <i class="fas fa-user"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Navigation -->
    <nav class="main-nav">
        <ul class="nav-menu">
            <li class="nav-item ${empty param.category ? 'active' : ''}">
                <a href="ProductServlet">All Products</a>
            </li>
            <!-- Dynamic Category Links -->
            <c:forEach items="${categories}" var="category">
                <li class="nav-item ${param.category eq category.categoryId ? 'active' : ''}">
                    <a href="ProductServlet?category=${category.categoryId}">${category.categoryName} <i class="fas fa-chevron-down"></i></a>
                    <ul class="dropdown">
                        <c:forEach items="${subcategories}" var="subcategory">
                            <c:if test="${subcategory.categoryId eq category.categoryId}">
                                <li>
                                    <a href="ProductServlet?category=${category.categoryId}&subcategory=${subcategory.subcategoryId}" 
                                       class="${param.subcategory eq subcategory.subcategoryId ? 'active' : ''}">
                                        ${subcategory.subcategoryName}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </li>
            </c:forEach>
        </ul>
    </nav>

    <main>
        <div class="product-grid">
            <c:forEach items="${products}" var="product">
                <div class="product-card">
                    <div class="product-image">
                        <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${product.productId}">
                            <img src="${product.imageUrl}" alt="${product.productName}">
                        </a>
                    </div>
                    <div class="product-info">
                        <h3>${product.productName}</h3>
                        <p class="price">RM ${String.format("%.2f", product.price)}</p>
                        <head>
                            <style>
                                .notification {
                                    display: none;
                                    position: fixed;
                                    top: 20px;
                                    right: 20px;
                                    background-color: #4CAF50;
                                    color: white;
                                    padding: 15px;
                                    border-radius: 5px;
                                    z-index: 1000;
                                    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                                }
                            </style>
                        </head>
                        
                        <!-- 修改产品卡片中的购物车按钮部分 -->
                        <div class="product-actions">
                            <div class="cart-form" style="display: inline;">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="button" class="add-to-cart" onclick="addToCart('${product.productId}', '${product.productName}')">
                                    <i class="fas fa-shopping-cart"></i> Add to Cart
                                </button>
                            </div>
                        </div>
                        
                        <!-- 在body结束标签前添加JavaScript代码 -->
                        <script>
                            function addToCart(productId, productName) {
                                fetch('AddToCartServlet', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: 'action=add&productId=' + productId + '&quantity=1'
                                })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        // 更新所有购物车计数器
                                        const cartCountElements = document.querySelectorAll('#cartCount');
                                        cartCountElements.forEach(element => {
                                            element.textContent = data.cartSize;
                                        });
                                        // 显示成功提示
                                        showNotification(productName + ' 已添加到购物车');
                                    } else {
                                        showNotification('添加到购物车失败');
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    showNotification('发生错误，请重试');
                                });
                            }

                            function showNotification(message) {
                                const notification = document.getElementById('notification');
                                notification.textContent = message;
                                notification.style.display = 'block';
                                
                                // 3秒后隐藏提示
                                setTimeout(() => {
                                    notification.style.display = 'none';
                                }, 3000);
                            }
                        </script>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <footer class="site-footer">
        <div class="footer-content">

            <p>&copy; 2025 BeautyAndBeast. All Rights Reserved.</p>

             <div class="footer-section about">
                <h3 style="display: flex; align-items: center; gap: 10px;">
                  About
                </h3>
                  <img src="img/Logo/logo3.png" style="height: 3em;" alt="Logo"/>
                  <p> </p>
                <p>We offer premium skincare products that help you achieve healthy, glowing skin. Our carefully selected products are designed for all skin types.</p>
                <div class="contact">
                    <span><i class="fas fa-map-marker-alt"></i>Jalan 123 , Pulau Pinang</span>
                    <span><i class="fas fa-phone"></i> +04 -123 456</span>
                    <span><i class="fas fa-envelope"></i> info @BeautyAndBeast.com</span>
                </div>
                <div class="socials">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
            <div class="footer-section links">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="homepage.jsp">Home</a></li>
                    <li><a href="Product_Customer">Products</a></li>
                    <li><a href="contactus_customer.jsp">Contact</a></li>
                </ul>
            </div>
            <div class="footer-section newsletter">
                <h3>Subscribe to Our Newsletter</h3>
                <p>Stay updated with our latest products and offers.</p>
                <form action="#" method="post">
                    <input type="email" name="email" placeholder="Enter your email" required>
                    <button type="submit" class="btn-subscribe">Subscribe</button>
                </form>
                <div class="payment-methods">
                    <h4>Payment Methods</h4>
                    <div class="payment-icons">
                        <i class="fab fa-cc-visa"></i>
                        <i class="fab fa-cc-mastercard"></i>
                        <i class="fab fa-cc-paypal"></i>
                        <i class="fab fa-cc-apple-pay"></i>
                    </div>
                </div>
            </div>

        </div>
        <div class="footer-bottom">
            <p>Follow us on social media!</p>
        </div>
    </footer>

</body>
</html>