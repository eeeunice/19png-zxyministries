<%@ page import="java.util.*, da.Customerdisplay_cust, domain.staff_displaycust" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
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
                    <i class="fas fa-users"></i>
                    <h1>Customer Management</h1>
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
            <!-- Navigation Menu -->
            <div class="navigation-menu">
                <a href="Manager_Dashboard.jsp" class="nav-item active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="Product_Admin.jsp" class="nav-item"><i class="fas fa-box"></i> Products</a>
                <a href="Manager_Customers.jsp" class="nav-item"><i class="fas fa-users"></i> Customers</a>
                <a href="Orders_Manager.jsp" class="nav-item"><i class="fas fa-shopping-cart"></i> Orders</a>
                <a href="Staff_Management.jsp" class="nav-item"><i class="fas fa-user-tie"></i> Staff</a>
                <a href="Reports.jsp" class="nav-item"><i class="fas fa-chart-bar"></i> Reports</a>
                <a href="Promotion_Discount_Manager.jsp" class="nav-item"><i class="fas fa-percent"></i> Promotions</a>
                <a href="ViewFeedback.jsp" class="nav-item"><i class="fa-solid fa-comments"></i>Feedback</a>
                <a href="ReviewManagement.jsp" class="nav-item"><i class="fa-solid fa-comments"></i>Reviews</a>
                <a href="contactus_admin.jsp" class="nav-item"><i class="fas fa-comments"></i> Contact Us</a>
                <a href="Logout.jsp" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
            
            <!-- Customer Stats Cards -->
            <div class="dashboard-cards">
                <div class="card">
                    <h2>Total Customers</h2>
                    <div class="card-content">
                        <div class="card-value" id="totalCustomers">0</div>
                        <i class="fas fa-users card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>New This Month</h2>
                    <div class="card-content">
                        <div class="card-value" id="newCustomers">0</div>
                        <i class="fas fa-user-plus card-icon"></i>
                    </div>
                </div>
            </div>
            
            <!-- Success Message Display -->
            <% if(session.getAttribute("successMessage") != null) { %>
                <div id="successAlert" class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 10px; margin-bottom: 15px; border: 1px solid #c3e6cb; border-radius: 4px;">
                    <i class="fas fa-check-circle" style="margin-right: 5px;"></i> <%= session.getAttribute("successMessage") %>
                </div>
                <script>
                    // Auto-disappear after 10 seconds
                    setTimeout(function() {
                        var successAlert = document.getElementById('successAlert');
                        if(successAlert) {
                            successAlert.style.transition = 'opacity 1s';
                            successAlert.style.opacity = '0';
                            setTimeout(function() {
                                successAlert.style.display = 'none';
                            }, 1000);
                        }
                    }, 10000); // 10 seconds
                </script>
                <% session.removeAttribute("successMessage"); %>
            <% } %>

            <!-- Customers Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Customer List</h2>
                    <div class="search-box">
                        <input type="text" placeholder="Search customers..." id="customerSearch">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                </div>
                
                <div class="filters">
                    <div class="filter-group">
                        <label for="sort"><i class="fas fa-sort"></i> Sort by:</label>
                        <select name="sort" class="filter-select" id="sort">
                            <option value="">Select...</option>
                            <optgroup label="Name">
                                <option value="name_asc">Name (A-Z)</option>
                                <option value="name_desc">Name (Z-A)</option>
                            </optgroup>
                            <optgroup label="Registration Date">
                                <option value="date_asc">Registration (Oldest)</option>
                                <option value="date_desc">Registration (Newest)</option>
                            </optgroup>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="gender">Gender:</label>
                        <select class="filter-select" id="gender">
                            <option value="">All</option>
                            <option value="M">Male</option>
                            <option value="F">Female</option>
                        </select>
                    </div>
                </div>
                
                <!-- Add Customer Button -->
                <div class="action-buttons mb-3">
                    <a href="AddCustomer.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Customer
                    </a>
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
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Customerdisplay_cust dao = new Customerdisplay_cust();
                                List<staff_displaycust> customers = dao.getAllCustomers();
                                int totalCustomers = 0;
                                int newCustomersThisMonth = 0;
                                double avgOrderValue = 0.0;
                            
                                if (customers != null && !customers.isEmpty()) {
                                    totalCustomers = customers.size();
                                    newCustomersThisMonth = dao.getNewCustomersThisMonth();
                                    avgOrderValue = dao.getAverageOrderValue();
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
                                    <td>
                                        <div class="actions">
                                            <a href="CustomerDetails.jsp?id=<%= cust.getCustomerId() %>" class="action-btn view-btn">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr><td colspan="8" class="text-center">No customer data found.</td></tr>
                                <%
                                    }
                                %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Enhanced Pagination -->
    <div class="pagination-container">
        <div class="pagination-info">
            Showing <span id="showing-start">1</span> to <span id="showing-end">10</span> of <span id="total-items"><%= totalCustomers %></span> customers
        </div>
        <div class="pagination">
            <div class="page-item" id="prev-page" title="Previous Page"><i class="fas fa-angle-left"></i></div>
            <div class="page-numbers-container" id="page-numbers">
                <div class="page-item active">1</div>
                <div class="page-item">2</div>
                <div class="page-item">3</div>
                <% if (Math.ceil(totalCustomers / 10.0) > 3) { %>
                    <div class="page-item page-dots">...</div>
                    <div class="page-item"><%= Math.ceil(totalCustomers / 10.0) %></div>
                <% } %>
            </div>
            <div class="page-item" id="next-page" title="Next Page"><i class="fas fa-angle-right"></i></div>
        </div>
        <div class="pagination-options">
            <label for="items-per-page">Items per page:</label>
            <select id="items-per-page" class="filter-select">
                <option value="10">10</option>
                <option value="25">25</option>
                <option value="50">50</option>
                <option value="100">100</option>
            </select>
        </div>
    </div>
