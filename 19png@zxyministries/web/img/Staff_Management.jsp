<%@ page import="java.util.*" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="da.staffpro" %>
<%@ page import="da.StaffDisplayHelper" %>
<%@ page import="domain.staffprofile" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management</title>
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
        
        // Initialize staff data at the beginning
        StaffDisplayHelper staffDisplay = new StaffDisplayHelper();
        List<staffprofile> staffList = staffDisplay.getAllStaff();
        int totalStaff = 0;
        
        if (staffList != null && !staffList.isEmpty()) {
            totalStaff = staffList.size();
        }
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-user-tie"></i>
                    <h1>Staff Management</h1>
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
            
            <!-- Staff Stats Cards -->
            <div class="dashboard-cards">
                <div class="card">
                    <h2>Total Staff</h2>
                    <div class="card-content">
                        <div class="card-value" id="totalStaff">0</div>
                        <i class="fas fa-user-tie card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Staff Roles</h2>
                    <div class="card-content">
                        <div class="card-value" id="staffRoles">0</div>
                        <i class="fas fa-users-cog card-icon"></i>
                    </div>
                </div>
            </div>
            
            <!-- Staff Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Staff List</h2>
                    <div class="header-actions">
                        <div class="search-box">
                            <input type="text" placeholder="Search staff..." id="staffSearch">
                            <button><i class="fas fa-search"></i></button>
                        </div>
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
                            <optgroup label="Role">
                                <option value="role_asc">Role (A-Z)</option>
                                <option value="role_desc">Role (Z-A)</option>
                            </optgroup>
                        </select>
                        
                    </div>
                    
                    <div class="filter-group">
                        <label for="role">Role:</label>
                        <select class="filter-select" id="role">
                            <option value="">All Roles</option>
                            <% 
                                // Get unique roles from the staff list
                                Set<String> uniqueRoles = new HashSet<String>();
                                if (staffList != null) {
                                    for (staffprofile staff : staffList) {
                                        if (staff.getRole() != null && !staff.getRole().trim().isEmpty()) {
                                            uniqueRoles.add(staff.getRole());
                                        }
                                    }
                                }
                                
                                // Sort roles alphabetically
                                List<String> sortedRoles = new ArrayList<String>(uniqueRoles);
                                Collections.sort(sortedRoles);
                                
                                // Generate options for each unique role
                                for (String role : sortedRoles) {
                            %>
                                <option value="<%= role.toLowerCase() %>"><%= role %></option>
                            <% } %>
                        </select>
                    </div>
                    <a href="AddStaff.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add Staff
                    </a>
                </div>
                
                <div class="table-responsive">
                    <table class="products-table" id="staffTable">
                        <thead>
                            <tr>
                                <th>Staff ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone Number</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // StaffDisplayHelper staffDisplay = new StaffDisplayHelper(); -- REMOVE THIS LINE
                                // List<staffprofile> staffList = staffDisplay.getAllStaff(); -- REMOVE THIS LINE
                                // int totalStaff = 0; -- REMOVE THIS LINE
                                
                                if (staffList != null && !staffList.isEmpty()) {
                                    // totalStaff = staffList.size(); -- REMOVE THIS LINE
                                    for (staffprofile staff : staffList) {
                            %>
                                <tr>
                                    <td><%= staff.getStaffId() %></td>
                                    <td><%= staff.getStaffName() %></td>
                                    <td><%= staff.getStaffEmail() %></td>
                                    <td><%= staff.getStaffPhone() %></td>
                                    <td><%= staff.getRole() %></td>
                                    <td>
                                        <div class="actions">
                                            <a href="StaffDetails.jsp?id=<%= staff.getStaffId() %>" class="action-btn view-btn">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr><td colspan="6" class="text-center">No staff data found.</td></tr>
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
            Showing <span id="showing-start">1</span> to <span id="showing-end">10</span> of <span id="total-items"><%= totalStaff %></span> staff
        </div>
        <div class="pagination">
            <div class="page-item" id="prev-page" title="Previous Page"><i class="fas fa-angle-left"></i></div>
            <div class="page-numbers-container" id="page-numbers">
                <div class="page-item active">1</div>
                <div class="page-item">2</div>
                <div class="page-item">3</div>
                <% if (Math.ceil(totalStaff / 10.0) > 3) { %>
                    <div class="page-item page-dots">...</div>
                    <div class="page-item"><%= Math.ceil(totalStaff / 10.0) %></div>
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
        const searchInput = document.getElementById('staffSearch');
        const roleFilter = document.getElementById('role');
        const sortSelect = document.getElementById('sort');
        const table = document.getElementById('staffTable');
        const rows = table.getElementsByTagName('tr');

        let currentPage = 1;
        let itemsPerPage = 10;
        const totalRows = <%= totalStaff %>;
        let filteredRows = [];

        // Apply all filters and update visible rows
        function applyFilters() {
            // Get filter values
            const searchQuery = searchInput.value.toLowerCase();
            const roleValue = roleFilter.value.toLowerCase();
            const sortValue = sortSelect.value;
            
            // Reset filtered rows
            filteredRows = [];
            
            // Apply search and role filters
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                let matchesSearch = false;
                let matchesRole = true; // Default to true if no role filter
                
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
                
                // Check role match
                if (roleValue && roleValue !== '') {
                    const roleCell = cells[4]; // Role is at index 4
                    if (roleCell) {
                        const role = roleCell.textContent.toLowerCase();
                        matchesRole = (role === roleValue);
                    }
                }
                
                // If row matches all filters, add to filtered rows
                if (matchesSearch && matchesRole) {
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
                    } else if (sortValue === 'role_asc') {
                        return a.cells[4].textContent.localeCompare(b.cells[4].textContent);
                    } else if (sortValue === 'role_desc') {
                        return b.cells[4].textContent.localeCompare(a.cells[4].textContent);
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
            // Set total staff
            document.getElementById('totalStaff').textContent = '<%= totalStaff %>';
            
            // Count unique roles
            const roles = new Set();
            Array.from(document.querySelectorAll('#staffTable tbody tr')).forEach(row => {
                if (row.cells.length > 4) {
                    roles.add(row.cells[4].textContent.trim());
                }
            });
            document.getElementById('staffRoles').textContent = roles.size;
            
            // Initialize filtered rows with all rows
            for (let i = 1; i < rows.length; i++) {
                filteredRows.push(rows[i]);
            }
            
            // Set up event listeners
            prevPageBtn.addEventListener('click', function() {
                if (currentPage > 1) {
                    currentPage--;
                    updatePagination();
                }
            });
            
            nextPageBtn.addEventListener('click', function() {
                const maxPage = Math.ceil(filteredRows.length / itemsPerPage);
                if (currentPage < maxPage) {
                    currentPage++;
                    updatePagination();
                }
            });
            
            itemsPerPageSelect.addEventListener('change', function() {
                itemsPerPage = parseInt(this.value);
                currentPage = 1; // Reset to first page
                updatePagination();
            });
            
            searchInput.addEventListener('input', applyFilters);
            roleFilter.addEventListener('change', applyFilters);
            sortSelect.addEventListener('change', applyFilters);
            
            // Initial pagination update
            updatePagination();
        });
    </script>
</body>
</html>