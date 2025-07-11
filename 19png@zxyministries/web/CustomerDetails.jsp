<%@ page import="java.util.*, da.CustomerDB, domain.CustomerRegister, domain.Address, da.AddressDB" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <style>
        .customer-details-container {
            max-width: 800px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        .customer-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        .customer-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .info-group {
            margin-bottom: 15px;
        }
        .info-label {
            font-weight: 600;
            color: #666;
            margin-bottom: 5px;
            display: block;
        }
        .info-value {
            font-size: 16px;
            color: #333;
        }
        .section-title {
            margin: 30px 0 15px;
            color: #6d44b8;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
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
        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: none;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 20px;
            border-radius: 5px;
            width: 400px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .modal-title {
            margin-top: 0;
            color: #dc3545;
        }
        .modal-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
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
                    <h1>Customer Details</h1>
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
            <!-- Customer Details Container -->
            <div class="customer-details-container">
                <div class="customer-header">
                    <h2><i class="fas fa-user"></i> Customer Information</h2>
                    <div>
                        <span class="badge"><%= customer.getGender().equals("M") ? "Male" : "Female" %></span>
                    </div>
                </div>
                
                <div class="customer-info">
                    <div class="info-group">
                        <span class="info-label">Customer ID</span>
                        <span class="info-value"><%= customer.getCustomerId() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Full Name</span>
                        <span class="info-value"><%= customer.getCustName() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Email</span>
                        <span class="info-value"><%= customer.getEmail() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Phone Number</span>
                        <span class="info-value"><%= customer.getPhoneNum() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Username</span>
                        <span class="info-value"><%= customer.getUsername() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Date of Birth</span>
                        <span class="info-value"><%= customer.getDateOfBirth() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Registration Date</span>
                        <span class="info-value"><%= customer.getRegistrationDate() %></span>
                    </div>
                </div>
                
                <h3 class="section-title">Address Information</h3>
                <div class="customer-info">
                    <% if (address != null) { %>
                    <div class="info-group">
                        <span class="info-label">Address ID</span>
                        <span class="info-value"><%= address.getAddressId() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Street</span>
                        <span class="info-value"><%= address.getStreet() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Postcode</span>
                        <span class="info-value"><%= address.getPostcode() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">City</span>
                        <span class="info-value"><%= address.getCity() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">State</span>
                        <span class="info-value"><%= address.getState() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Country</span>
                        <span class="info-value"><%= address.getCountry() %></span>
                    </div>
                    <% } else { %>
                    <div class="info-group" style="grid-column: span 2;">
                        <span class="info-value">No address information available</span>
                    </div>
                    <% } %>
                </div>
                
                <div class="action-buttons">
                    <a href="Manager_Customers.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Customer List
                    </a>
                    <div>
                        <a href="CustomerEdit.jsp?id=<%= customer.getCustomerId() %>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Customer
                        </a>
                        <button class="btn btn-danger" onclick="openDeleteModal()">
                            <i class="fas fa-trash-alt"></i> Delete Customer
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title"><i class="fas fa-exclamation-triangle"></i> Confirm Deletion</h3>
            <p>Are you sure you want to delete this customer? This action cannot be undone.</p>
            <div class="modal-buttons">
                <button class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                <form action="DeleteCustomerServlet" method="post" style="display: inline;">
                    <input type="hidden" name="id" value="<%= customer.getCustomerId() %>">
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function openDeleteModal() {
            document.getElementById('deleteModal').style.display = 'block';
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }
        
        // Close modal when clicking outside of it
        window.onclick = function(event) {
            var modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>