<%@page import="da.ReviewDAO"%>
<%@page import="da.DatabaseLink"%>
<%@page import="domain.Review"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Review</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .review-container { 
            max-width: 650px; 
            margin: 50px auto; 
            padding: 0; 
            background: #fff; 
            border-radius: 15px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            overflow: hidden;
        }
        .header { 
            background: linear-gradient(135deg, #2d8659, #1a5d42);
            color: white; 
            padding: 25px 30px; 
            text-align: center;
        }
        .header h2 {
            font-weight: 600;
            margin: 0;
            font-size: 28px;
        }
        .form-area {
            padding: 30px 40px;
        }
        .form-group label {
            font-weight: 500;
            color: #555;
            margin-bottom: 8px;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #ddd;
            box-shadow: none;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #1a5d42;
            box-shadow: 0 0 0 0.2rem rgba(26, 93, 66, 0.25);
        }
        .submit-btn { 
            background: linear-gradient(135deg, #2d8659, #1a5d42);
            color: white; 
            padding: 12px 30px; 
            border-radius: 30px; 
            border: none;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s;
            display: block;
            width: 100%;
            margin-top: 20px;
            cursor: pointer;
        }
        .submit-btn:hover {
            background: linear-gradient(135deg, #1a5d42, #164a34);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 93, 66, 0.4);
        }
        /* Star Rating */
        .star-rating {
            direction: rtl;
            display: flex;
            justify-content: center;
            padding: 20px 0;
        }
        .star-rating input[type="radio"] {
            display: none;
        }
        .star-rating label {
            color: #ddd;
            font-size: 40px;
            padding: 0 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input[type="radio"]:checked ~ label {
            color: #ffcc00;
        }
        .rating-value {
            text-align: center;
            font-size: 20px;
            font-weight: 600;
            color: #555;
            margin-bottom: 20px;
        }
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        .review-id-container {
            background-color: #f5f5f5;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .review-id-container p {
            margin-bottom: 5px;
            font-weight: 500;
        }
        .review-id-container span {
            font-weight: normal;
            color: #666;
        }
    </style>
</head>
<body>
    <%
        String customerId = (String) session.getAttribute("customerId");
        String orderId = request.getParameter("orderId");
        if (customerId == null) {
            response.sendRedirect("Login_cust.jsp");
            return;
        }
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect("orderCustomer.jsp");
            return;
        }
        // Generate Review ID
        String reviewId = new ReviewDAO(new DatabaseLink().getConnection()).generateReviewId();
    %>
    <div class="container">
        <div class="review-container">
            <div class="header">
                <h2>Customer Review</h2>
            </div>
            <div class="form-area">
                <form action="SubmitReviewServlet" method="post">
                    <div class="review-id-container">
                        <p>Review ID: <span><%= reviewId %></span></p>
                        <p>Order ID: <span><%= orderId %></span></p>
                        <input type="hidden" id="reviewId" name="reviewId" value="<%= reviewId %>">
                        <input type="hidden" id="orderId" name="orderId" value="<%= orderId %>">
                    </div>
                    
                    <div class="form-group">
                        <label>Your Rating</label>
                        <div class="star-rating">
                            <input type="radio" id="star5" name="rating" value="5" required/>
                            <label for="star5" class="fas fa-star"></label>
                            <input type="radio" id="star4" name="rating" value="4" />
                            <label for="star4" class="fas fa-star"></label>
                            <input type="radio" id="star3" name="rating" value="3" />
                            <label for="star3" class="fas fa-star"></label>
                            <input type="radio" id="star2" name="rating" value="2" />
                            <label for="star2" class="fas fa-star"></label>
                            <input type="radio" id="star1" name="rating" value="1" />
                            <label for="star1" class="fas fa-star"></label>
                        </div>
                        <div class="rating-value" id="ratingValue">Select Rating</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="comments">Comments</label>
                        <textarea class="form-control" id="comments" name="comments" rows="4" placeholder="Please share your experience..." required></textarea>
                    </div>
                    
                    <input type="hidden" name="customerId" value="<%= customerId %>">
                    <button type="submit" class="submit-btn">Submit Review</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Update rating value text when stars are clicked
        document.querySelectorAll('.star-rating input').forEach(input => {
            input.addEventListener('click', function() {
                document.getElementById('ratingValue').textContent = this.value + ' Star' + (this.value > 1 ? 's' : '');
            });
        });
    </script>
</body>
</html>