<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="da.ReviewDAO"%>
<%@page import="da.DatabaseLink"%>
<%@page import="domain.Review"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Management</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2d8659;
            --primary-dark: #1a5d42;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
        }
        
        body {
            background-color: #f5f5f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            padding: 20px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            display: flex;
            align-items: center;
            color: white;
        }
        
        .logo i {
            font-size: 24px;
            margin-right: 10px;
        }
        
        .logo h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        
        .user-area {
            display: flex;
            align-items: center;
        }
        
        .user-profile-link {
            text-decoration: none;
            color: white;
            transition: all 0.3s ease;
        }
        
        .user-profile-link:hover {
            opacity: 0.9;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            background-color: rgba(255, 255, 255, 0.1);
            padding: 8px 15px;
            border-radius: 30px;
        }
        
        .user-avatar {
            width: 35px;
            height: 35px;
            background-color: white;
            color: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }
        
        .navigation-menu {
            background-color: white;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        
        .nav-item {
            display: inline-block;
            padding: 10px 15px;
            margin: 5px;
            color: var(--dark-color);
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        
        .nav-item:hover {
            background-color: rgba(45, 134, 89, 0.1);
            color: var(--primary-color);
        }
        
        .nav-item.active {
            background-color: var(--primary-color);
            color: white;
        }
        
        .nav-item i {
            margin-right: 8px;
        }
        
        .reviews-table {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table th {
            background-color: #f4f6f9;
            color: #495057;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }
        
        .table td, .table th {
            padding: 15px;
            vertical-align: middle;
        }
        
        .rating {
            color: #ffd700;
            font-size: 1.1em;
        }
        
        .btn-action {
            padding: 5px 15px;
            border-radius: 4px;
            font-size: 0.9em;
            margin: 0 5px;
        }
        
        .btn-reply {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }
        
        .btn-reply:hover {
            background-color: var(--primary-dark);
            color: white;
        }
        
        .btn-delete {
            background-color: var(--danger-color);
            color: white;
            border: none;
        }
        
        .btn-delete:hover {
            background-color: #c82333;
            color: white;
        }
        
        .reply-form {
            margin-top: 10px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            display: none;
        }
        
        .reply-active {
            display: block;
        }
        
        .reply-area {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            margin-top: 10px;
        }
        
        .reply-header {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .reply-content {
            margin-bottom: 5px;
        }
        
        .reply-meta {
            font-size: 0.8em;
            color: #6c757d;
        }
        
        .alert {
            margin-bottom: 20px;
            border-radius: 5px;
            padding: 15px;
        }
        
        .badge-rating {
            font-size: 0.9em;
            padding: 5px 10px;
            border-radius: 20px;
        }
        
        .badge-1 { background-color: #dc3545; color: white; }
        .badge-2 { background-color: #fd7e14; color: white; }
        .badge-3 { background-color: #ffc107; color: black; }
        .badge-4 { background-color: #28a745; color: white; }
        .badge-5 { background-color: #20c997; color: white; }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        .comment-text {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .expand-comment {
            color: var(--primary-color);
            cursor: pointer;
            font-size: 0.9em;
            text-decoration: underline;
        }
        
        /* Modal styles */
        .modal-header {
            background-color: var(--primary-color);
            color: white;
        }
        
        .modal-title {
            font-weight: 600;
        }
        
        .close {
            color: white;
        }
        
        /* Pagination styles */
        .pagination {
            justify-content: center;
            margin-top: 20px;
        }
        
        .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .page-link {
            color: var(--primary-color);
        }
        
        .page-link:hover {
            color: var(--primary-dark);
        }
        
        /* Summary card styles */
        .summary-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            text-align: center;
        }
        
        .summary-number {
            font-size: 24px;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .summary-title {
            font-size: 14px;
            color: var(--secondary-color);
            margin-top: 5px;
        }
        
        .summary-icon {
            font-size: 30px;
            margin-bottom: 10px;
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-tachometer-alt"></i>
                    <h1>Staff Dashboard</h1>
                </div>
                <div class="user-area">
                    <a href="staffProfile.jsp?id=<%= session.getAttribute("staffId") %>" class="user-profile-link">
                        <div class="user-profile">
                            <div class="user-avatar">S</div>
                            <span><%= session.getAttribute("staffName") != null ? session.getAttribute("staffName") : "Staff" %></span>
                            <i class="fas fa-user-cog profile-icon"></i>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <!-- Navigation Menu -->
            <div class="navigation-menu">
                <a href="Staff_Dashboard.jsp" class="nav-item active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="staffdisplaycust.jsp" class="nav-item"><i class="fas fa-users"></i> Customers</a>
                <a href="Staff_Product.jsp" class="nav-item"><i class="fas fa-boxes"></i> Products </a>
                <a href="Staff_Orders.jsp" class="nav-item"><i class="fas fa-shopping-cart"></i> Orders </a>
                <a href="ViewFeedbackStaff.jsp" class="nav-item"><i class="fas fa-comments"></i> Feedback </a>
                <a href="Staff_Review.jsp" class="nav-item"><i class="fas fa-comments"></i> Reviews</a>
                <a href="contactus_admin.jsp" class="nav-item"><i class="fas fa-comments"></i> Contact Us</a>
                <a href="Logout.jsp" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
            
            
            <%
                DatabaseLink dbLink = new DatabaseLink();
                Connection connection = dbLink.getConnection();
                ReviewDAO reviewDAO = new ReviewDAO(connection);
                List<Review> reviews = reviewDAO.getAllReviews();
                
                // Calculate summary statistics
                int totalReviews = reviews.size();
                int repliedReviews = 0;
                int pendingReviews = 0;
                double averageRating = 0;
                
                for (Review review : reviews) {
                    if (review.getReply() != null && !review.getReply().isEmpty()) {
                        repliedReviews++;
                    } else {
                        pendingReviews++;
                    }
                    averageRating += review.getRating();
                }
                
                if (totalReviews > 0) {
                    averageRating = averageRating / totalReviews;
                }
            %>
            
            <!-- Summary Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="summary-card">
                        <i class="fas fa-comments summary-icon"></i>
                        <div class="summary-number"><%= totalReviews %></div>
                        <div class="summary-title">TOTAL REVIEWS</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-card">
                        <i class="fas fa-reply summary-icon"></i>
                        <div class="summary-number"><%= repliedReviews %></div>
                        <div class="summary-title">REPLIED REVIEWS</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-card">
                        <i class="fas fa-clock summary-icon"></i>
                        <div class="summary-number"><%= pendingReviews %></div>
                        <div class="summary-title">PENDING REPLIES</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-card">
                        <i class="fas fa-star summary-icon"></i>
                        <div class="summary-number"><%= String.format("%.1f", averageRating) %></div>
                        <div class="summary-title">AVERAGE RATING</div>
                    </div>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <% 
                String message = (String) session.getAttribute("message");
                String messageType = (String) session.getAttribute("messageType");
                if (message != null) {
            %>
                <div class="alert alert-<%= messageType.equals("success") ? "success" : "danger" %> alert-dismissible fade show" role="alert">
                    <i class="fas fa-<%= messageType.equals("success") ? "check-circle" : "exclamation-circle" %> me-2"></i>
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% 
                session.removeAttribute("message");
                session.removeAttribute("messageType");
            } 
            %>

            <!-- Reviews Table -->
            <div class="reviews-table">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Rating</th>
                                <th>Customer</th>
                                <th>Order ID</th>
                                <th>Date</th>
                                <th>Comment</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Review review : reviews) { %>
                            <tr>
                                <td><%= review.getReviewId() %></td>
                                <td>
                                    <span class="badge badge-<%= (int)review.getRating() %> badge-rating">
                                        <%= (int)review.getRating() %> <i class="fas fa-star"></i>
                                    </span>
                                </td>
                                <td><%= review.getCustomerId() %></td>
                                <td><%= review.getOrderId() %></td>
                                <td><%= review.getReviewDate() %></td>
                                <td>
                                    <div class="comment-text">
                                        <%= review.getComments() %>
                                    </div>
                                    <span class="expand-comment" data-bs-toggle="modal" data-bs-target="#commentModal<%= review.getReviewId() %>">
                                        View Full
                                    </span>
                                </td>
                                <td>
                                    <% if(review.getReply() != null && !review.getReply().isEmpty()) { %>
                                        <span class="badge bg-success">Replied</span>
                                    <% } else { %>
                                        <span class="badge bg-warning text-dark">Pending</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="d-flex">
                                        <% if(review.getReply() == null || review.getReply().isEmpty()) { %>
                                            <button class="btn btn-sm btn-reply btn-action" onclick="toggleReplyForm('<%= review.getReviewId() %>')">
                                                <i class="fas fa-reply"></i> Reply
                                            </button>
                                        <% } else { %>
                                            <button class="btn btn-sm btn-outline-primary btn-action" data-bs-toggle="modal" data-bs-target="#replyModal<%= review.getReviewId() %>">
                                                <i class="fas fa-eye"></i> View Reply
                                            </button>
                                        <% } %>
                                        <button class="btn btn-sm btn-delete btn-action" data-bs-toggle="modal" data-bs-target="#deleteModal<%= review.getReviewId() %>">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </div>
                                    
                                    <!-- Reply Form -->
                                    <div id="replyForm<%= review.getReviewId() %>" class="reply-form">
                                        <form action="AdminReplyServlet" method="POST">
                                            <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                            <div class="mb-3">
                                                <textarea class="form-control" name="reply" rows="3" placeholder="Type your reply here..." required></textarea>
                                            </div>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-paper-plane"></i> Submit Reply
                                            </button>
                                            <button type="button" class="btn btn-secondary" onclick="toggleReplyForm('<%= review.getReviewId() %>')">
                                                Cancel
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Pagination -->
            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Previous</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">Next</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>

    <!-- Comment Modals -->
    <% for (Review review : reviews) { %>
    <div class="modal fade" id="commentModal<%= review.getReviewId() %>" tabindex="-1" aria-labelledby="commentModalLabel<%= review.getReviewId() %>" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="commentModalLabel<%= review.getReviewId() %>">Customer Comment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <p><strong>Rating:</strong> 
                            <span class="rating">
                                <% for(int i = 0; i < review.getRating(); i++) { %>
                                    <i class="fas fa-star"></i>
                                <% } %>
                                <% for(int i = 0; i < (5-review.getRating()); i++) { %>
                                    <i class="far fa-star"></i>
                                <% } %>
                            </span>
                        </p>
                        <p><strong>From:</strong> Customer <%= review.getCustomerId() %></p>
                        <p><strong>Order ID:</strong> <%= review.getOrderId() %></p>
                        <p><strong>Date:</strong> <%= review.getReviewDate() %></p>
                    </div>
                    <div class="card p-3">
                        <p><%= review.getComments() %></p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <% if(review.getReply() == null || review.getReply().isEmpty()) { %>
                        <button type="button" class="btn btn-primary" onclick="toggleReplyForm('<%= review.getReviewId() %>')" data-bs-dismiss="modal">
                            <i class="fas fa-reply"></i> Reply
                        </button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Reply View Modals -->
    <% for (Review review : reviews) { 
        if(review.getReply() != null && !review.getReply().isEmpty()) {
    %>
    <div class="modal fade" id="replyModal<%= review.getReviewId() %>" tabindex="-1" aria-labelledby="replyModalLabel<%= review.getReviewId() %>" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="replyModalLabel<%= review.getReviewId() %>">Staff Reply</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <p><strong>Original Comment:</strong></p>
                        <div class="card p-3 mb-3">
                            <p><%= review.getComments() %></p>
                        </div>
                        <p><strong>Staff Reply:</strong></p>
                        <div class="card p-3">
                            <p><%= review.getReply() %></p>
                        </div>
                        <p class="mt-2 text-muted">
                            <small>Replied by: <%= review.getReplyBy() %> on <%= review.getReplyAt() %></small>
                        </p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <% } } %>

    <!-- Delete Confirmation Modals -->
    <% for (Review review : reviews) { %>
    <div class="modal fade" id="deleteModal<%= review.getReviewId() %>" tabindex="-1" aria-labelledby="deleteModalLabel<%= review.getReviewId() %>" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel<%= review.getReviewId() %>">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this review?</p>
                    <p><strong>Review ID:</strong> <%= review.getReviewId() %></p>
                    <p><strong>Customer:</strong> <%= review.getCustomerId() %></p>
                    <div class="alert alert-warning" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i> This action cannot be undone.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="DeleteReviewServlet" method="POST" style="display: inline;">
                        <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-1"></i> Delete
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function toggleReplyForm(reviewId) {
            const replyForm = document.getElementById('replyForm' + reviewId);
            replyForm.classList.toggle('reply-active');
        }
        
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        });
    </script>
</body>
</html>