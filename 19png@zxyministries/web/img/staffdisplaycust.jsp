<%@ page import="java.util.*, da.Customerdisplay_cust, domain.staff_displaycust" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
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
                    <i class="fas fa-users"></i>
                    <h1>Customer Management</h1>
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
                <a href="Staff_Dashboard.jsp" class="nav-item"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="staffdisplaycust.jsp" class="nav-item active"><i class="fas fa-users"></i> Customers</a>
                <a href="Staff_Product.jsp" class="nav-item"><i class="fas fa-boxes"></i> Products </a>
                <a href="Staff_Orders.jsp" class="nav-item"><i class="fas fa-shopping-cart"></i> Orders </a>
                <a href="ViewFeedbackStaff.jsp" class="nav-item"><i class="fas fa-comments"></i> Feedback </a>
                <a href="ReviewManagement.jsp" class="nav-item"><i class="fas fa-comments"></i> Reviews</a>
                <a href="adminContact" class="nav-item"><i class="fas fa-comments"></i> Contact Us</a>
                <a href="Logout.jsp" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
            
            <!-- Customers Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Customer List</h2>
                    <div class="search-box">
                        <input type="text" placeholder="Search customers..." id="customerSearch">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="products-table" id="customersTable">
                        <thead>
                            <tr>
                                <th>Customer ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone Number</th>
                                <th>Date of Birth</th>
                                <th>Gender</th>
                                <th>Registration Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Customerdisplay_cust dao = new Customerdisplay_cust();
                                List<staff_displaycust> customers = dao.getAllCustomers();

                                if (customers != null && !customers.isEmpty()) {
                                    for (staff_displaycust cust : customers) {
                            %>
                            <tr>
                                <td><%= cust.getCustomerId() %></td>
                                <td><%= cust.getCustName() %></td>
                                <td><%= cust.getEmail() %></td>
                                <td><%= cust.getPhonenum() %></td>
                                <td><%= cust.getdateofbirth() %></td>
                                <td><%= cust.getGender() %></td>
                                <td><%= cust.getregistrationdate() %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr><td colspan="7" class="text-center">No customer data found.</td></tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <div class="pagination">
                    <button class="page-item nav-button" id="prevPage"><i class="fas fa-angle-left"></i></button>
                    <div class="page-numbers" id="pageNumbers">
                        <div class="page-item page-green active">1</div>
                        <div class="page-item page-blue">2</div>
                        <div class="page-item page-blue">3</div>
                    </div>
                    <button class="page-item nav-button" id="nextPage"><i class="fas fa-angle-right"></i></button>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Custom pagination styling */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            gap: 5px;
        }
        
        .page-numbers {
            display: flex;
            gap: 5px;
        }
        
        .page-item {
            width: 30px;
            height: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            border-radius: 4px;
            font-weight: bold;
            color: white;
        }
        
        .nav-button {
            background-color: #f0f0f0;
            color: #333;
            border: 1px solid #ddd;
        }
        
        .page-green {
            background-color: #0d7a3b;
        }
        
        .page-blue {
            background-color: #1e4c9a;
        }
        
        .page-item:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
    </style>

    <script>
        // Enhanced search functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('customerSearch');
            const table = document.getElementById('customersTable');
            const rows = table.getElementsByTagName('tr');
            const itemsPerPage = 10; // Number of items to display per page
            let currentPage = 1;
            let filteredRows = [];
            
            // Initialize pagination
            function initPagination() {
                // Get all rows except header
                filteredRows = [];
                for (let i = 1; i < rows.length; i++) {
                    if (rows[i].style.display !== 'none') {
                        filteredRows.push(rows[i]);
                    }
                }
                
                const totalPages = Math.ceil(filteredRows.length / itemsPerPage);
                updatePagination(totalPages);
                showPage(currentPage);
            }
            
            // Update pagination controls
            function updatePagination(totalPages) {
                const pageNumbers = document.getElementById('pageNumbers');
                pageNumbers.innerHTML = '';
                
                // Limit to show 3 page numbers at most (as shown in the image)
                const startPage = Math.max(1, currentPage - 1);
                const endPage = Math.min(totalPages, startPage + 2);
                
                for (let i = startPage; i <= endPage; i++) {
                    const pageItem = document.createElement('div');
                    // Apply different colors based on position
                    if (i === 1) {
                        pageItem.className = 'page-item page-green' + (i === currentPage ? ' active' : '');
                    } else {
                        pageItem.className = 'page-item page-blue' + (i === currentPage ? ' active' : '');
                    }
                    pageItem.textContent = i;
                    pageItem.addEventListener('click', function() {
                        currentPage = i;
                        showPage(currentPage);
                        updatePagination(totalPages);
                    });
                    pageNumbers.appendChild(pageItem);
                }
                
                // Disable/enable prev/next buttons
                document.getElementById('prevPage').disabled = currentPage === 1;
                document.getElementById('nextPage').disabled = currentPage === totalPages || totalPages === 0;
            }
            
            // Show the specified page
            function showPage(page) {
                const start = (page - 1) * itemsPerPage;
                const end = start + itemsPerPage;
                
                // Hide all rows first
                for (let i = 1; i < rows.length; i++) {
                    rows[i].style.display = 'none';
                }
                
                // Show only rows for current page
                for (let i = start; i < Math.min(end, filteredRows.length); i++) {
                    filteredRows[i].style.display = '';
                }
            }
            
            // Search functionality
            searchInput.addEventListener('keyup', function() {
                const query = searchInput.value.toLowerCase();
                
                // Filter rows based on search query
                for (let i = 1; i < rows.length; i++) {
                    const row = rows[i];
                    const cells = row.getElementsByTagName('td');
                    let found = false;
                    
                    for (let j = 0; j < cells.length; j++) {
                        const cellText = cells[j].textContent.toLowerCase();
                        if (cellText.indexOf(query) > -1) {
                            found = true;
                            break;
                        }
                    }
                    
                    row.style.display = found ? '' : 'none';
                }
                
                // Reset to first page and update pagination
                currentPage = 1;
                initPagination();
            });
            
            // Previous page button
            document.getElementById('prevPage').addEventListener('click', function() {
                if (currentPage > 1) {
                    currentPage--;
                    showPage(currentPage);
                    updatePagination(Math.ceil(filteredRows.length / itemsPerPage));
                }
            });
            
            // Next page button
            document.getElementById('nextPage').addEventListener('click', function() {
                const totalPages = Math.ceil(filteredRows.length / itemsPerPage);
                if (currentPage < totalPages) {
                    currentPage++;
                    showPage(currentPage);
                    updatePagination(totalPages);
                }
            });
            
            // Initialize pagination on page load
            initPagination();
        });
    </script>
</body>
</html>
