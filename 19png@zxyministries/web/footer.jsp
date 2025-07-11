<style>
    
/* Footer Styles */
.site-footer {
    background-color: #f8f9fa;
    color: #333;
    padding: 50px 0 20px;
    margin-top: 50px;
    border-top: 1px solid #e9ecef;
}

.footer-content {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

.footer-section {
    flex: 1;
    min-width: 300px;
    margin-bottom: 30px;
    padding: 0 15px;
}

.footer-section h3 {
    color: var(--main-color);
    font-size: 1.3rem;
    margin-bottom: 20px;
    position: relative;
    padding-bottom: 10px;
}

.footer-section h3:after {
    content: '';
    position: absolute;
    left: 0;
    bottom: 0;
    width: 50px;
    height: 2px;
    background-color: var(--accent-color);
}

.about p {
    margin-bottom: 20px;
    line-height: 1.6;
}

.contact span {
    display: block;
    margin-bottom: 10px;
}

.contact i {
    margin-right: 10px;
    color: var(--accent-color);
}

.socials {
    margin-top: 20px;
}

.socials a {
    display: inline-block;
    width: 40px;
    height: 40px;
    line-height: 40px;
    text-align: center;
    margin-right: 10px;
    border-radius: 50%;
    color: var(--white);
    background-color: var(--main-color);
    transition: all 0.3s;
}

.socials a:hover {
    background-color: var(--accent-color);
    transform: translateY(-3px);
}

.links ul {
    list-style: none;
    padding: 0;
}

.links li {
    margin-bottom: 10px;
}

.links a {
    color: #555;
    text-decoration: none;
    transition: color 0.3s;
}

.links a:hover {
    color: var(--main-color);
    padding-left: 5px;
}

.newsletter p {
    margin-bottom: 20px;
}

.newsletter form {
    display: flex;
    margin-bottom: 20px;
}

.newsletter input {
    flex-grow: 1;
    padding: 10px 15px;
    border: 1px solid #ddd;
    border-radius: 4px 0 0 4px;
    outline: none;
}

.btn-subscribe {
    background-color: var(--main-color);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 0 4px 4px 0;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn-subscribe:hover {
    background-color: var(--accent-color);
}

.payment-methods {
    margin-top: 20px;
}

.payment-methods h4 {
    font-size: 1rem;
    margin-bottom: 10px;
    color: #555;
}

.payment-icons {
    font-size: 1.8rem;
    color: #555;
}

.payment-icons i {
    margin-right: 10px;
}

.footer-bottom {
    text-align: center;
    padding-top: 20px;
    border-top: 1px solid #e9ecef;
    margin-top: 20px;
}

.footer-bottom p {
    font-size: 0.9rem;
    color: #777;
}

/* Product Detail Page */
.product-detail-container {
    max-width: 1200px;
    margin: 40px auto;
    padding: 0 20px;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 40px;
}

.product-gallery {
    position: relative;
}

.main-image {
    width: 100%;
    height: 400px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.main-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.thumbnail-container {
    display: flex;
    gap: 10px;
    margin-top: 15px;
}

.thumbnail {
    width: 80px;
    height: 80px;
    border-radius: 4px;
    overflow: hidden;
    cursor: pointer;
    border: 2px solid transparent;
    transition: all 0.3s;
}

.thumbnail.active {
    border-color: var(--main-color);
}

.thumbnail img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

    </style>

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