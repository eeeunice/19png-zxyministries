<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Header</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

<body>
    <header id="mainHeader" style="position: fixed; top: 0; width: 100%; background-color: #fff; padding: 1rem 2rem; z-index: 1000; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
            <div style="display: flex; align-items: center; gap: 2rem;">
                <a href="homepage.jsp">
                    <img src="img/Logo/logo4.png" alt="Site Logo" style="height: 50px; width: auto; object-fit: contain; display: block;">
                </a>
                <nav>
                    <a href="Product_Customer.jsp" style="text-decoration: none; margin-right: 2.5rem; color: #444; font-weight: 500; transition: color 0.3s;">Product</a>
                    <a href="orderCustomer.jsp" style="text-decoration: none; margin-right: 2.5rem; color: #444; font-weight: 500; transition: color 0.3s;">Order History</a>
                    <a href="CustomerFeedback.jsp" style="text-decoration: none; margin-right: 2.5rem; color: #444; font-weight: 500; transition: color 0.3s;">Feedback</a>
                    <a href="Blog_Customer.jsp" style="text-decoration: none; margin-right: 2.5rem; color: #444; font-weight: 500; transition: color 0.3s;">Blog</a>
                    <a href="contactus_customer.jsp" style="text-decoration: none; margin-right: 2.5rem; color: #444; font-weight: 500; transition: color 0.3s;">Contact</a>
                </nav>
            </div>
            <div class="icons">
                <div class="icon-wrapper">
                    <a href="UserProfile_Customer.jsp" style="text-decoration: none; color: inherit;">
                        <i class="fas fa-user"></i>
                    </a>
                </div>
            </div>

               
        </header>
        <script src="js/header.js"></script>
    </body>
</html>
