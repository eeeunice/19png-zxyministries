<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="domain.Products"%>
<%@page import="domain.TopSellingProduct"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>19png@zxyministries</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            color: #333;
            background-color: #fdfcf7;
            line-height: 1.6;
            overflow-x: hidden;
        }
        
        a {
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
        }

        /* Animated Background Gradient */
        .bg-gradient {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: linear-gradient(135deg, rgba(221, 239, 221, 0.5), rgba(232, 246, 237, 0.3), rgba(241, 254, 241, 0.2));
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        /* Top Bar */
        .top-bar {
            background-color: #4a7c59;
            color: white;
            text-align: center;
            padding: 12px 20px;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }
        
        /* Hero Section */
        .hero {
            background-image: linear-gradient(rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.2)), url("img/banner/banner2.jpg");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 20px;
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to right, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.1));
            z-index: 1;
        }
        
        .hero-content {
            max-width: 800px;
            position: relative;
            z-index: 2;
            animation: fadeInUp 1s ease-out;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .hero h1 {
            font-size: 4rem;
            color: #fff;
            margin-bottom: 20px;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            letter-spacing: 1px;
        }
        
        .hero p {
            font-size: 1.2rem;
            margin-bottom: 40px;
            line-height: 1.6;
            color: #fff;
            text-shadow: 0 1px 5px rgba(0, 0, 0, 0.5);
        }
        
        .btn {
            display: inline-block;
            padding: 14px 35px;
            background-color: #4a7c59;
            color: white;
            border-radius: 30px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(74, 124, 89, 0.3);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: all 0.6s ease;
            z-index: -1;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(74, 124, 89, 0.4);
        }
        
        .btn:hover::before {
            left: 100%;
        }
        
        .btn-outline {
            background-color: transparent;
            border: 2px solid #fff;
            color: #fff;
            margin-left: 15px;
            box-shadow: 0 4px 15px rgba(255, 255, 255, 0.15);
        }
        
        .btn-outline:hover {
            background-color: #fff;
            color: #4a7c59;
            box-shadow: 0 8px 20px rgba(255, 255, 255, 0.3);
        }
        
        /* Best Sellers Section */
        .section {
            padding: 100px 5%;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 60px;
            position: relative;
        }
        
        .section-title h2 {
            font-size: 2.5rem;
            color: #4a7c59;
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
            font-weight: 600;
        }
        
        .section-title h2::after {
            content: '';
            position: absolute;
            width: 80px;
            height: 3px;
            background-color: #8db892;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }
        
        .section-title::before {
            content: '';
            position: absolute;
            width: 30px;
            height: 30px;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%238db892"><path d="M12,2L15.09,8.09L22,9.4L17,14.24L18.18,21L12,17.77L5.82,21L7,14.24L2,9.4L8.91,8.09L12,2"/></svg>');
            background-size: contain;
            top: -15px;
            left: 50%;
            transform: translateX(-50%);
            opacity: 0.6;
        }
        
        /* Featured Products */
        .featured-products {
            padding: 100px 2rem;
            background-color: #f5f9f5;
            position: relative;
            overflow: hidden;
        }

        .featured-products::before,
        .featured-products::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(74, 124, 89, 0.1), rgba(141, 184, 146, 0.1));
            z-index: 0;
        }

        .featured-products::before {
            top: -150px;
            left: -150px;
        }

        .featured-products::after {
            bottom: -150px;
            right: -150px;
        }

        .products-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2.5rem;
            max-width: 1200px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .product-card {
            background: #fff;
            overflow: hidden;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 15px 35px rgba(74, 124, 89, 0.2);
        }

        .product-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #4a7c59, #8db892);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }

        .product-card:hover::after {
            transform: scaleX(1);
        }

        .product-card img {
             width: 90%;
    height: 350px;
    object-fit: cover;
    display: block;
    margin: 0 auto; /* <-- This centers it horizontally */
    transition: transform 0.5s ease;
        }

        .product-card:hover img {
            transform: scale(1.05);
        }

        .product-info {
            padding: 1.8rem;
            text-align: center;
            position: relative;
        }

        .product-info h3 {
            font-size: 1.3rem;
            margin-bottom: 0.8rem;
            color: #333;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .product-card:hover .product-info h3 {
            color: #4a7c59;
        }

        .product-intro {
            font-size: 0.95rem;
            color: #666;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .view-more {
            display: inline-block;
            font-weight: 600;
            color: #4a7c59;
            position: relative;
            padding-bottom: 2px;
            transition: all 0.3s ease;
        }

        .view-more::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background-color: #4a7c59;
            transform: scaleX(0);
            transform-origin: right;
            transition: transform 0.3s ease;
        }

        .view-more:hover {
            color: #395e44;
        }

        .view-more:hover::after {
            transform: scaleX(1);
            transform-origin: left;
        }

        .view-more-products {
            margin-top: 3.5rem;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .view-more-btn {
            display: inline-block;
            padding: 1rem 2.5rem;
            color: #fff;
            background-color: #4a7c59;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 30px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(74, 124, 89, 0.3);
        }

        .view-more-btn:hover {
            background-color: #395e44;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(74, 124, 89, 0.4);
        }
        
        /* Natural Ingredients Section */
        .ingredients {
            background-color: #fff;
            position: relative;
            overflow: hidden;
        }
        
        .ingredients::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><circle cx="50" cy="50" r="3" fill="%238db892" opacity="0.3"/></svg>');
            background-size: 100px 100px;
            opacity: 0.2;
            z-index: 0;
        }
        
        .ingredients-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            position: relative;
            z-index: 1;
        }
        
        .ingredients-img {
            height: 450px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        
        .ingredients-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.7s ease;
        }
        
        .ingredients-img:hover img {
            transform: scale(1.05);
        }
        
        .ingredients-text h2 {
            font-size: 2.2rem;
            color: #4a7c59;
            margin-bottom: 25px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .ingredients-text h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background-color: #8db892;
        }
        
        .ingredients-text p {
            margin-bottom: 20px;
            line-height: 1.8;
            color: #555;
            font-size: 1.05rem;
        }
        
        .ingredient-list {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 35px;
        }
        
        .ingredient-item {
            display: flex;
            align-items: center;
            transition: transform 0.3s ease;
        }
        
        .ingredient-item:hover {
            transform: translateX(5px);
        }
        
        .ingredient-icon {
            width: 50px;
            height: 50px;
            background-color: #f0f7f0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #4a7c59;
            font-weight: 600;
            box-shadow: 0 5px 15px rgba(74, 124, 89, 0.15);
            transition: all 0.3s ease;
        }
        
        .ingredient-item:hover .ingredient-icon {
            background-color: #4a7c59;
            color: #fff;
        }
        
        /* Categories Section */
        .categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
        }
        
        .category {
            height: 380px;
            border-radius: 12px;
            overflow: hidden;
            position: relative;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .category img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .category:hover img {
            transform: scale(1.1);
        }
        
        .category-content {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            padding: 25px;
            background: linear-gradient(to top, rgba(0, 0, 0, 0.8) 0%, rgba(0, 0, 0, 0.4) 60%, rgba(0, 0, 0, 0) 100%);
            color: white;
            transform: translateY(0);
            transition: transform 0.4s ease;
        }
        
        .category:hover .category-content {
            transform: translateY(-10px);
        }
        
        .category-content h3 {
            font-size: 1.7rem;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .category-link {
            display: inline-flex;
            align-items: center;
            font-weight: 500;
            font-size: 1.05rem;
            opacity: 0.9;
            transition: all 0.3s ease;
        }
        
        .category-link span {
            margin-left: 8px;
            transition: transform 0.3s ease;
        }
        
        .category-link:hover {
            opacity: 1;
        }
        
        .category-link:hover span {
            transform: translateX(8px);
        }
        
        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 12px;
        }
        
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        ::-webkit-scrollbar-thumb {
            background: #8db892;
            border-radius: 6px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: #4a7c59;
        }
       
        /* Responsive Styles */
        @media (max-width: 1200px) {
            .section {
                padding: 80px 5%;
            }
            
            .hero h1 {
                font-size: 3.5rem;
            }
        }
        
        @media (max-width: 992px) {
            .ingredients-content {
                grid-template-columns: 1fr;
            }
            
            .ingredients-img {
                height: 400px;
                margin-bottom: 30px;
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
            .hero {
                height: 70vh;
            }
            
            .hero h1 {
                font-size: 2.5rem;
            }
            
            .hero p {
                font-size: 1rem;
            }
            
            .section {
                padding: 60px 20px;
            }
            
            .ingredient-list {
                grid-template-columns: 1fr;
            }
            
            .btn {
                padding: 12px 25px;
                font-size: 0.9rem;
            }
            
            .product-card img {
                height: 240px;
            }
        }
        
        @media (max-width: 576px) {
            .hero h1 {
                font-size: 2rem;
            }
            
            .hero {
                height: 60vh;
            }
            
            .btn, .btn-outline {
                padding: 10px 20px;
                font-size: 0.85rem;
                margin: 5px;
            }
            
            .categories {
                gap: 15px;
            }
            
            .category {
                height: 320px;
            }
            
            .ingredient-item {
                font-size: 0.9rem;
            }
            
            .ingredient-icon {
                width: 40px;
                height: 40px;
            }
        }
        
                /* About Store Section */
        .about-store {
            background-color: #fff;
        }
        
        .about-content {
            display: grid;
            grid-template-columns: 0.8fr 1.2fr;
            gap: 50px;
            align-items: center;
        }
        
        .about-image {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        
        .about-image img {
            width: 100%;
            height: 100%;
            display: block;
            object-fit: cover;
        }
        
        .about-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #4a7c59;
            color: white;
            padding: 10px 20px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.9rem;
            box-shadow: 0 5px 15px rgba(74, 124, 89, 0.3);
        }
        
        .about-text h3 {
            font-size: 1.8rem;
            color: #4a7c59;
            margin-bottom: 20px;
        }
        
        .about-text p {
            font-size: 1.05rem;
            line-height: 1.8;
            color: #555;
            margin-bottom: 30px;
        }
        
        .store-features {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin: 40px 0;
        }
        
        .feature-item {
            display: flex;
            align-items: flex-start;
        }
        
        .feature-icon {
            width: 50px;
            height: 50px;
            background-color: #f0f7f0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #4a7c59;
            font-size: 1.2rem;
            flex-shrink: 0;
            box-shadow: 0 5px 15px rgba(74, 124, 89, 0.15);
        }
        
        .feature-info h4 {
            font-size: 1.1rem;
            margin-bottom: 5px;
            color: #333;
        }
        
        .feature-info p {
            font-size: 0.9rem;
            margin-bottom: 0;
            line-height: 1.6;
        }
        .center-image {
    text-align: center; /* Centers inline elements like <img> */
    margin-top: 20px; /* Optional spacing */
}

        
    </style>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Background Gradient -->
    <div class="bg-gradient"></div>
    
    <!-- Top Bar -->
    <div class="top-bar">
        <i class="fas fa-shipping-fast"></i> Free shipping on orders over $50 | 
        <i class="fas fa-tag"></i> Get 15% off your first order with code: <strong>WELCOME15</strong>
    </div>
    
    <jsp:include page="header.jsp"/>
    
    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Pure Nature, Radiant Skin</h1>
            <p><strong>Discover our collection of natural, eco-friendly skincare products made with love and respect for your skin and our planet. Formulated with the finest botanical ingredients.</strong></p>
            <div class="hero-buttons">
                <a href="Product_Customer.jsp" class="btn"><i class="fas fa-leaf fa-sm"></i> Shop Now</a>
                <a href="Blog_Customer.jsp" class="btn btn-outline"><i class="fas fa-info-circle fa-sm"></i> Learn More</a>
            </div>
        </div>
    </section>
    
    <!-- Featured Products Section -->
    <section id="featured-products" class="featured-products">
        <h2 class="section-title">Top Sold Products</h2>
        <div class="products-container">
            <div class="product-card">
                <img src="img/TonersMists/BrighteningToner/Bolden.jpg" alt="Hydrating Facial Cleanser">
                <div class="product-info">
                    <h3>Hydrating Facial Cleanser</h3>
                    <p class="product-intro">Gently cleanse and refresh your skin with our non-stripping formula, packed
                        with nourishing botanicals for a healthy glow.</p>
                    <a href="ProductDetailServlet?id=P029" class="view-more">View More <i class="fas fa-arrow-right fa-sm"></i></a>
                </div>
            </div>

            <div class="product-card">
                <img src="img/Cleansers/ExfoliatingCleanser/Cetaphil.jpg" alt="Vitamin C Brightening Serum">
                <div class="product-info">
                    <h3>Vitamin C Brightening Serum</h3>
                    <p class="product-intro">Boost your radiance and even out skin tone with our potent Vitamin C serum,
                        enriched with antioxidants and natural extracts.</p>
                    <a href="ProductDetailServlet?id=P011" class="view-more">View More <i class="fas fa-arrow-right fa-sm"></i></a>
                </div>
            </div>

            <div class="product-card">
                <img src="img/TonersMists/BrighteningToner/Tirtir.jpg" alt="Rejuvenating Night Cream">
                <div class="product-info">
                    <h3>Tirtir Brightening Toner</h3>
                    <p class="product-intro">Wake up to smoother, firmer skin with our luxurious night cream that
                        hydrates, repairs, and revitalizes overnight.</p>
                    <a href="ProductDetailServlet?id=P055" class="view-more">View More <i class="fas fa-arrow-right fa-sm"></i></a>
                </div>
            </div>

            <div class="product-card">
                <img src="img/Sunscreens/PhysicalSunscreen/eucerin.jpg" alt="Daily Moisturizer SPF 30">
                <div class="product-info">
                    <h3>Eucerin Sunscreen</h3>
                    <p class="product-intro">Protect and hydrate your skin daily with our lightweight, non-greasy
                        moisturizer infused with broad-spectrum SPF 30.</p>
                    <a href="ProductDetailServlet?id=P050" class="view-more">View More <i class="fas fa-arrow-right fa-sm"></i></a>
                </div>
            </div>

            <div class="product-card">
                <img src="img/SerumsTreatments/NiacinamideSerum/cosrx.jpg" alt="Gentle Exfoliating Scrub">
                <div class="product-info">
                    <h3>Cosrx Niacinamide Serum</h3>
                    <p class="product-intro">Buff away dead skin cells to reveal a brighter, smoother complexion with
                        our gentle, natural exfoliating scrub.</p>
                    <a href="ProductDetailServlet?id=P037" class="view-more">View More <i class="fas fa-arrow-right fa-sm"></i></a>
                </div>
            </div>

            <div class="product-card">
                <img src="img/ExfoliatorsMasks/ClayMask/innisfree.jpg" alt="Hydrating Sheet Mask">
                <div class="product-info">
                    <h3>Innisfree Clay Mask</h3>
                    <p class="product-intro">Instantly refresh and plump your skin with our deeply hydrating sheet mask
                        infused with hyaluronic acid and botanicals.</p>
                    <a href="ProductDetailServlet?id=P018" class="view-more">View More <i class="fas fa-arrow-right fa-sm"></i></a>
                </div>
            </div>
        </div>

        <div class="view-more-products">
            <a href="ProductServlet" class="view-more-btn">View More Products <i class="fas fa-arrow-right fa-sm"></i></a>
        </div>
    </section>
    
<div class="center-image">
    <img src="img/banner/promotion.png" width="1000" height="500" alt="promotion" />
</div>

    
    <!-- Natural Ingredients Section -->
    <section class="section ingredients">
        <div class="ingredients-content">
            <div class="ingredients-img">
                <img src="img/banner/banner2.jpg" alt="Natural Ingredients" />
            </div>
        
            <div class="ingredients-text">
                <h2>Nature's Finest Ingredients</h2>
                <p>We believe in the power of nature. Our formulas are crafted with carefully selected botanical ingredients that work in harmony with your skin to reveal its natural beauty.</p>
                <p>All of our products are free from harsh chemicals, synthetic fragrances, and artificial colors. We're committed to creating skincare that's good for you and the environment.</p>
                
                <div class="ingredient-list">
                    <div class="ingredient-item">
                        <div class="ingredient-icon"><i class="fas fa-leaf"></i></div>
                        <span>Green Tea Extract</span>
                    </div>
                    <div class="ingredient-item">
                        <div class="ingredient-icon"><i class="fas fa-seedling"></i></div>
                        <span>Aloe Vera</span>
                    </div>
                    <div class="ingredient-item">
                        <div class="ingredient-icon"><i class="fas fa-tint"></i></div>
                        <span>Hyaluronic Acid</span>
                    </div>
                    <div class="ingredient-item">
                        <div class="ingredient-icon"><i class="fas fa-spa"></i></div>
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
                <img src="img/Cleansers/cleaningOil/Anua.jpg" alt="Cleansers">
                <div class="category-content">
                    <h3>Cleansers</h3>
                    <a href="ProductServlet?category=CT001" class="category-link">Explore <span><i class="fas fa-arrow-right"></i></span></a>
                </div>
            </div>
            
            <div class="category">
                <img src="img/Sunscreens/ChemicalSunscreen/biore.jpg" alt="Sunscreens">
                <div class="category-content">
                    <h3>Sunscreens</h3>
                    <a href="ProductServlet?category=CT005" class="category-link">Explore <span><i class="fas fa-arrow-right"></i></span></a>
                </div>
            </div>
            
            <div class="category">
                <img src="img/SpecialCare/NeckCream/Roc.jpg" alt="Special Care">
                <div class="category-content">
                    <h3>Special Care</h3>
                    <a href="ProductServlet?category=CT004" class="category-link">Explore <span><i class="fas fa-arrow-right"></i></span></a>
                </div>
            </div>
        </div>
             <!-- About Our Store Section -->
    <section class="section about-store">
        <div class="section-title">
            <h2>About Nature Glow</h2>
        </div>
        
        <div class="about-content">
            <div class="about-image">
                <img src="img/banner/banner2.jpg" alt="Our Store">
                <div class="about-badge">
                    <span>Since 2015</span>
                </div>
            </div>
            
            <div class="about-text">
                <h3>Your Destination for Natural Skincare</h3>
                <p>Nature Glow was founded with a simple mission: to create effective, eco-friendly skincare products that harness the power of nature without compromising on quality or results.</p>
                
                <div class="store-features">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-leaf"></i>
                        </div>
                        <div class="feature-info">
                            <h4>100% Natural</h4>
                            <p>All our products contain natural ingredients with no harmful chemicals.</p>
                        </div>
                    </div>
                    
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-globe-americas"></i>
                        </div>
                        <div class="feature-info">
                            <h4>Eco-Friendly</h4>
                            <p>Sustainable packaging and cruelty-free manufacturing processes.</p>
                        </div>
                    </div>
                    
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-certificate"></i>
                        </div>
                        <div class="feature-info">
                            <h4>Certified Quality</h4>
                            <p>Our products are dermatologist-tested and approved.</p>
                        </div>
                    </div>
                    
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-truck"></i>
                        </div>
                        <div class="feature-info">
                            <h4>Fast Delivery</h4>
                            <p>Get your favorite products delivered within 2-3 business days.</p>
                        </div>
                    </div>
                </div>
                
     
            </div>
        </div>
    </section>
             <!-- Promotional Discount Section -->
<section class="section promotion">
    <div class="promotion-container">
        <div class="promotion-content">
            <div class="promotion-text">
                <h2>Special Offer</h2>
                <h3>Get 25% OFF on all serums</h3>
                <p>Revitalize your skincare routine with our premium selection of natural serums. 
                   For a limited time only, enjoy 15% off on all serum products.</p>
                <div class="promo-code-container">
                    <div class="promo-code">
                        <span id="discount-code">WELCOME15</span>
                        <button id="copy-btn" onclick="copyCode()">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div id="copy-message">Code copied!</div>
                </div>
                <p class="promo-instructions">Apply this code at checkout to redeem your discount</p>
                <div class="countdown-container">
                    <p>Offer ends in:</p>
                    <div class="countdown" id="countdown">
                        <div class="countdown-item">
                            <span id="days">00</span>
                            <span class="countdown-label">Days</span>
                        </div>
                        <div class="countdown-item">
                            <span id="hours">00</span>
                            <span class="countdown-label">Hours</span>
                        </div>
                        <div class="countdown-item">
                            <span id="minutes">00</span>
                            <span class="countdown-label">Minutes</span>
                        </div>
                        <div class="countdown-item">
                            <span id="seconds">00</span>
                            <span class="countdown-label">Seconds</span>
                        </div>
                    </div>
                </div>
                <a href="ProductServlet?category=CT003" class="btn">Shop Serums Now</a>
            </div>
            <div class="promotion-image">
                <img src="img/SerumsTreatments/NiacinamideSerum/cosrx.jpg" alt="Serum Promotion">
                <div class="discount-badge">
                    <span>25% OFF</span>
                </div>
            </div>
        </div>
    </div>
</section>

<style>
/* Promotional Section Styles */
.promotion {
    padding: 80px 5%;
    background-color: #f5f9f5;
    position: relative;
    overflow: hidden;
}

.promotion::before,
.promotion::after {
    content: '';
    position: absolute;
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background: linear-gradient(135deg, rgba(74, 124, 89, 0.1), rgba(141, 184, 146, 0.1));
    z-index: 0;
}

.promotion::before {
    top: -100px;
    right: -100px;
}

.promotion::after {
    bottom: -100px;
    left: -100px;
}

.promotion-container {
    max-width: 1200px;
    margin: 0 auto;
    position: relative;
    z-index: 1;
}

.promotion-content {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 50px;
    align-items: center;
    background-color: #fff;
    border-radius: 15px;
    box-shadow: 0 15px 35px rgba(74, 124, 89, 0.15);
    overflow: hidden;
}

.promotion-text {
    padding: 40px;
}

.promotion-text h2 {
    color: #4a7c59;
    font-size: 1.8rem;
    margin-bottom: 10px;
    font-weight: 600;
}

.promotion-text h3 {
    font-size: 2.2rem;
    margin-bottom: 20px;
    color: #333;
}

.promotion-text p {
    color: #555;
    line-height: 1.7;
    margin-bottom: 25px;
    font-size: 1.05rem;
}

.promo-code-container {
    position: relative;
    margin: 30px 0;
}

.promo-code {
    display: flex;
    align-items: center;
    background-color: #f0f7f0;
    border: 2px dashed #4a7c59;
    border-radius: 8px;
    padding: 15px 20px;
    max-width: 300px;
}

#discount-code {
    font-size: 1.5rem;
    font-weight: 700;
    letter-spacing: 2px;
    color: #4a7c59;
    margin-right: 15px;
    flex-grow: 1;
}

#copy-btn {
    background-color: #4a7c59;
    color: white;
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
}

