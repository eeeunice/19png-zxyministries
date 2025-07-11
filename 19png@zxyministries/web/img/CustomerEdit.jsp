<%@ page import="java.util.*, da.CustomerDB, domain.CustomerRegister, domain.Address, da.AddressDB" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Customer</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <style>
        .edit-container {
            max-width: 800px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #495057;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #6d44b8;
            color: white;
            border: none;
        }
        .btn-primary:hover {
            background-color: #5a359e;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
            border: none;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .section-title {
            margin: 30px 0 15px;
            color: #6d44b8;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .gender-options {
            display: flex;
            gap: 20px;
        }
        .gender-option {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
        
        // Get customer ID from request parameter
        String customerId = request.getParameter("id");
        if (customerId == null || customerId.isEmpty()) {
            response.sendRedirect("Manager_Customers.jsp");
            return;
        }
        
        // Fetch customer details
        CustomerDB customerDB = new CustomerDB();
        CustomerRegister customer = customerDB.getCustomerById(customerId);
        
        if (customer == null) {
            response.sendRedirect("Manager_Customers.jsp");
            return;
        }
        
        // Fetch address details
        AddressDB addressDB = new AddressDB();
        Address address = addressDB.getAddressById(customer.getAddressid());
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-users"></i>
                    <h1>Edit Customer</h1>
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
            <!-- Edit Form Container -->
            <div class="edit-container">
                <h2><i class="fas fa-user-edit"></i> Edit Customer Information</h2>
                
                <!-- Display error message if any -->
                <% if(request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                
                <form action="UpdateCustomerServlet" method="post">
                    <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
                    <input type="hidden" name="addressId" value="<%= customer.getAddressid() %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="custname" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="custname" name="custname" value="<%= customer.getCustName() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= customer.getEmail() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" value="<%= customer.getUsername() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="phonenum" class="form-label">Phone Number</label>
                            <input type="text" class="form-control" id="phonenum" name="phonenum" value="<%= customer.getPhoneNum() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="dateofbirth" class="form-label">Date of Birth</label>
                            <input type="date" class="form-control" id="dateofbirth" name="dateofbirth" value="<%= customer.getDateOfBirth().toString() %>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Gender</label>
                            <div class="gender-options">
                                <div class="gender-option">
                                    <input type="radio" id="male" name="gender" value="M" <%= customer.getGender().equals("M") ? "checked" : "" %> required>
                                    <label for="male">Male</label>
                                </div>
                                <div class="gender-option">
                                    <input type="radio" id="female" name="gender" value="F" <%= customer.getGender().equals("F") ? "checked" : "" %> required>
                                    <label for="female">Female</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <h3 class="section-title">Address Information</h3>
                    <% if (address != null) { %>
                    <div class="form-group">
                        <label for="street" class="form-label">Street Address</label>
                        <input type="text" class="form-control" id="street" name="street" value="<%= address.getStreet() %>" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="postcode" class="form-label">Postcode</label>
                            <input type="text" class="form-control" id="postcode" name="postcode" value="<%= address.getPostcode() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="city" class="form-label">City</label>
                            <input type="text" class="form-control" id="city" name="city" value="<%= address.getCity() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="state" class="form-label">State</label>
                            <input type="text" class="form-control" id="state" name="state" value="<%= address.getState() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="country" class="form-label">Country</label>
                            <input type="text" class="form-control" id="country" name="country" value="<%= address.getCountry() %>" required>
                        </div>
                    </div>
                    <% } else { %>
                    <div class="form-group">
                        <label for="street" class="form-label">Street Address</label>
                        <input type="text" class="form-control" id="street" name="street" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="postcode" class="form-label">Postcode</label>
                            <input type="text" class="form-control" id="postcode" name="postcode" required>
                        </div>
                        <div class="form-group">
                            <label for="city" class="form-label">City</label>
                            <input type="text" class="form-control" id="city" name="city" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="state" class="form-label">State</label>
                            <input type="text" class="form-control" id="state" name="state" required>
                        </div>
                        <div class="form-group">
                            <label for="country" class="form-label">Country</label>
                            <input type="text" class="form-control" id="country" name="country" required>
                        </div>
                    </div>
                    <% } %>
                    
                    <div class="action-buttons">
                        <a href="CustomerDetails.jsp?id=<%= customer.getCustomerId() %>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Details
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>