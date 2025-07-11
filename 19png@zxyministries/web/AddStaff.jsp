<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Staff</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <style>
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 500px;
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
        input[type="password"],
        select {
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

        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-save {
            background-color: #3d7ea6;
            color: white;
        }

        .btn-cancel {
            background-color: #ccc;
            color: black;
        }

        .btn:hover {
            opacity: 0.9;
        }
        
        .role-input {
            margin-top: 10px;
            display: none;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        if (session.getAttribute("managerId") == null) {
            response.sendRedirect("Login_mgn.jsp");
            return;
        }
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-user-tie"></i>
                    <h1>Add New Staff</h1>
                </div>
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
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <!-- Form Container -->
            <div class="form-container">
                <h2>Add New Staff</h2>
                <form action="AddStaffServlet" method="post">
                    <div class="form-group">
                        <label for="staffName">Name</label>
                        <input type="text" id="staffName" name="staffName" required>
                    </div>

                    <div class="form-group">
                        <label for="staffEmail">Email</label>
                        <input type="email" id="staffEmail" name="staffEmail" required>
                    </div>

                    <div class="form-group">
                        <label for="staffPhone">Phone</label>
                        <input type="text" id="staffPhone" name="staffPhone" required>
                    </div>

                    <div class="form-group">
                        <label for="staffPassword">Password</label>
                        <input type="password" id="staffPassword" name="staffPassword" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="staffRole">Role</label>
                        <select id="staffRole" name="staffRole" onchange="toggleCustomRole()" required>
                            <option value="">Select Role</option>
                            <option value="Admin">Admin</option>
                            <option value="Staff">Staff</option>
                            <option value="custom">Custom Role</option>
                        </select>
                        <div id="customRoleInput" class="role-input">
                            <label for="customRole">Enter Custom Role</label>
                            <input type="text" id="customRole" name="customRole">
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-save">Add Staff</button>
                        <a href="Staff_Management.jsp" class="btn btn-cancel">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function toggleCustomRole() {
            var roleSelect = document.getElementById('staffRole');
            var customRoleDiv = document.getElementById('customRoleInput');
            var customRoleInput = document.getElementById('customRole');
            
            if (roleSelect.value === 'custom') {
                customRoleDiv.style.display = 'block';
                customRoleInput.required = true;
            } else {
                customRoleDiv.style.display = 'none';
                customRoleInput.required = false;
            }
        }
    </script>
</body>
</html>