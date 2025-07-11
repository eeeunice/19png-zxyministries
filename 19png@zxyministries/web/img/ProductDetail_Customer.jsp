<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Product Details - Beauty And Beast</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        header {
    background: white;
    padding: 1rem;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 100;
}

.header-content {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header-content h1 {
    color: #023020;
    font-size: 2rem;
}

.icons {
    display: flex;
    gap: 1.5rem;
}

.icon-wrapper {
    position: relative;
    cursor: pointer;
    font-size: 1.2rem;
    color: #023020;
}

.icon-wrapper:hover {
    color: red;
}

.count {
    position: absolute;
    top: -8px;
    right: -8px;
    background: #023020;
    color: white;
    border-radius: 50%;
    padding: 2px 6px;
    font-size: 12px;
}

/* Navigation Styles */
nav {
    background: white;
    padding: 1rem;
    margin-top: 1px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    position: sticky;
    top: 60px;
    z-index: 99;
}

.nav-content {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    gap: 2rem;
    justify-content: center;
    flex-wrap: wrap;
}

.nav-item {
    text-decoration: none;
    color: #333;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    transition: all 0.3s ease;
}

.nav-item:hover {
    background: #f0f0f0;
    color: #023020;
}

.nav-item.active {
    background: #023020;
    color: white;
}

/* Subcategory Navigation */
.subcategory-nav {
    max-width: 1200px;
    margin: 1rem auto;
    padding: 1rem;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    justify-content: center;
}

.subcategory-item {
    text-decoration: none;
    color: #666;
    padding: 0.5rem 1rem;
    border-radius: 20px;
    background: #f5f5f5;
    transition: all 0.3s ease;
    font-size: 0.9rem;
}

.subcategory-item:hover {
    background: #e0e0e0;
    color: #023020;
}

.subcategory-item.active {
    background: #023020;
    color: white;
}

        
        .product-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
        }

        .product-image img {
            width: 80%;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-left:120px;
        }

        .product-details {
            padding: 20px;
        }

        .product-name {
            font-size: 24px;
            margin-bottom: 10px;
        }

        .product-description {
            color: #666;
            margin: 20px 0;
            line-height: 1.6;
        }

        .product-price {
            font-size: 24px;
            color: #e60012;
            margin: 20px 0;
        }

        .quantity-selector {
            display: flex;
            align-items: center;
            margin: 20px 0;
            gap: 10px;
        }

        .quantity-selector button {
            padding: 5px 15px;
            font-size: 18px;
            border: 1px solid #ddd;
            background: #fff;
            cursor: pointer;
        }

        .quantity-selector input {
            width: 60px;
            text-align: center;
            padding: 5px;
            font-size: 16px;
        }

        .promo-code {
            margin: 20px 0;
        }

        .promo-code input {
            padding: 10px;
            width: 200px;
            margin-right: 10px;
        }

        .promo-code button {
            padding: 10px 20px;
            background: #333;
            color: white;
            border: none;
            cursor: pointer;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .add-to-cart, .add-to-wishlist {
            padding: 15px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .add-to-cart {
            background: #008000;
            color: white;
            flex: 2;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            background: #4CAF50;
            color: white;
            border-radius: 5px;
            display: none;
            z-index: 1000;
        }
    </style>
     <header>
        <div class="header-content">
            <a href="homepage.jsp">
                <img src="img/Logo/logo4.png" width="100" height="100" alt="Logo"/>
            </a>
            <div class="icons">
                <div class="icon-wrapper">
                    <a href="UserProfile_Customer.jsp" style="text-decoration: none; color: inherit;">
                        <i class="fas fa-user"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <nav>
        <div class="nav-content">
            <a href="ProductServlet" class="nav-item ${empty param.category ? 'active' : ''}">All Products</a>
            <a href="ProductServlet?category=CT001" class="nav-item ${param.category eq 'CT001' ? 'active' : ''}">Cleansers</a>
            <a href="ProductServlet?category=CT002" class="nav-item ${param.category eq 'CT002' ? 'active' : ''}">Exfoliators & Masks</a>
            <a href="ProductServlet?category=CT003" class="nav-item ${param.category eq 'CT003' ? 'active' : ''}">Serums & Treatments</a>
            <a href="ProductServlet?category=CT004" class="nav-item ${param.category eq 'CT004' ? 'active' : ''}">Special Care</a>
            <a href="ProductServlet?category=CT005" class="nav-item ${param.category eq 'CT005' ? 'active' : ''}">Sunscreens</a>
            <a href="ProductServlet?category=CT006" class="nav-item ${param.category eq 'CT006' ? 'active' : ''}">Toner & Mists</a>
        </div>
    </nav>

    <c:if test="${not empty param.category}">
        <div class="subcategory-nav">
            <c:forEach items="${subcategories}" var="subcategory">
                <a href="ProductServlet?category=${param.category}&subcategory=${subcategory.subcategoryId}" 
                   class="subcategory-item ${param.subcategory eq subcategory.subcategoryId ? 'active' : ''}">
                    ${subcategory.subcategoryName}
                </a>
            </c:forEach>
        </div>
    </c:if>
</head>
<body>
    <div id="notification" class="notification"></div>

    <div class="product-container">
        <div class="product-image">
            <img src="${product.imageUrl}" alt="${product.productName}">
        </div>
        
        <div class="product-details">
            <h1 class="product-name">${product.productName}</h1>
            <p class="product-description">${product.description}</p>
            <div class="product-price">RM ${String.format("%.2f", product.price)}</div>

            <%-- Form for adding to cart --%>
            <form action="AddToCartServlet" method="post">
                <input type="hidden" name="productId" value="${product.productId}">

                <div class="quantity-selector">
                    <label for="quantity">Quantity:</label>
                    <button type="button" onclick="changeQuantity(-1)">-</button>
                    <input type="number" id="quantity" name="quantity" value="1" min="1" readonly> <%-- Use name="quantity" --%>
                    <button type="button" onclick="changeQuantity(1)">+</button>
                </div>

                <%-- Add promo code section if needed --%>

                <div class="product-actions">
                            <div class="cart-form" style="display: inline;">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="button" class="add-to-cart" onclick="addToCart('${product.productId}', '${product.productName}')">
                                    <i class="fas fa-shopping-cart"></i> Add to Cart
                                </button>
                            </div>
                        </div>
            </form>

            <%-- Other details like specifications, reviews etc. --%>
        </div>
    </div>

    <script>
        function changeQuantity(amount) {
            const quantityInput = document.getElementById('quantity');
            let currentQuantity = parseInt(quantityInput.value);
            currentQuantity += amount;
            if (currentQuantity < 1) {
                currentQuantity = 1; // Minimum quantity is 1
            }
            quantityInput.value = currentQuantity;
        }

        function incrementQuantity() {
            const input = document.getElementById('quantity');
            const maxQty = ${product.stockQty};
            if (input.value < maxQty) {
                input.value = parseInt(input.value) + 1;
            }
        }

        function decrementQuantity() {
            const input = document.getElementById('quantity');
            if (input.value > 1) {
                input.value = parseInt(input.value) - 1;
            }
        }

        function applyPromoCode() {
            const promoCode = document.getElementById('promoCode').value;
            // Add your promo code logic here
            showNotification('Promo code applied successfully!');
        }

        function addToCart(productId, productName, price) {
            const quantity = parseInt(document.getElementById('quantity').value);
            let cart = JSON.parse(localStorage.getItem('cart') || '[]');
            let existingItem = cart.find(item => item.productId === productId);
            
            if (existingItem) {
                existingItem.quantity += quantity;
            } else {
                cart.push({
                    productId: productId,
                    productName: productName,
                    price: price,
                    quantity: quantity
                });
            }
            
            localStorage.setItem('cart', JSON.stringify(cart));
            showNotification(`${quantity} ${productName} added to cart!`);
        }

        function toggleWishlist(productId, productName) {
            let wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
            let index = wishlist.indexOf(productId);
            
            if (index === -1) {
                wishlist.push(productId);
                showNotification(`${productName} added to wishlist!`);
            } else {
                wishlist.splice(index, 1);
                showNotification(`${productName} removed from wishlist!`);
            }
            
            localStorage.setItem('wishlist', JSON.stringify(wishlist));
        }

        function showNotification(message) {
            const notification = document.getElementById('notification');
            notification.textContent = message;
            notification.style.display = 'block';
            
            setTimeout(() => {
                notification.style.display = 'none';
            }, 3000);
        }
        
           

        function addToCart(productId, productName, price) {
            const quantity = parseInt(document.getElementById('quantity').value);
            let cart = JSON.parse(localStorage.getItem('cart') || '[]');
            let existingItem = cart.find(item => item.productId === productId);
            
            if (existingItem) {
                existingItem.quantity += quantity;
            } else {
                cart.push({
                    productId: productId,
                    productName: productName,
                    price: price,
                    quantity: quantity
                });
            }
            
            localStorage.setItem('cart', JSON.stringify(cart));
            updateCartCount(); // Add this line
            showNotification(`${quantity} ${productName} added to cart!`);
        }

        function toggleWishlist(productId, productName) {
            let wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
            let index = wishlist.indexOf(productId);
            
            if (index === -1) {
                wishlist.push(productId);
                showNotification(`${productName} added to wishlist!`);
            } else {
                wishlist.splice(index, 1);
                showNotification(`${productName} removed from wishlist!`);
            }
            
            localStorage.setItem('wishlist', JSON.stringify(wishlist));
            updateWishlistCount(); // Add this line
        }

        // Add these new functions
        function updateCartCount() {
            const cart = JSON.parse(localStorage.getItem('cart') || '[]');
            const totalItems = cart.reduce((total, item) => total + item.quantity, 0);
            document.getElementById('cartCount').textContent = totalItems;
        }

        function updateWishlistCount() {
            const wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
            document.getElementById('wishlistCount').textContent = wishlist.length;
        }

        // Initialize counts when page loads
        document.addEventListener('DOMContentLoaded', () => {
            updateCartCount();
            updateWishlistCount();
        });

        
    </script>
</body>
</html>