<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Wishlist</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9; /* Light background color */
        }
        
        header {
            text-align: center;
            padding: 20px;
            background-color: #002E20; /* Dark green */
        }
        
        h1 {
            font-size: 35px; /* Increase header font size */
            color: white; /* Ensure text color is white for contrast */
        }
        
        .wishlist-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            flex: 1; /* This allows the container to grow and push the footer down */
        }

        .wishlist-item {
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 10px;
            padding: 20px;
            text-align: center;
        }

        .wishlist-item img {
            max-width: 100px;
            border-radius: 5px;
        }
        
        .wishlist-item h3 {
            font-size: 1.2em;
            margin: 10px 0;
        }
        
        .wishlist-item p {
            color: #e60012;
            font-weight: bold;
        }
        
        .wishlist-item button {
            background-color: #e60012;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .notification {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #4CAF50; /* Green */
            color: white;
            padding: 15px;
            border-radius: 5px;
            z-index: 1000;
        }
        
        .back-button {
            display: block;
            margin: 20px auto; /* Center the button */
            padding: 10px 20px; /* Add padding */
            color: white; /* Button text color */
            background-color: #4CAF50; /* Button background color */
            border: none; /* Remove border */
            border-radius: 5px; /* Rounded corners for button */
            cursor: pointer; /* Pointer cursor on hover */
        }

        .back-button:hover {
            background-color: #45a049; /* Darker shade on hover */
        }
        
        footer {
            text-align: center;
            padding: 10px 0;
            background: #333;
            color: white;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>
    <header>
    <div class="header-content">
        <a href="homepage.jsp">
            <img src="img/Logo/logo4.png" width="100" height="100" alt="Logo" />
        </a>
    <h1>Your Wishlist</h1>
    </div>
    </header>
    <div class="wishlist-container">
        <c:forEach items="${wishlistProducts}" var="product">
            <div class="wishlist-item">
                <img src="${product.imageUrl}" alt="${product.productName}">
                <h3>${product.productName}</h3>
                <p>RM ${String.format("%.2f", product.price)}</p>
                <form action="CartServlet" method="post">
                    <input type="hidden" name="productId" value="${product.productId}">
                    <button type="submit">Add to Cart</button>
                </form>
            </div>
        </c:forEach>
    </div>
    <button class="back-button" onclick="window.location.href='Product_Customer.jsp'">Back</button>
    <footer>
        <p>&copy; 1999 Beauty & Skincare. All rights reserved.</p>
    </footer>
</body>
</html>