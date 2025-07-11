<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Wishlist - SkinBeauty</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Copy your existing header and nav styles */
        
        .wishlist-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }

        .wishlist-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
            margin-top: 20px; /* Added margin-top to grid */
        }

        .wishlist-item {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
            padding: 15px;
        }

        .wishlist-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .wishlist-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 4px;
            margin-bottom: 15px; /* Changed from margin-top to margin-bottom */
        }

        .wishlist-info {
            padding: 0; /* Adjusted padding since container now has padding */
        }

        .wishlist-name {
            font-size: 1.2em;
            margin-bottom: 10px;
            color: #023020;
            line-height: 1.4;
        }

        .wishlist-price {
            color: #e60012;
            font-size: 1.1em;
            font-weight: bold;
            margin: 10px 0;
        }

        .wishlist-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .remove-wishlist, .add-to-cart {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .remove-wishlist {
            background: #f0f0f0;
            color: #333;
        }

        .remove-wishlist:hover {
            background: #e0e0e0;
            color: #e60012;
        }

        .add-to-cart {
            background: #023020;
            color: white;
            flex: 1;
        }

        .add-to-cart:hover {
            background: #034530;
            transform: translateY(-2px);
        }

        .empty-wishlist {
            text-align: center;
            padding: 50px;
            color: #666;
        }
    </style>
</head>
<body>
    <div id="notification" class="notification"></div>
    
    <!-- Copy your existing header and nav sections -->

    <div class="wishlist-container">
        <div class="wishlist-header">
            <h1>My Wishlist</h1>
        </div>
        
        <div class="wishlist-grid" id="wishlistGrid">
            <!-- Wishlist items will be dynamically added here -->
        </div>
    </div>

    <script>
        async function loadWishlistItems() {
            const wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
            const wishlistGrid = document.getElementById('wishlistGrid');
            
            if (wishlist.length === 0) {
                wishlistGrid.innerHTML = '<div class="empty-wishlist"><h2>Your wishlist is empty</h2><p>Add items to your wishlist to see them here</p></div>';
                return;
            }

            // Fetch product details for each wishlist item
            for (const productId of wishlist) {
                try {
                    const response = await fetch(`ProductDetailServlet?id=${productId}&format=json`);
                    const product = await response.json();
                    
                    const itemHtml = `
                        <div class="wishlist-item" data-product-id="${product.productId}">
                            <img src="${product.imageUrl}" alt="${product.productName}" class="wishlist-image">
                            <div class="wishlist-info">
                                <h3 class="wishlist-name">${product.productName}</h3>
                                <p class="wishlist-price">RM ${product.price.toFixed(2)}</p>
                                <div class="wishlist-actions">
                                    <button class="add-to-cart" onclick="addToCart('${product.productId}', '${product.productName}', ${product.price})">
                                        <i class="fas fa-shopping-cart"></i> Add to Cart
                                    </button>
                                    <button class="remove-wishlist" onclick="removeFromWishlist('${product.productId}', '${product.productName}')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                    wishlistGrid.insertAdjacentHTML('beforeend', itemHtml);
                } catch (error) {
                    console.error('Error loading wishlist item:', error);
                }
            }
        }

        function removeFromWishlist(productId, productName) {
            let wishlist = JSON.parse(localStorage.getItem('wishlist') || '[]');
            wishlist = wishlist.filter(id => id !== productId);
            localStorage.setItem('wishlist', JSON.stringify(wishlist));
            
            // Remove the item from the display
            const item = document.querySelector(`[data-product-id="${productId}"]`);
            if (item) {
                item.remove();
            }
            
            updateWishlistCount();
            showNotification(`${productName} removed from wishlist`);
            
            // Check if wishlist is empty after removal
            if (wishlist.length === 0) {
                document.getElementById('wishlistGrid').innerHTML = 
                    '<div class="empty-wishlist"><h2>Your wishlist is empty</h2><p>Add items to your wishlist to see them here</p></div>';
            }
        }

        // Load wishlist items when page loads
        document.addEventListener('DOMContentLoaded', () => {
            loadWishlistItems();
            updateWishlistCount();
            updateCartCount();
        });
    </script>
</body>
</html>