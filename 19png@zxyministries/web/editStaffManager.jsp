<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="domain.staffprofile, da.staffpro"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Staff - Manager</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@400;500&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
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
            color: #495057;
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
                    <h1>Edit Staff</h1>
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
            <!-- Edit Staff Form -->
            <div class="form-container">
                <h2>Edit Staff Information</h2>
                
                <% if (session.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <%= session.getAttribute("successMessage") %>
                        <% session.removeAttribute("successMessage"); %>
                    </div>
                <% } %>
                
                <% if (session.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <%= session.getAttribute("errorMessage") %>
                        <% session.removeAttribute("errorMessage"); %>
                    </div>
                <% } %>
                
                <form action="editStaffManagerServlet" method="post">
                    <input type="hidden" name="staffId" value="${sessionScope.staffId}">

                    <div class="form-group">
                        <label for="staffName">Name</label>
                        <input type="text" id="staffName" name="staffName" value="${sessionScope.staffName}" required class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="staffEmail">Email</label>
                        <input type="email" id="staffEmail" name="staffEmail" value="${sessionScope.staffEmail}" required class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="staffPhone">Phone</label>
                        <input type="text" id="staffPhone" name="staffPhone" value="${sessionScope.staffPhone}" required class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="staffPassword">Password</label>
                        <input type="password" id="staffPassword" name="staffPassword" value="${sessionScope.staffPassword}" required class="form-control">
                    </div>
                    
                    <div class="form-group">
                        <label for="staffRole">Role</label>
                        <select id="staffRole" name="staffRole" onchange="toggleCustomRole()" required class="form-control">
                            <option value="${sessionScope.staffRole}">${sessionScope.staffRole}</option>
                            <option value="Admin">Admin</option>
                            <option value="Sales">Sales</option>
                            <option value="Support">Support</option>
                            <option value="Inventory">Inventory</option>
                            <option value="custom">Custom Role</option>
                        </select>
                        <div id="customRoleInput" class="role-input">
                            <label for="customRole">Enter Custom Role</label>
                            <input type="text" id="customRole" name="customRole" class="form-control">
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="Staff_Management.jsp" class="btn btn-cancel">
                            <i class="fas fa-arrow-left"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-save">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const roleSelect = document.getElementById('staffRole');
            const currentRole = '${sessionScope.staffRole}';
            
            // Set the selected role in the dropdown
            for(let i = 0; i < roleSelect.options.length; i++) {
                if(roleSelect.options[i].value === currentRole) {
                    roleSelect.selectedIndex = i;
                    break;
                }
            }
            
            // Check if we need to show the custom role input
            toggleCustomRole();
        });
        
        function toggleCustomRole() {
            var roleSelect = document.getElementById('staffRole');
            var customRoleDiv = document.getElementById('customRoleInput');
            var customRoleInput = document.getElementById('customRole');
            
            if (roleSelect.value === 'custom') {
                customRoleDiv.style.display = 'block';
                customRoleInput.required = true;
                customRoleInput.value = '${sessionScope.staffRole}';
            } else {
                customRoleDiv.style.display = 'none';
                customRoleInput.required = false;
            }
        }
    </script>
</body>
</html>

<%
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