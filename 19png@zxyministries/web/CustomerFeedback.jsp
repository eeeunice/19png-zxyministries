<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="da.FeedbackDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Feedback</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .feedback-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            margin-top:100px;
        }
        .header {
            background-color:#1a5d42;
            color: white;
            padding: 20px;
            border-radius: 10px 10px 0 0;
            margin: -30px -30px 20px -30px;
        }
        .rating-option {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            margin: 5px;
            width: calc(20% - 10px);
            display: inline-block;
        }
        .rating-option:hover {
            border-color: #1a5d42;
            transform: translateY(-2px);
        }
        .rating-option input[type="radio"] {
            display: none;
        }
        .rating-option input[type="radio"]:checked + label {
            color: #1a5d42;
            font-weight: bold;
        }
        .form-control:disabled {
            background-color: #f8f9fa;
            cursor: not-allowed;
        }
        .submit-btn {
            background-color: #1a5d42;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            border: none;
            transition: all 0.3s;
        }
        .submit-btn:hover {
            background-color: #166b28;
            transform: translateY(-2px);
        }
        .footer-text {
            text-align: center;
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 20px;
        }
    </style>
</head>
<body>
     <jsp:include page="header.jsp"/>
    <%
        // Get customer ID from session
        String customerId = (String) session.getAttribute("customerId");
        if (customerId == null) {
            response.sendRedirect("Login_cust.jsp");
            return;
        }
        
        // Get next feedback ID
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        String nextFeedbackId = feedbackDAO.getNextFeedbackId();
    %>
    
    <div class="container">
        <div class="feedback-container">
            <div class="header">
                <h2 class="text-center mb-2"><i class="fas fa-comment-dots"></i> Customer Feedback</h2>
                <p class="text-center mb-0">We value your opinion! Please share your thoughts with us.</p>
            </div>

            <form action="FeedbackServlet" method="post" class="needs-validation" novalidate>
                <div class="form-group">
                    <label for="feedbackId">Feedback ID</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-hashtag"></i></span>
                        </div>
                        <input type="text" class="form-control" id="feedbackId" name="feedbackId" 
                               value="<%= nextFeedbackId %>" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label for="customerId">Customer ID</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                        </div>
                        <input type="text" class="form-control" id="customerId" name="customerId" 
                               value="<%= customerId %>" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label>Your Rating</label>
                    <div class="d-flex flex-wrap justify-content-between">
                        <div class="rating-option">
                            <input type="radio" id="rating1" name="rating" value="1" required>
                            <label for="rating1">
                                <i class="far fa-frown"></i><br>Very Bad
                            </label>
                        </div>
                        <div class="rating-option">
                            <input type="radio" id="rating2" name="rating" value="2">
                            <label for="rating2">
                                <i class="far fa-meh"></i><br>Bad
                            </label>
                        </div>
                        <div class="rating-option">
                            <input type="radio" id="rating3" name="rating" value="3">
                            <label for="rating3">
                                <i class="far fa-meh-blank"></i><br>OK
                            </label>
                        </div>
                        <div class="rating-option">
                            <input type="radio" id="rating4" name="rating" value="4">
                            <label for="rating4">
                                <i class="far fa-smile"></i><br>Good
                            </label>
                        </div>
                        <div class="rating-option">
                            <input type="radio" id="rating5" name="rating" value="5">
                            <label for="rating5">
                                <i class="far fa-grin-stars"></i><br>Excellent
                            </label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="comment">Your Comment</label>
                    <textarea class="form-control" id="comment" name="comment" rows="4" 
                              placeholder="Please share your experience with us..." required></textarea>
                </div>

                <div class="text-center">
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-paper-plane"></i> Submit Feedback
                    </button>
                </div>
            </form>

            <p class="footer-text">
                <i class="fas fa-lock"></i> Your feedback helps us improve our services
            </p>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            });
        })();
    </script>
    <script src="js/footer.js"></script>
</body>
</html>