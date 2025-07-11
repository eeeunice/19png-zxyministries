<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="domain.staffprofile, da.staffpro"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Staff Profile</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            margin: 20px auto;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            font-weight: 500;
            margin-bottom: 5px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .btn-save {
            background-color: #3a7ca5;
            color: white;
        }

        .btn-cancel {
            background-color: #ccc;
            color: black;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn:hover {
            opacity: 0.9;
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
        
        // Check if ID is provided in URL parameter
        String staffIdParam = request.getParameter("id");
        staffprofile staffToEdit = null;
        
        // If ID is provided, get staff details from database
        if (staffIdParam != null && !staffIdParam.trim().isEmpty()) {
            staffToEdit = staffpro.getStaffById(staffIdParam);
            
            // If staff found, set session attributes
            if (staffToEdit != null) {
                session.setAttribute("staffId", staffToEdit.getStaffId());
                session.setAttribute("staffName", staffToEdit.getStaffName());
                session.setAttribute("staffEmail", staffToEdit.getStaffEmail());
                session.setAttribute("staffPhone", staffToEdit.getStaffPhone());
                session.setAttribute("staffPassword", staffToEdit.getStaffPassword());
                session.setAttribute("staffRole", staffToEdit.getRole());
            }
        }
        
        // If staff not found and not coming from profile page, redirect back
        if (staffToEdit == null && staffIdParam != null) {
            session.setAttribute("errorMessage", "Staff not found!");
            response.sendRedirect("Staff_Management.jsp");
            return;
        }
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-user-edit"></i>
                    <h1>Edit Staff Profile</h1>
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
            <!-- Form Content -->
            <div class="form-container">
                <h2>Edit Profile</h2>
                <form action="editStaffServlet" method="post">
                    <input type="hidden" name="staffId" value="${sessionScope.staffId}">

                    <div class="form-group">
                        <label for="staffName">Name</label>
                        <input type="text" id="staffName" name="staffName" value="${sessionScope.staffName}" required>
                    </div>

                    <div class="form-group">
                        <label for="staffEmail">Email</label>
                        <input type="email" id="staffEmail" name="staffEmail" value="${sessionScope.staffEmail}" required>
                    </div>

                    <div class="form-group">
                        <label for="staffPhone">Phone</label>
                        <input type="text" id="staffPhone" name="staffPhone" value="${sessionScope.staffPhone}" required>
                    </div>

                    <div class="form-group">
                        <label for="staffPassword">Password</label>
                        <input type="password" id="staffPassword" name="staffPassword" value="${sessionScope.staffPassword}" required>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-save">Save</button>
                        <a href="staffProfile.jsp" class="btn btn-cancel">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
