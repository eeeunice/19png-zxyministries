<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Blog Posts and Tips</title>
    <link rel="stylesheet" href="./css/Blog_Customer.css">
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
</head>
<body>
    
     <jsp:include page="header.jsp"/>
    
    <main>
    <section class="content">
        <h2>Blog Posts</h2>
        <div class="blog-grid">
            <article class="blog-card">
                <img src="img/Blog/Blog Image/wonyoung.jpg" width="100%" height="auto" alt="5 Essential Skincare Tips"/>
                <h3>5 Essential Skincare Tips</h3>
                <p>Discover the best skincare practices to keep your skin glowing.</p>
            <a href="BlogDetails1_Customer.jsp">Read More</a>
            </article>
            <article class="blog-card">
                <img src="img/Blog/Blog Image/wonyoung3.jpg" width="100%" height="auto" alt="5 Essential Skincare Tips"/>
                <h3>Natural Ingredients for Beautiful Skin</h3>
                <p>Explore the benefits of using natural ingredients in your beauty routine.</p>
                <a href="BlogDetails2_Customer.jsp">Read More</a>
            </article>
            <article class="blog-card">
                <img src="img/Blog/Blog Image/makeup.jpg" width="100%" height="auto" alt="5 Essential Skincare Tips"/>   
                <h3>Makeup Tips for a Flawless Look</h3>
                <p>Learn how to achieve a perfect makeup look every time.</p>
                <a href="BlogDetails3_Customer.jsp">Read More</a>
            </article>
            <article class="blog-card">
                <img src="img/Blog/Blog Image/hydrators.jpg" width="100%" height="auto" alt="5 Essential Skincare Tips"/>
                <h3>Why Hydrators Are a Game-Changer</h3>
                <p>Unlock the secrets to hydrated, radiant skin.</p>
                <a href="BlogDetails4_Customer.jsp">Read More</a>
            </article>
        </div>
    </section>
    </main>

     <jsp:include page="footer.jsp"/>
</body>
</html>