#copy-btn:hover {
    background-color: #395e44;
    transform: scale(1.1);
}

#copy-message {
    position: absolute;
    bottom: -25px;
    left: 0;
    color: #4a7c59;
    font-size: 0.9rem;
    font-weight: 500;
    opacity: 0;
    transition: opacity 0.3s ease;
}

.promo-instructions {
    font-size: 0.95rem !important;
    color: #777 !important;
    margin-top: 30px !important;
    font-style: italic;
}

.countdown-container {
    margin: 30px 0;
}

.countdown-container p {
    font-size: 1rem;
    margin-bottom: 10px;
    font-weight: 500;
}

.countdown {
    display: flex;
    gap: 15px;
}

.countdown-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #4a7c59;
    color: white;
    border-radius: 8px;
    padding: 10px;
    min-width: 70px;
    box-shadow: 0 5px 15px rgba(74, 124, 89, 0.2);
}

.countdown-item span:first-child {
    font-size: 1.8rem;
    font-weight: 700;
}

.countdown-label {
    font-size: 0.8rem;
    opacity: 0.8;
}

.promotion-image {
    height: 100%;
    position: relative;
    overflow: hidden;
}

.promotion-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.discount-badge {
    position: absolute;
    top: 20px;
    right: 20px;
    background-color: #4a7c59;
    color: white;
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.3rem;
    font-weight: 700;
    box-shadow: 0 5px 15px rgba(74, 124, 89, 0.3);
    transform: rotate(15deg);
}

