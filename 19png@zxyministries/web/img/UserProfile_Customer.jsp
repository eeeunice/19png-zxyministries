<%@page import="domain.CustomerRegister"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="domain.Customer"%>
<%@page import="java.util.List"%>
<%@page import="domain.Address"%>
<%@ page import="java.sql.*" %>
<%@ page import="da.CustomerDB" %>
<%@ page import="da.AddressDB" %>
<%@ page import="da.DatabaseLink" %>
<%
    String customerId = request.getParameter("customerId");
    
    // Check if customerId is null or empty
    if (customerId == null || customerId.trim().isEmpty()) {
        // Redirect to login page or show error
        response.sendRedirect("Login_cust.jsp?error=Please login first");
        return;
    }
    
    CustomerDB customerDB = new CustomerDB();
    AddressDB addressDB = new AddressDB();
    CustomerRegister customer = customerDB.getCustomerById(customerId);
    if (customer == null) {
        response.sendRedirect("Login_cust.jsp?error=Customer not found");
        return;
    }
    List<Address> addresses = addressDB.getAddressesByCustomerId(customerId);
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - <%= customer.getCustName() %></title>
    <link rel="stylesheet" href="./css/Blog_Customer.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <style>
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .address-card {
            margin-bottom: 15px;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .address-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .form-container {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container profile-container">
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h2 class="mb-0"><i class="fas fa-user-circle me-2"></i>User Profile</h2>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h4>Personal Information</h4>
                        <p><strong>Name:</strong> <%= customer.getCustName() %></p>
                        <p><strong>Email:</strong> <%= customer.getEmail() %></p>
                        <p><strong>Phone:</strong> <%= customer.getPhoneNum() %></p>
                        <p><strong>Gender:</strong> <%= customer.getGender() %></p>
                        <p><strong>Date of Birth:</strong> <%= customer.getDateOfBirth() != null ? customer.getDateOfBirth().toString() : "Not provided" %></p>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="Product_Customer.jsp" class="btn btn-outline-primary mb-2">
                            <i class="fas fa-shopping-bag me-2"></i>Continue Shopping
                        </a>
                        <a href="Cart_Customer.jsp" class="btn btn-outline-success mb-2">
                            <i class="fas fa-shopping-cart me-2"></i>View Cart
                        </a>
                        <a href="orderCustomer.jsp?customerId=<%= customerId %>" class="btn btn-outline-info mb-2">
                            <i class="fas fa-list me-2"></i>Order History
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h3 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>My Addresses</h3>
                <button class="btn btn-light btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#addAddressForm">
                    <i class="fas fa-plus me-1"></i>Add New Address
                </button>
            </div>
            <div class="card-body">
                <div class="collapse mb-4" id="addAddressForm">
                    <div class="form-container">
                        <h4>Add New Address</h4>
                        <form action="InsertAddressServlet" method="post" class="row g-3">
                            <input type="hidden" name="customerId" value="<%= customerId %>"/>
                            <div class="col-md-12">
                                <label for="street" class="form-label">Street Address</label>
                                <input type="text" class="form-control" id="street" name="street" required/>
                            </div>
                            <div class="col-md-6">
                                <label for="city" class="form-label">City</label>
                                <input type="text" class="form-control" id="city" name="city" required/>
                            </div>
                            <div class="col-md-6">
                                <label for="state" class="form-label">State</label>
                                <input type="text" class="form-control" id="state" name="state" required/>
                            </div>
                            <div class="col-md-6">
                                <label for="zip" class="form-label">Postcode</label>
                                <input type="text" class="form-control" id="zip" name="zip" required/>
                            </div>
                            <div class="col-md-6">
                                <label for="country" class="form-label">Country</label>
                                <input type="text" class="form-control" id="country" name="country" value="Malaysia" required/>
                            </div>
                            <div class="col-12 text-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Address
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <% if (addresses == null || addresses.isEmpty()) { %>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>You don't have any saved addresses yet. Please add an address.
                    </div>
                <% } else { %>
                    <div class="row">
                        <% for (Address address : addresses) { %>
                            <div class="col-md-6">
                                <div class="address-card">
                                    <h5><i class="fas fa-home me-2"></i>Address</h5>
                                    <p>
                                        <%= address.getStreet() %><br>
                                        <%= address.getCity() %>, <%= address.getState() %><br>
                                        <%= address.getPostcode() %><br>
                                        <%= address.getCountry() %>
                                    </p>
                                    <div class="address-actions">
                                        <a href="EditAddressServlet?addressId=<%= address.getAddressId() %>" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <% if (addresses.size() > 1) { %>
                                            <a href="DeleteAddressServlet?addressId=<%= address.getAddressId() %>&customerId=<%= customerId %>" 
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Are you sure you want to delete this address?');">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <footer class="bg-dark text-white text-center py-3 mt-5">
        <p>&copy; 1999 Beauty & Skincare. All rights reserved.</p>
    </footer>
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>