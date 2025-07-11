<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>5 Essential Skincare Tips</title>
    <link rel="stylesheet" href="./css/BlogDetails1_Customer.css"> <!-- Link to your CSS -->
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <script>
        function goToBlog() {
            window.location.href = "Blog_Customer.jsp"; // Redirect to Blog_Customer.jsp
        }
    </script>
</head>
<body>
    <!-- Header -->
    <header>
        <h1>5 Essential Skincare Tips for Healthy, Glowing Skin</h1>
    </header>

    <!-- Main Content -->
    <main>
        <section class="blog-content">
            <p>Your skin is your body’s largest organ — and taking care of it isn’t just about beauty, but also about health. With so many products and routines out there, skincare can feel overwhelming. Whether you’re just starting out or looking to improve your regimen, here are 5 essential skincare tips that work for everyone.</p>

            <img src="img/Blog/Blog Image/skintype.jpg" width="400" height="350" alt="alt" style="display:block; margin:auto;" />
            <h2>1. Know Your Skin Type</h2>
            <p>Before you pick up that fancy serum or cream, take a moment to understand your skin type. Is it oily, dry, combination, or sensitive? Knowing your skin's unique needs helps you choose the right products and avoid irritation or breakouts. For example, oily skin benefits from lightweight, non-comedogenic products, while dry skin thrives with hydrating creams and oils.</p>
            <br>
            
            <img src="img/Blog/Blog Image/hydrated.jpg" width="400" height="350" alt="alt" style="display:block; margin:auto;" />
            <h2>2. Stay Hydrated</h2>
            <p>Drinking enough water helps maintain your skin's elasticity and overall health. Aim for at least eight glasses of water a day to keep your skin looking fresh and plump.</p>
            <br>
            
            <img src="img/Blog/Blog Image/sunscreen2.jpg" width="400" height="350" alt="alt" style="display:block; margin:auto;" />
            <h2>3. Use Sunscreen Daily</h2>
            <p>Protecting your skin from harmful UV rays is crucial. Use a broad-spectrum sunscreen with an SPF of at least 30 every day, even when it’s cloudy.</p>
            <br>

            <img src="img/Blog/Blog Image/hydrated2.jpg" width="400" height="350" alt="alt" style="display:block; margin:auto;" />
            <h2>4. Moisturize Regularly</h2>
            <p>Keep your skin hydrated with a good moisturizer. Look for products with ingredients like hyaluronic acid, glycerin, and ceramides to help lock in moisture.</p>
            <br>

            <img src="img/Blog/Blog Image/exfoliate.jpg" width="400" height="350" alt="alt" style="display:block; margin:auto;" />
            <h2>5. Exfoliate Wisely</h2>
            <p>Exfoliation helps remove dead skin cells and promotes a brighter complexion. However, don’t overdo it; exfoliating 1-2 times a week is sufficient for most skin types.</p>
            <br>
            
            <!-- Back Button -->
            <button class="back-button" onclick="goToBlog()">Back</button>
        </section>
    </main>

    <!-- Footer -->
    <footer>
        <p>&copy; 1999 Beauty & Skincare. All rights reserved.</p>
    </footer>
</body>
</html>