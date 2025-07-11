<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Profile</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600&family=Playfair+Display:wght@500&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Jost', sans-serif;
            background: linear-gradient(to top, #d0eaff 0%, #ffffff 100%);
            background-attachment: fixed;
            background-repeat: no-repeat;
            min-height: 100vh;
        }

        .profile-container {
            width: 100%;
            max-width: 600px;
            background: linear-gradient(-225deg, #ffffff 50%, #d6edff 50%);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            padding: 40px;
            transition: 0.3s ease;
            margin: 20px auto;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid rgba(109, 68, 184, 0.2);
            padding-bottom: 20px;
        }

        .profile-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2.2em;
            color: #3e403f;
            margin-bottom: 10px;
        }

        .profile-header p {
            color: #5E6472;
            font-size: 1.1em;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            background-color: #3a7ca5;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-avatar i {
            font-size: 50px;
            color: white;
        }

        .profile-details {
            margin-bottom: 30px;
        }

        .detail-item {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }

        .detail-icon {
            width: 40px;
            height: 40px;
            background-color: rgba(58, 124, 165, 0.1);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .detail-icon i {
            color: #3a7ca5;
            font-size: 1.2em;
        }

        .detail-content {
            flex: 1;
        }

        .detail-label {
            font-size: 0.9em;
            color: #888;
            margin-bottom: 3px;
        }

        .detail-value {
            font-size: 1.1em;
            color: #333;
            font-weight: 500;
        }

        .profile-actions {
            display: flex;
            gap: 15px;
        }

        .btn {
            flex: 1;
            height: 45px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .btn-primary {
            background: #3a7ca5;
            color: white;
        }

        .btn-primary:hover {
            background: #2c5d7c;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: transparent;
            color: #3a7ca5;
            border: 2px solid #3a7ca5;
        }

        .btn-secondary:hover {
            background: rgba(58, 124, 165, 0.1);
        }

        .btn i {
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        if (session.getAttribute("staffId") == null) {
            response.sendRedirect("Login_Staff.jsp");
            return;
        }
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-user-circle"></i>
                    <h1>Staff Profile</h1>
                </div>
                <div class="user-area">
                    <div class="user-profile">
                        <div class="user-avatar">S</div>
                        <span><%= session.getAttribute("staffName") != null ? session.getAttribute("staffName") : "Staff" %></span>
                        <i class="fas fa-user-cog profile-icon"></i>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">

            <!-- Profile Content -->
            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h2>Welcome, ${sessionScope.staffName}</h2>
                    <p>Staff Profile Information</p>
                </div>

                <div class="profile-details">
                    <div class="detail-item">
                        <div class="detail-icon"><i class="fas fa-id-badge"></i></div>
                        <div class="detail-content">
                            <div class="detail-label">Staff ID</div>
                            <div class="detail-value">${sessionScope.staffId}</div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon"><i class="fas fa-envelope"></i></div>
                        <div class="detail-content">
                            <div class="detail-label">Email</div>
                            <div class="detail-value">${sessionScope.staffEmail}</div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon"><i class="fas fa-phone"></i></div>
                        <div class="detail-content">
                            <div class="detail-label">Phone</div>
                            <div class="detail-value">${sessionScope.staffPhone}</div>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon"><i class="fas fa-user-tag"></i></div>
                        <div class="detail-content">
                            <div class="detail-label">Role</div>
                            <div class="detail-value">${sessionScope.staffRole}</div>
                        </div>
                    </div>
                </div>

                <div class="profile-actions">
                    <a href="editStaff.jsp" class="btn btn-primary"><i class="fas fa-edit"></i> Edit Profile</a>
                    <a href="Staff_Dashboard.jsp" class="btn btn-secondary"><i class="fas fa-home"></i> Back to Home</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
