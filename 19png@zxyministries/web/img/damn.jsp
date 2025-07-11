<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="domain.Products"%>
<%@page import="domain.TopSellingProduct"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nature Glow | Premium Skincare</title>
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Montserrat', sans-serif;
        }
        
        body {
            color: #4a4a4a;
            background-color: #fafafa;
        }
        
        a {
            text-decoration: none;
            color: inherit;
        }

        
        /* Hero Section */
        .hero {
            background-image: linear-gradient(rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.8)), url("/api/placeholder/1400/600");
            background-size: cover;
            background-position: center;
            height: 600px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 20px;
        }
        
        .hero-content {
            max-width: 800px;
        }
        
        .hero h1 {
            font-size: 3rem;
            color: #3e6e3e;
            margin-bottom: 20px;
            font-weight: 700;
        }
        
        .hero p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background-color: #3e6e3e;
            color: white;
            border-radius: 30px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            background-color: #2a4d2a;
            transform: translateY(-2px);
        }
        
        .btn-outline {
            background-color: transparent;
            border: 2px solid #3e6e3e;
            color: #3e6e3e;
            margin-left: 15px;
        }
        
        .btn-outline:hover {
            background-color: #3e6e3e;
            color: white;
        }
        
        /* Best Sellers Section */
        .section {
            padding: 80px 5%;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .section-title h2 {
            font-size: 2.2rem;
            color: #3e6e3e;
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
        }
        
        .section-title h2::after {
            content: '';
            position: absolute;
            width: 80px;
            height: 3px;
            background-color: #92c192;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }
        
        .products {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }
        
        .product {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }
        
        .product:hover {
            transform: translateY(-10px);
        }
        
        .product-img {
            height: 250px;
            background-color: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-category {
            font-size: 0.8rem;
            color: #92c192;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .product-name {
            font-size: 1.1rem;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .product-price {
            font-weight: 700;
            color: #3e6e3e;
            margin-bottom: 15px;
        }
        
        .product-btn {
            display: block;
            width: 100%;
            padding: 10px;
            text-align: center;
            background-color: #f7f9f7;
            color: #3e6e3e;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .product-btn:hover {
            background-color: #3e6e3e;
            color: white;
        }
        
        /* Ingredients Section */
        .ingredients {
            background-color: #f7f9f7;
        }
        
        .ingredients-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 50px;
            align-items: center;
        }
        
        .ingredients-img {
            height: 400px;
            border-radius: 10px;
            overflow: hidden;
            background-color: #e9f4e9;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .ingredients-text h2 {
            font-size: 2rem;
            color: #3e6e3e;
            margin-bottom: 20px;
        }
        
        .ingredients-text p {
            margin-bottom: 20px;
            line-height: 1.7;
        }
        
        .ingredient-list {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 30px;
        }
        
        .ingredient-item {
            display: flex;
            align-items: center;
        }
        
        .ingredient-icon {
            width: 40px;
            height: 40px;
            background-color: #e9f4e9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #3e6e3e;
            font-weight: bold;
        }
        
        /* Categories Section */
        .categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .category {
            height: 350px;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
            background-color: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            width:60%;
        }
        
        .category-content {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            padding: 20px;
            background: linear-gradient(to top, rgba(0, 0, 0, 0.7), transparent);
            color: white;
        }
        
        .category-content h3 {
            font-size: 1.5rem;
            margin-bottom: 5px;
        }
        
        .category-link {
            display: inline-flex;
            align-items: center;
            font-weight: 500;
        }
        
        .category-link span {
            margin-left: 5px;
            transition: transform 0.3s ease;
        }
        
        .category-link:hover span {
            transform: translateX(5px);
        }
       
        /* Footer */
        footer {
            background-color: #3e6e3e;
            color: white;
            padding: 60px 5% 30px;
        }
        
        .footer-container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
        }
        
        .footer-col h3 {
            font-size: 1.2rem;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .footer-col h3::after {
            content: '';
            position: absolute;
            width: 40px;
            height: 2px;
            background-color: #92c192;
            bottom: 0;
            left: 0;
        }
        
        .footer-col ul {
            list-style: none;
        }
        
        .footer-col ul li {
            margin-bottom: 10px;
        }
        
        .footer-col ul li a:hover {
            color: #92c192;
            padding-left: 5px;
        }
        
        .copyright {
            text-align: center;
            margin-top: 50px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.9rem;
        }
        
        /* Responsive Styles */
        @media (max-width: 992px) {
            .ingredients-content {
                grid-template-columns: 1fr;
            }
            
            .nav-container {
                flex-wrap: wrap;
            }
            
            nav {
                order: 3;
                width: 100%;
                margin-top: 15px;
            }
            
            nav ul {
                justify-content: center;
                flex-wrap: wrap;
            }
            
            nav ul li {
                margin: 5px 10px;
            }
        }
        
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2.2rem;
            }
            
            .section {
                padding: 60px 20px;
            }
            
            .ingredient-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Top Bar -->
    <div class="top-bar">
        Free shipping on orders over $50 | Get 15% off your first order with code: WELCOME15
    </div>
    
    <jsp:include page="header.jsp"/>
    
    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Pure Nature, Radiant Skin</h1>
            <p>Discover our collection of natural, eco-friendly skincare products made with love and respect for your skin and our planet. Formulated with the finest botanical ingredients.</p>
            <div class="hero-buttons">
                <a href="Product_Customer.jsp" class="btn">Shop Now</a>
                <a href="blog_customer_1.jsp" class="btn btn-outline">Learn More</a>
            </div>
        </div>
    </section>
    
    <!-- Best Sellers Section -->
    <section class="section">
        <div class="section-title">
            <h2>Our Bestsellers</h2>
        </div>
        
        <div class="products">
            <div class="product">
                <div class="product-img">
                    <img src="img/" alt="">
                </div>
                <div class="product-info">
                    <div class="product-category"></div>
                    <h3 class="product-name"></h3>
                    <div class="product-price">RM/div>
                    <a href="#" class="product-btn">Add to Cart</a>
                </div>
            </div>
            
            <div class="product">
                <div class="product-img">
                    <img src="img/" alt="">
                </div>
                <div class="product-info">
                    <div class="product-category"></div>
                    <h3 class="product-name"></h3>
                    <div class="product-price">RM</div>
                    <a href="#" class="product-btn">Add to Cart</a>
                </div>
            </div>
            
            <div class="product">
                <div class="product-img">
                    <img src="img/" alt="Intensive Hydrating Cream">
                </div>
                <div class="product-info">
                    <div class="product-category">/div>
                    <h3 class="product-name"></h3>
                    <div class="product-price">RM</div>
                    <a href="#" class="product-btn">Add to Cart</a>
                </div>
            </div>
            
            <div class="product">
                <div class="product-img">
                    <img src="img/" alt="Revitalizing Toner">
                </div>
                <div class="product-info">
                    <div class="product-category">/div>
                    <h3 class="product-name"></h3>
                    <div class="product-price">RM</div>
                    <a href="#" class="product-btn">Add to Cart</a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Natural Ingredients Section -->
    <section class="section ingredients">
        <div class="ingredients-content">
            <div class="ingredients-img">
                <img src="img/banner/banner2.jpg" width="600" height="400" alt="infoImage3" alt="Natural Ingredients" />
            </div>
        

            <div class="ingredients-text">
                <h2>Nature's Finest Ingredients</h2>
                <p>We believe in the power of nature. Our formulas are crafted with carefully selected botanical ingredients that work in harmony with your skin to reveal its natural beauty.</p>
                <p>All of our products are free from harsh chemicals, synthetic fragrances, and artificial colors. We're committed to creating skincare that's good for you and the environment.</p>
                
                <div class="ingredient-list">
                    <div class="ingredient-item">
                        <div class="ingredient-icon">GT</div>
                        <span>Green Tea</span>
                    </div>
                    <div class="ingredient-item">
                        <div class="ingredient-icon">AV</div>
                        <span>Aloe Vera</span>
                    </div>
                    <div class="ingredient-item">
                        <div class="ingredient-icon">HA</div>
                        <span>Hyaluronic Acid</span>
                    </div>
                    <div class="ingredient-item">
                        <div class="ingredient-icon">CV</div>
                        <span>Centella Asiatica</span>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Categories Section -->
    <section class="section">
        <div class="section-title">
            <h2>Shop by Category</h2>
        </div>
        
        <div class="categories">
            <div class="category">
                <img src="img/Cleansers/cleaningOil/Anua.jpg" width="280" height="260" >
                <div class="category-content">
                    <h3>Cleansers</h3>
                    <a href="ProductServlet?category=CT001" class="category-link">Explore <span>â</span></a>
                </div>
            </div>
            
            <div class="category">
                <img src="img/Sunscreens/Chemical Sunscreen/biore.jpg" width="280" height="260" >
                <div class="category-content">
                    <h3>Sunscreens</h3>
                    <a href="ProductServlet?category=CT005" class="category-link">Explore </a>
                </div>
            </div>
            
            
            <div class="category">
                <img src="img/Special Care/Neck Cream/Roc.jpg" width="280" height="260" >
                <div class="category-content">
                    <h3>Special Care</h3>
                    <a href="ProductServlet?category=CT004" class="category-link">Explore</a>
                </div>
            </div>
            
            <div class="category">
                <img src="img/Toners & Mists/Face Mist/Adorn.jpg"width="280" height="260" >
                <div class="category-content">
                    <h3>Toner</h3>
                    <a href="ProductServlet?category=CT006" class="category-link">Explore </a>
                </div>
            </div>
        </div>
    </section>
    
    <jsp:include page="footer.jsp"/>
    
    
</body>
</html>