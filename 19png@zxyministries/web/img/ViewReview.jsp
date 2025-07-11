<%@page import="da.ReviewDAO"%>
<%@page import="da.DatabaseLink"%>
<%@page import="domain.Review"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Reviews</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }
        
        .reviews-container {
            max-width: 850px;
            margin: 40px auto;
            padding: 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, #2d8659, #1a5d42);
            padding: 30px 20px;
            border-radius: 15px;
            color: white;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .page-header h2 {
            font-weight: 600;
            margin: 0;
            font-size: 32px;
        }
        
        .review-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            padding: 25px;
            transition: transform 0.3s, box-shadow 0.3s;
            border-left: 5px solid #1a5d42;
            position: relative;
            overflow: hidden;
        }
        
        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .review-id {
            background-color: #f5f9f7;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
            color: #1a5d42;
            border: 1px dashed #b7d4c8;
        }
        
        .review-rating {
            font-size: 24px;
            letter-spacing: 2px;
        }
        
        .review-rating .fas.fa-star {
            color: #ddd;
            transition: color 0.3s;
        }
        
        .review-rating .fas.fa-star.active {
            color: #ffcc00;
            text-shadow: 0 0 5px rgba(255, 204, 0, 0.3);
        }
        
        .review-content {
            padding: 10px 0;
        }
        
        .review-comment {
            margin: 15px 0;
            line-height: 1.7;
            font-size: 16px;
            color: #444;
        }
        
        .review-comment p {
            margin-top: 8px;
        }
        
        .review-comment-label {
            font-weight: 600;
            color: #1a5d42;
            font-size: 17px;
        }
        
        .review-date {
            color: #6c757d;
            font-size: 0.9em;
            margin-top: 15px;
            display: flex;
            align-items: center;
        }
        
        .review-date i {
            margin-right: 5px;
            color: #1a5d42;
        }
        
        .review-reply {
            margin-top: 25px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #1a5d42;
            position: relative;
        }
        
        .review-reply::before {
            content: '';
            position: absolute;
            top: -15px;
            left: 20px;
            border-width: 0 15px 15px;
            border-style: solid;
            border-color: transparent transparent #f8f9fa transparent;
        }
        
        .reply-header {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            font-weight: 600;
            color: #1a5d42;
        }
        
        .reply-header i {
            margin-right: 8px;
            font-size: 18px;
        }
        
        .reply-content {
            color: #555;
            line-height: 1.6;
        }
        
        .reply-footer {
            margin-top: 12px;
            font-size: 13px;
            color: #777;
            display: flex;
            align-items: center;
        }
        
        .reply-footer i {
            margin-right: 5px;
            font-size: 14px;
        }
        
        .no-reviews {
            text-align: center;
            padding: 60px 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            border-top: 5px solid #1a5d42;
        }
        
        .no-reviews i {
            color: #1a5d42;
            opacity: 0.7;
            margin-bottom: 20px;
        }
        
        .no-reviews h4 {
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }
        
        .no-reviews p {
            color: #777;
            font-size: 17px;
        }
        
        .write-review-btn {
            background: linear-gradient(135deg, #2d8659, #1a5d42);
            color: white;
            padding: 12px 30px;
            border-radius: 30px;
            border: none;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s;
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            box-shadow: 0 4px 10px rgba(26, 93, 66, 0.3);
        }
        
        .write-review-btn:hover {
            background: linear-gradient(135deg, #1a5d42, #164a34);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(26, 93, 66, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .write-review-btn i {
            margin-right: 8px;
        }
        
        /* Animated background for the cards */
        .review-card::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100%;
            background: linear-gradient(90deg, rgba(255,255,255,0) 0%, rgba(255,255,255,0.8) 50%, rgba(255,255,255,0) 100%);
            transform: skewX(-20deg) translateX(180px);
            transition: transform 1.2s;
            pointer-events: none;
        }
        
        .review-card:hover::after {
            transform: skewX(-20deg) translateX(-180px);
        }
        
        @media (max-width: 768px) {
            .review-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .review-rating {
                margin-top: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container reviews-container">
        <div class="page-header">
            <h2><i class="fas fa-comments mr-2"></i>Customer Reviews</h2>
        </div>
        
        <%
            String orderId = request.getParameter("orderId");
            if (orderId == null || orderId.trim().isEmpty()) {
                response.sendRedirect("orderCustomer.jsp");
                return;
            }

            DatabaseLink dbLink = new DatabaseLink();
            Connection connection = dbLink.getConnection();
            ReviewDAO reviewDAO = new ReviewDAO(connection);
            List<Review> reviews = reviewDAO.getReviewsByOrderId(orderId);

            if (reviews.isEmpty()) {
        %>
            <div class="no-reviews">
                <i class="fas fa-comment-slash fa-4x mb-3"></i>
                <h4>No Reviews Yet</h4>
                <p>Be the first to share your experience with this order!</p>
                <a href="customerReview.jsp?orderId=<%= orderId %>" class="write-review-btn">
                    <i class="fas fa-pencil-alt"></i> Write a Review
                </a>
            </div>
        <%
            } else {
                for (Review review : reviews) {
        %>
            <div class="review-card">
                <div class="review-header">
                    <div class="review-id">
                        <i class="fas fa-hashtag mr-1"></i> <%= review.getReviewId() %>
                    </div>
                    <div class="review-rating">
                        <% for (int i = 0; i < 5; i++) { %>
                            <i class="fas fa-star <%= i < review.getRating() ? "active" : "" %>"></i>
                        <% } %>
                    </div>
                </div>
                
                <div class="review-content">
                    <div class="review-comment">
                        <span class="review-comment-label">Comments:</span>
                        <p><%= review.getComments() %></p>
                    </div>
                    
                    <div class="review-date">
                        <i class="far fa-calendar-alt"></i>
                        <%= review.getReviewDate() != null ? review.getReviewDate().toString() : "Date not available" %>
                    </div>
                </div>
                
                <% if (review.getReply() != null && !review.getReply().trim().isEmpty()) { %>
                    <div class="review-reply">
                        <div class="reply-header">
                            <i class="fas fa-reply"></i> Staff Response
                        </div>
                        <div class="reply-content">
                            <p><%= review.getReply() %></p>
                        </div>
                        <div class="reply-footer">
                            <i class="fas fa-user"></i> Replied by: <%= review.getReplyBy() %> 
                            <span class="ml-3">
                                <i class="far fa-clock"></i> 
                                <%= review.getReplyAt() != null ? review.getReplyAt().toString() : "Date not available" %>
                            </span>
                        </div>
                    </div>
                <% } %>
            </div>
        <%
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>