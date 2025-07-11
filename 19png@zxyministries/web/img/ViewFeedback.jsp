<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="da.FeedbackDAO"%>
<%@page import="domain.Feedback"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Feedback Dashboard</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
      <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        :root {
             --primary: #1a5d42;
             --primary-light: #2d8e66;
            --secondary: #f8f9fa;
            --accent: #ffc107;
            --dark: #343a40;
            --light: #f8f9fa;
            --success: #1a5d42;
             --warning: #ffc107;
             --danger: #8B0000;
            --border-radius: 12px;
             --primary: #1a5d42;
               --info: #17a2b8;

        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            color: var(--primary);
        }
        
        .dashboard-container {
            padding: 30px 15px;
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 25px 20px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stats-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 20px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        
        .stats-icon {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin-right: 15px;
            font-size: 24px;
        }
        
        .stats-primary {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--accent);
        }
        
        .stats-success {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success);
        }
        
        .stats-warning {
            background-color: rgba(243, 156, 18, 0.1);
            color: var(--warning);
        }
        
        .stats-number {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 0;
        }
        
        .stats-label {
            color: #95a5a6;
            font-size: 14px;
            margin-bottom: 0;
        }
        
        .feedback-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .feedback-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        
        .feedback-header {
            padding: 15px 20px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
        }
        
        .feedback-body {
            padding: 20px;
        }
        
        .feedback-footer {
            padding: 12px 20px;
            background-color: #f8f9fa;
            border-top: 1px solid #eee;
            font-size: 0.9em;
        }
        
        .rating-stars {
            color: #f1c40f;
            font-size: 1.2em;
        }
        
        .feedback-date {
            color: #7f8c8d;
            font-size: 0.9em;
        }
        
        .feedback-text {
            font-size: 1.05em;
            line-height: 1.5;
            color: #34495e;
        }
        
        .customer-info {
            font-weight: 600;
            color: var(--primary);
        }
        
        .feedback-id {
            color: #7f8c8d;
            font-size: 0.9em;
        }
        
        .feedback-rating-5 { border-left: 4px solid #2ecc71; }
        .feedback-rating-4 { border-left: 4px solid #27ae60; }
        .feedback-rating-3 { border-left: 4px solid #f39c12; }
        .feedback-rating-2 { border-left: 4px solid #e67e22; }
        .feedback-rating-1 { border-left: 4px solid #e74c3c; }
        
        .no-feedback {
            text-align: center;
            padding: 80px 30px;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        .no-feedback i {
            font-size: 60px;
            color: #bdc3c7;
            margin-bottom: 20px;
        }
        
        .search-container {
            position: relative;
            margin-bottom: 30px;
        }
        
        .search-input {
            border-radius: 50px;
            padding-left: 45px;
            border: 2px solid #dfe6e9;
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
        
        .search-icon {
            position: absolute;
            left: 16px;
            top: 13px;
            color: #b2bec3;
        }
        
        .back-btn {
            padding: 10px 25px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            transform: translateY(-2px);
        }
        
        /* Filters */
        .filter-container {
            margin-bottom: 20px;
        }
        
        .filter-btn {
            background-color: white;
            color: var(--primary);
            border: 1px solid #dfe6e9;
            border-radius: 50px;
            padding: 8px 15px;
            margin-right: 10px;
            font-size: 0.9em;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .filter-btn:hover, .filter-btn.active {
            background-color: #1a5d42;
            color: white;
            border-color:white;
        }
        
        /* Responsive adjustments */
        @media (max-width: 767px) {
            .stats-row {
                flex-direction: column;
            }
            
            .header-content {
                flex-direction: column;
            }
            
            .page-title {
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-tachometer-alt"></i>
                    <h1>Manager Dashboard</h1>
                </div>
                <div class="user-area">
                    <div class="user-area">
                        <a href="ManagerProfile.jsp?id=<%= session.getAttribute("managerId") %>" class="user-profile-link">
                            <div class="user-profile">
                                <div class="user-avatar">M</div>
                                <span><%= session.getAttribute("managerName") != null ? session.getAttribute("managerName") : "Manager" %></span>
                                <i class="fas fa-user-cog profile-icon"></i>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <!-- Navigation Menu -->
            <div class="navigation-menu">
                <div class="navigation-menu">
                <a href="Manager_Dashboard.jsp" class="nav-item active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="Product_Admin.jsp" class="nav-item"><i class="fas fa-box"></i> Products</a>
                <a href="Manager_Customers.jsp" class="nav-item"><i class="fas fa-users"></i> Customers</a>
                <a href="Orders_Manager.jsp" class="nav-item"><i class="fas fa-shopping-cart"></i> Orders</a>
                <a href="Staff_Management.jsp" class="nav-item"><i class="fas fa-user-tie"></i> Staff</a>
                <a href="Reports.jsp" class="nav-item"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="Promotion_Discount_Manager.jsp" class="nav-item"><i class="fas fa-percent"></i> Promotions</a>
                <a href="ViewFeedback.jsp" class="nav-item"><i class="fa-solid fa-comments"></i>Feedback</a>
                <a href="ReviewManagement.jsp" class="nav-item"><i class="fa-solid fa-comments"></i>Reviews</a>
                <a href="contactus_admin.jsp" class="nav-item"><i class="fas fa-comments"></i> Contact Us</a>
                <a href="Logout.jsp" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
<body>
    <%
        // Check if manager is logged in
        String managerId = (String) session.getAttribute("managerId");
        if (managerId == null) {
            response.sendRedirect("Login_mgn.jsp");
            return;
        }
        
        // Get all feedback
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbackList = feedbackDAO.getAllFeedback();
        
        // Count ratings
        int totalFeedback = feedbackList.size();
        int positiveRatings = 0;
        int neutralRatings = 0;
        int negativeRatings = 0;
        
        for (Feedback feedback : feedbackList) {
            int rating = feedback.getRating();
            if (rating >= 4) {
                positiveRatings++;
            } else if (rating == 3) {
                neutralRatings++;
            } else {
                negativeRatings++;
            }
        }
        
        // Date formatter
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy HH:mm");
    %>

   

        <% if (totalFeedback > 0) { %>
            <!-- Stats cards -->
            <div class="row stats-row">
                <div class="col-md-4">
                    <div class="stats-card d-flex align-items-center">
                        <div class="stats-icon stats-primary">
                            <i class="fas fa-comments"></i>
                        </div>
                        <div>
                            <p class="stats-number"><%= totalFeedback %></p>
                            <p class="stats-label">Total Feedback</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card d-flex align-items-center">
                        <div class="stats-icon stats-success">
                            <i class="fas fa-smile"></i>
                        </div>
                        <div>
                            <p class="stats-number"><%= positiveRatings %></p>
                            <p class="stats-label">Positive Ratings</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card d-flex align-items-center">
                        <div class="stats-icon stats-warning">
                            <i class="fas fa-frown"></i>
                        </div>
                        <div>
                            <p class="stats-number"><%= negativeRatings %></p>
                            <p class="stats-label">Negative Ratings</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="filter-container">
                <button class="filter-btn active" data-filter="all">All Feedback</button>
                <button class="filter-btn" data-filter="positive">Positive</button>
                <button class="filter-btn" data-filter="neutral">Neutral</button>
                <button class="filter-btn" data-filter="negative">Negative</button>
            </div>

            <!-- Feedback Cards -->
            <div class="row" id="feedbackContainer">
                <% for (Feedback feedback : feedbackList) { 
                    String ratingClass = "";
                    String sentimentClass = "";
                    
                    if (feedback.getRating() >= 4) {
                        ratingClass = "feedback-rating-" + feedback.getRating();
                        sentimentClass = "positive";
                    } else if (feedback.getRating() == 3) {
                        ratingClass = "feedback-rating-" + feedback.getRating();
                        sentimentClass = "neutral";
                    } else {
                        ratingClass = "feedback-rating-" + feedback.getRating();
                        sentimentClass = "negative";
                    }
                %>
                    <div class="col-md-6 col-lg-4 feedback-item <%= sentimentClass %>">
                        <div class="feedback-card <%= ratingClass %>">
                            <div class="feedback-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="customer-info">
                                        <i class="fas fa-user-circle mr-1"></i> Customer #<%= feedback.getCustomerId() %>
                                    </div>
                                    <div class="rating-stars">
                                        <% for(int i = 1; i <= 5; i++) { %>
                                            <i class="<%= (i <= feedback.getRating()) ? "fas fa-star" : "far fa-star" %>"></i>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feedback-body">
                                <div class="feedback-text">
                                    "<%= feedback.getComment() %>"
                                </div>
                            </div>
                            
                            <div class="feedback-footer d-flex justify-content-between align-items-center">
                                <span class="feedback-id">
                                    <i class="fas fa-hashtag"></i> <%= feedback.getFeedbackId() %>
                                </span>
                                <span class="feedback-date">
                                    <i class="far fa-calendar-alt mr-1"></i><%= dateFormat.format(feedback.getFeedbackDate()) %>
                                </span>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-feedback">
                <i class="fas fa-inbox"></i>
                <h3>No feedback available</h3>
                <p class="text-muted">There are currently no customer feedback submissions in the system.</p>
            </div>
        <% } %>
        
        <div class="text-center mt-4 mb-5">
            <a href="Manager_Dashboard.jsp" class="btn btn-primary back-btn">
                <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
            </a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            
            // Filter functionality
            $(".filter-btn").click(function() {
                $(".filter-btn").removeClass("active");
                $(this).addClass("active");
                
                var filterValue = $(this).data("filter");
                
                if (filterValue === "all") {
                    $(".feedback-item").show();
                } else {
                    $(".feedback-item").hide();
                    $("." + filterValue).show();
                }
            });
        });
    </script>
</body>
</html>