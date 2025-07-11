<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contact Us - Customer</title>
        <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
        <style>
            * {
                box-sizing: border-box;
            }

            html, body {
                margin: 0;
                padding: 0;
                font-family: 'Poppins', sans-serif;
                background: #fafafa;
                height: 100%;
            }

            .wrapper {
                min-height: 100%;
                display: flex;
                flex-direction: column;
            }

            .container {
                flex: 1;
                display: flex;
            }
            .left {
                flex: 1;
                background: url('img/ContactUs/contactUs.jpg') center/cover no-repeat;
            }
            .right {
                flex: 1;
                padding: 40px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                background: #fff;
            }
            .right h1 {
                font-size: 36px;
                margin-bottom: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group input, .form-group textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 16px;
            }
            .btn {
                background: #1a5d42;
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                margin-top: 10px;
                font-size: 16px;
            }
            .btn:hover {
                background-color: #1b8f52;
            }
            .contact-info {
                margin-top: 30px;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="wrapper">
            <div class="container">
                <div class="left"></div>
                <div class="right">
                    <h1>Contact Us</h1>

                    <form method="post" action="SubmitContact">
                        <div class="form-group">
                            <input type="text" name="name" placeholder="Full Name" required>
                        </div>
                        <div class="form-group">
                            <input type="email" name="email" placeholder="E-mail" required>
                        </div>
                        <div class="form-group">
                            <input type="tel" name="phoneNumber" placeholder="Phone Number" pattern="[0-9]{10}" required>
                        </div>
                        <div class="form-group">
                            <textarea rows="5" name="description" placeholder="Description..." required></textarea>
                        </div>                    
                        <% String message = (String) request.getAttribute("message"); %>
                        <% if (message != null) {%>
                        <p><%= message%></p>
                        <% }%>
                        <button type="submit" class="btn">Submit</button>
                    </form>


                    <div class="contact-info">
                        <p><strong>Contact:</strong> hi@skincare.com</p>
                        <p><strong>Based in:</strong> Malaysia, Penang</p>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="footer.jsp" %>

    </body>
</html>