/* Responsive Styles */
@media (max-width: 992px) {
    .promotion-content {
        grid-template-columns: 1fr;
    }
    
    .promotion-image {
        height: 400px;
    }
    
    .promotion-text {
        padding: 30px;
    }
}

@media (max-width: 768px) {
    .countdown {
        gap: 10px;
    }
    
    .countdown-item {
        min-width: 60px;
        padding: 8px;
    }
    
    .countdown-item span:first-child {
        font-size: 1.5rem;
    }
    
    .promotion-text h3 {
        font-size: 1.8rem;
    }
    
    #discount-code {
        font-size: 1.3rem;
    }
}

@media (max-width: 576px) {
    .promotion {
        padding: 60px 20px;
    }
    
    .promotion-text {
        padding: 25px;
    }
    
    .countdown {
        flex-wrap: wrap;
        justify-content: center;
    }
    
    .countdown-item {
        margin-bottom: 10px;
    }
    
    .promo-code {
        max-width: 100%;
    }
}
</style>

<script>
// Function to copy the discount code
function copyCode() {
    const discountCode = document.getElementById('discount-code').innerText;
    navigator.clipboard.writeText(discountCode).then(function() {
        // Show copy success message
        const copyMessage = document.getElementById('copy-message');
        copyMessage.style.opacity = '1';
        
        // Hide the message after 2 seconds
        setTimeout(function() {
            copyMessage.style.opacity = '0';
        }, 2000);
    });
}

// Countdown Timer
document.addEventListener('DOMContentLoaded', function() {
    // Set the date we're counting down to (10 days from now)
    const countdownDate = new Date();
    countdownDate.setDate(countdownDate.getDate() + 10);
    
    // Update the countdown every 1 second
    const countdownTimer = setInterval(function() {
        // Get current date and time
        const now = new Date().getTime();
        
        // Find the distance between now and the countdown date
        const distance = countdownDate - now;
        
        // Time calculations for days, hours, minutes and seconds
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);
        
        // Display the result with leading zeros
        document.getElementById("days").innerText = days < 10 ? "0" + days : days;
        document.getElementById("hours").innerText = hours < 10 ? "0" + hours : hours;
        document.getElementById("minutes").innerText = minutes < 10 ? "0" + minutes : minutes;
        document.getElementById("seconds").innerText = seconds < 10 ? "0" + seconds : seconds;
        
        // If the countdown is finished, display expired message
        if (distance < 0) {
            clearInterval(countdownTimer);
            document.getElementById("countdown").innerHTML = "<p class='expired'>This offer has expired</p>";
        }
    }, 1000);
});
</script>

<jsp:include page="footer.jsp"/>
    
             
    
  