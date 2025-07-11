<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="da.ManagerDAO" %>
<%@ page import="domain.Manager" %>

<%
    // Check if user is logged in
    if (session.getAttribute("managerId") == null) {
        response.sendRedirect("Login_mgn.jsp");
        return;
    }
    
    String managerId = request.getParameter("id");
    if (managerId == null || managerId.isEmpty()) {
        managerId = session.getAttribute("managerId").toString();
    }
    
    // Get manager data
    ManagerDAO managerDAO = new ManagerDAO();
    Manager manager = managerDAO.getManagerById(managerId);
    
    // Check for success or error messages
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <title>Manager Profile</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <style>
        .profile-container {
            background-color: #fff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            background-color: #1a5d42;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            margin-right: 20px;
        }
        
        .profile-title h2 {
            margin: 0;
            color: #333;
        }
        
        .profile-title p {
            margin: 5px 0 0;
            color: #666;
        }
        
        .profile-form {
            margin-top: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #555;
        }
        
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .btn-container {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn-primary {
            background-color: #1a5d42;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-user-cog"></i>
                    <h1>Manager Profile</h1>
                </div>
                <div class="user-area">
                    <a href="Manager_Dashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container"> 
            <div class="profile-container">
                <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
                <% } %>
                
                <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <%= errorMessage %>
                </div>
                <% } %>
                
                <div class="profile-header">
                    <div class="profile-avatar">
                        <%= manager.getName().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="profile-title">
                        <h2><%= manager.getName() %></h2>
                        <p>Manager ID: <%= manager.getManagerId() %></p>
                    </div>
                </div>
                
                <form action="UpdateManagerServlet" method="post" class="profile-form">
                    <input type="hidden" name="managerId" value="<%= manager.getManagerId() %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= manager.getName() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= manager.getEmail() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" value="<%= manager.getPhone() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" value="<%= manager.getUsername() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="currentPassword">Current Password (required to save changes)</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="newPassword">New Password (leave blank to keep current)</label>
                            <input type="password" id="newPassword" name="newPassword">
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword">
                        </div>
                    </div>
                    
                    <div class="btn-container">
                        <button type="reset" class="btn-secondary">Reset</button>
                        <button type="submit" class="btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Form validation
        document.querySelector('form').addEventListener('submit', function(event) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                event.preventDefault();
                alert('New passwords do not match!');
            }
        });
    </script>
</body>
</html>