<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="domain.staffprofile, da.staffpro"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: 0.3s;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .card:hover {
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            padding: 15px 20px;
            border-radius: 10px 10px 0 0;
        }
        .card-body {
            padding: 20px;
        }
        .btn-action {
            margin-right: 10px;
        }
        .staff-info {
            margin-bottom: 15px;
        }
        .staff-info label {
            font-weight: bold;
            display: inline-block;
            width: 120px;
        }
        .action-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <% 
            // Get staff ID from request parameter
            String staffId = request.getParameter("id");
            
            // Check if staff ID is provided
            if (staffId == null || staffId.trim().isEmpty()) {
                response.sendRedirect("Staff_Management.jsp");
                return;
            }
            
            // Get staff details from database
            staffprofile staff = staffpro.getStaffById(staffId);
            
            // Check if staff exists
            if (staff == null) {
                session.setAttribute("errorMessage", "Staff not found!");
                response.sendRedirect("Staff_Management.jsp");
                return;
            }
        %>
        
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3>Staff Details</h3>
                        <a href="Staff_Management.jsp" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left"></i> Back to Staff List
                        </a>
                    </div>
                    <div class="card-body">
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
                        
                        <div class="staff-info">
                            <label>Staff ID:</label>
                            <span><%= staff.getStaffId() %></span>
                        </div>
                        <div class="staff-info">
                            <label>Name:</label>
                            <span><%= staff.getStaffName() %></span>
                        </div>
                        <div class="staff-info">
                            <label>Email:</label>
                            <span><%= staff.getStaffEmail() %></span>
                        </div>
                        <div class="staff-info">
                            <label>Phone:</label>
                            <span><%= staff.getStaffPhone() %></span>
                        </div>
                        <div class="staff-info">
                            <label>Role:</label>
                            <span><%= staff.getRole() %></span>
                        </div>
                        
                        <div class="action-buttons">
                            <a href="editStaffManager.jsp?id=<%= staff.getStaffId() %>" class="btn btn-primary btn-action">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="DeleteStaffServlet?id=<%= staff.getStaffId() %>" 
                               class="btn btn-danger btn-action"
                               onclick="return confirm('Are you sure you want to delete this staff member?');">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>