</div>
</div>
</div>

    <script>
                        
                // Enhanced pagination functionality with filter integration
                const itemsPerPageSelect = document.getElementById('items-per-page');
                const prevPageBtn = document.getElementById('prev-page');
                const nextPageBtn = document.getElementById('next-page');
                const showingStart = document.getElementById('showing-start');
                const showingEnd = document.getElementById('showing-end');
                const totalItems = document.getElementById('total-items');
                const pageNumbersContainer = document.getElementById('page-numbers');
                const searchInput = document.getElementById('customerSearch');
                const genderFilter = document.getElementById('gender');
                const sortSelect = document.getElementById('sort');
                const table = document.getElementById('customersTable');
                const rows = table.getElementsByTagName('tr');

                let currentPage = 1;
                let itemsPerPage = 10;
                const totalRows = <%= totalCustomers %>;
                let filteredRows = [];

                // Apply all filters and update visible rows
                function applyFilters() {
                    // Get filter values
                    const searchQuery = searchInput.value.toLowerCase();
                    const genderValue = genderFilter.value.toLowerCase();
                    const sortValue = sortSelect.value;
                    
                    // Reset filtered rows
                    filteredRows = [];
                    
                    // Apply search and gender filters
                    for (let i = 1; i < rows.length; i++) {
                        const row = rows[i];
                        const cells = row.getElementsByTagName('td');
                        let matchesSearch = false;
                        let matchesGender = true; // Default to true if no gender filter
                        
                        // Check search match
                        if (searchQuery) {
                            for (let j = 0; j < cells.length; j++) {
                                const cellText = cells[j].textContent.toLowerCase();
                                if (cellText.indexOf(searchQuery) > -1) {
                                    matchesSearch = true;
                                    break;
                                }
                            }
                        } else {
                            matchesSearch = true; // No search query means all match
                        }
                        
                        // Check gender match
                        if (genderValue && genderValue !== '') {
                            const genderCell = cells[5]; // Gender is at index 5
                            if (genderCell) {
                                const gender = genderCell.textContent.charAt(0).toLowerCase();
                                matchesGender = (gender === genderValue);
                            }
                        }
                        
                        // If row matches all filters, add to filtered rows
                        if (matchesSearch && matchesGender) {
                            filteredRows.push(row);
                        }
                        
                        // Hide all rows initially
                        row.style.display = 'none';
                    }
                    
                    // Apply sorting if needed
                    if (sortValue && sortValue !== '') {
                        filteredRows.sort((a, b) => {
                            if (sortValue === 'name_asc') {
                                return a.cells[1].textContent.localeCompare(b.cells[1].textContent);
                            } else if (sortValue === 'name_desc') {
                                return b.cells[1].textContent.localeCompare(a.cells[1].textContent);
                            } else if (sortValue === 'date_asc') {
                                return new Date(a.cells[6].textContent) - new Date(b.cells[6].textContent);
                            } else if (sortValue === 'date_desc') {
                                return new Date(b.cells[6].textContent) - new Date(a.cells[6].textContent);
                            }
                            return 0;
                        });
                    }
                    
                    // Reset to first page when filters change
                    currentPage = 1;
                    
                    // Update pagination and display rows
                    updatePagination();
                }

                function updatePagination() {
                    const filteredCount = filteredRows.length;
                    
                    // Calculate showing range based on filtered rows
                    const start = (currentPage - 1) * itemsPerPage + 1;
                    const end = Math.min(start + itemsPerPage - 1, filteredCount);
                    
                    // Update pagination info
                    showingStart.textContent = filteredCount > 0 ? start : 0;
                    showingEnd.textContent = end;
                    totalItems.textContent = filteredCount;
                    
                    // Show only the rows for current page
                    filteredRows.forEach((row, index) => {
                        const rowIndex = index + 1; // 1-based index
                        if (rowIndex >= start && rowIndex <= end) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                    
                    // Update pagination buttons
                    const maxPage = Math.ceil(filteredCount / itemsPerPage) || 1; // At least 1 page
                    
                    // Update prev/next button states
                    if (currentPage <= 1) {
                        prevPageBtn.classList.add('disabled');
                    } else {
                        prevPageBtn.classList.remove('disabled');
                    }
                    
                    if (currentPage >= maxPage) {
                        nextPageBtn.classList.add('disabled');
                    } else {
                        nextPageBtn.classList.remove('disabled');
                    }
                    
                    // Update page numbers
                    pageNumbersContainer.innerHTML = '';
                    
                    // Determine which page numbers to show
                    let startPage = Math.max(1, currentPage - 1);
                    let endPage = Math.min(maxPage, startPage + 2);
                    
                    // Adjust if we're at the end
                    if (endPage - startPage < 2) {
                        startPage = Math.max(1, endPage - 2);
                    }
                    
                    // Create page number elements
                    for (let i = startPage; i <= endPage; i++) {
                        const pageItem = document.createElement('div');
                        pageItem.className = 'page-item' + (i === currentPage ? ' active' : '');
                        pageItem.textContent = i;
                        pageItem.addEventListener('click', function() {
                            currentPage = i;
                            updatePagination();
                        });
                        pageNumbersContainer.appendChild(pageItem);
                    }
                    
                    // Add dots and last page if needed
                    if (endPage < maxPage) {
                        if (endPage < maxPage - 1) {
                            const dots = document.createElement('div');
                            dots.className = 'page-item page-dots';
                            dots.textContent = '...';
                            pageNumbersContainer.appendChild(dots);
                        }
                        
                        const lastPage = document.createElement('div');
                        lastPage.className = 'page-item';
                        lastPage.textContent = maxPage;
                        lastPage.addEventListener('click', function() {
                            currentPage = maxPage;
                            updatePagination();
                        });
                        pageNumbersContainer.appendChild(lastPage);
                    }
                }

                // Initialize with all rows
                document.addEventListener('DOMContentLoaded', function() {
                    // Set total customers
                    document.getElementById('totalCustomers').textContent = '<%= totalCustomers %>';
                    
                    // With this code that calculates new customers this month:
                    const today = new Date();
                    const newCustomersThisMonth = Array.from(document.querySelectorAll('#customersTable tbody tr')).filter(row => {
                        if (row.cells.length < 7) return false; // Skip rows without enough cells
                        const registrationDate = new Date(row.cells[6].textContent); // Registration date is in column 7
                        return registrationDate.getMonth() === today.getMonth() && 
                               registrationDate.getFullYear() === today.getFullYear();
                    }).length;

                    document.getElementById('newCustomers').textContent = newCustomersThisMonth;
                    document.getElementById('newCustomers').textContent = '<%= newCustomersThisMonth %>';
                    document.getElementById('avgOrderValue').textContent = 'RM ' + <%= String.format("%.2f", avgOrderValue) %>;
                    
                    // Initialize filtered rows with all rows
                    for (let i = 1; i < rows.length; i++) {
                        filteredRows.push(rows[i]);
                    }
                    
                    // Initial pagination
                    updatePagination();
                    
                    // Event listeners for filters
                    searchInput.addEventListener('keyup', applyFilters);
                    genderFilter.addEventListener('change', applyFilters);
                    sortSelect.addEventListener('change', applyFilters);
                    
                    // Handle items per page change
                    itemsPerPageSelect.addEventListener('change', function() {
                        itemsPerPage = parseInt(this.value);
                        currentPage = 1; // Reset to first page
                        updatePagination();
                    });
                    
                    // Handle previous page click
                    prevPageBtn.addEventListener('click', function() {
                        if (currentPage > 1) {
                            currentPage--;
                            updatePagination();
                        }
                    });
                    
                    // Handle next page click
                    nextPageBtn.addEventListener('click', function() {
                        const maxPage = Math.ceil(filteredRows.length / itemsPerPage);
                        if (currentPage < maxPage) {
                            currentPage++;
                            updatePagination();
                        }
                    });
                });
        // Update dashboard stats
        document.addEventListener('DOMContentLoaded', function() {
            // Set total customers
            document.getElementById('totalCustomers').textContent = '<%= totalCustomers %>';
            
            // Simple search functionality
            const searchInput = document.getElementById('customerSearch');
            const table = document.getElementById('customersTable');
            const rows = table.getElementsByTagName('tr');
            
            searchInput.addEventListener('keyup', function() {
                const query = searchInput.value.toLowerCase();
                
                // Start from index 1 to skip the header row
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
            });
            
            // Filter by gender
            const genderFilter = document.getElementById('gender');
            genderFilter.addEventListener('change', function() {
                const genderValue = genderFilter.value.toLowerCase();
                if (genderValue === '') {
                    // Show all rows if no filter
                    for (let i = 1; i < rows.length; i++) {
                        rows[i].style.display = '';
                    }
                    return;
                }
                
                for (let i = 1; i < rows.length; i++) {
                    const row = rows[i];
                    const genderCell = row.getElementsByTagName('td')[5]; // Gender is at index 5
                    if (genderCell) {
                        // Check if the first letter matches our filter value
                        const gender = genderCell.textContent.charAt(0).toLowerCase();
                        row.style.display = gender === genderValue ? '' : 'none';
                    }
                }
            });
            
            // Enhanced sorting functionality
            const sortSelect = document.getElementById('sort');
            sortSelect.addEventListener('change', function() {
                const sortValue = sortSelect.value;
                if (sortValue === '') {
                    return; // No sorting selected
                }
                
                const tbody = document.querySelector('#customersTable tbody');
                const rows = Array.from(tbody.querySelectorAll('tr'));
                
                // Sort the rows based on the selected option
                rows.sort((a, b) => {
                    if (sortValue === 'name_asc') {
                        return a.cells[1].textContent.localeCompare(b.cells[1].textContent);
                    } else if (sortValue === 'name_desc') {
                        return b.cells[1].textContent.localeCompare(a.cells[1].textContent);
                    } else if (sortValue === 'date_asc') {
                        return new Date(a.cells[6].textContent) - new Date(b.cells[6].textContent);
                    } else if (sortValue === 'date_desc') {
                        return new Date(b.cells[6].textContent) - new Date(a.cells[6].textContent);
                    }
                    return 0;
                });
                
                // Remove all existing rows
                rows.forEach(row => tbody.removeChild(row));
                
                // Add sorted rows back
                rows.forEach(row => tbody.appendChild(row));
            });
        });
    </script>
</body>
</html>