<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="domain.Products"%>
<%@page import="domain.DashboardMetrics"%>
<%@page import="domain.TopSellingProduct"%>
<%@page import="da.DashboardDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Reports</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="./css/Product_Admin.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%
        // Check if user is logged in
        if (session.getAttribute("managerId") == null) {
            response.sendRedirect("Login_mgn.jsp");
            return;
        }
        
        // Initialize the DAO and get dashboard metrics
        DashboardDAO dashboardDAO = new DashboardDAO();
        DashboardMetrics metrics = dashboardDAO.getDashboardMetrics();
        
        // Get top selling products
        List<TopSellingProduct> topProducts = dashboardDAO.getTopSellingProducts(10);
        
        // Get monthly sales data for chart
        Map<String, Double> monthlySales = dashboardDAO.getMonthlySalesData();
        
        // Close the database connection
        dashboardDAO.closeConnection();
    %>
    
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-chart-bar"></i>
                    <h1>Sales Reports</h1>
                </div>
                <div class="user-area">
                    <div class="user-profile">
                        <div class="user-avatar">M</div>
                        <span><%= session.getAttribute("managerName") != null ? session.getAttribute("managerName") : "Manager" %></span>
                    </div>
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
            
            <!-- Dashboard Cards -->
            <div class="dashboard-cards">
                <div class="card">
                    <h2>Total Products</h2>
                    <div class="card-content">
                        <div class="card-value"><%= metrics.getTotalProducts() %></div>
                        <i class="fas fa-box card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Total Revenue</h2>
                    <div class="card-content">
                        <div class="card-value">RM <%= String.format("%.2f", metrics.getTotalRevenue()) %></div>
                        <i class="fas fa-dollar-sign card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Total Orders</h2>
                    <div class="card-content">
                        <div class="card-value"><%= metrics.getTotalOrders() %></div>
                        <i class="fas fa-shopping-cart card-icon"></i>
                    </div>
                </div>
                <div class="card">
                    <h2>Low Stock Items</h2>
                    <div class="card-content">
                        <div class="card-value"><%= metrics.getLowStockCount() %></div>
                        <i class="fas fa-exclamation-triangle card-icon"></i>
                    </div>
                </div>
            </div>

            <!-- Sales Trends Chart -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Sales Trends</h2>
                </div>
                <div style="height: 300px;">
                    <canvas id="salesTrendsChart"></canvas>
                </div>
            </div>

            <!-- Top Selling Products Section -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Top 10 Selling Products</h2>
                    <button id="export-btn" class="btn btn-primary">
                        <i class="fas fa-download"></i> Export Report
                    </button>
                </div>
                <div class="table-responsive">
                    <table class="products-table" id="top-products-table">
                        <thead>
                            <tr>
                                <th>Rank</th>
                                <th>Product ID</th>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Units Sold</th>
                                <th>Revenue (RM)</th>
                                <th>% of Total Sales</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (topProducts != null && !topProducts.isEmpty()) { 
                                  double totalRevenue = metrics.getTotalRevenue();
                                  int rank = 1;
                                  for (TopSellingProduct product : topProducts) { 
                                      double percentOfSales = (product.getRevenue() / totalRevenue) * 100;
                            %>
                            <tr>
                                <td><%= rank++ %></td>
                                <td><%= product.getProductId() %></td>
                                <td><%= product.getProductName() %></td>
                                <td><%= product.getCategory() %></td>
                                <td><%= product.getUnitsSold() %></td>
                                <td>RM <%= String.format("%.2f", product.getRevenue()) %></td>
                                <td><%= String.format("%.2f", percentOfSales) %>%</td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td colspan="7" class="text-center">No product sales data available</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Product Sales Chart -->
            <div class="products-section">
                <div class="section-header">
                    <h2 class="section-title">Top Products Visualization</h2>
                </div>
                <div style="height: 400px;">
                    <canvas id="topProductsChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2023 Beauty & Skincare Products. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript for Charts -->
    <script>
        // Sales Trends Chart
        const salesCtx = document.getElementById('salesTrendsChart').getContext('2d');
        const salesLabels = [<% 
            boolean first = true;
            for (String month : monthlySales.keySet()) {
                if (!first) out.print(", ");
                out.print("'" + month + "'");
                first = false;
            }
        %>];
        
        const salesData = [<% 
            first = true;
            for (Double value : monthlySales.values()) {
                if (!first) out.print(", ");
                out.print(value);
                first = false;
            }
        %>];
        
        new Chart(salesCtx, {
            type: 'line',
            data: {
                labels: salesLabels,
                datasets: [{
                    label: 'Sales (RM)',
                    data: salesData,
                    backgroundColor: 'rgba(26, 93, 66, 0.2)',
                    borderColor: 'rgba(26, 93, 66, 1)',
                    borderWidth: 2,
                    pointBackgroundColor: 'rgba(26, 93, 66, 1)',
                    pointBorderColor: '#fff',
                    pointRadius: 4,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return 'RM ' + value;
                            }
                        }
                    }
                }
            }
        });

        // Top Products Chart
        const productsCtx = document.getElementById('topProductsChart').getContext('2d');
        const productLabels = [<% 
            first = true;
            if (topProducts != null && !topProducts.isEmpty()) {
                for (TopSellingProduct product : topProducts) {
                    if (!first) out.print(", ");
                    out.print("'" + product.getProductName() + "'");
                    first = false;
                }
            }
        %>];
        
        const productData = [<% 
            first = true;
            if (topProducts != null && !topProducts.isEmpty()) {
                for (TopSellingProduct product : topProducts) {
                    if (!first) out.print(", ");
                    out.print(product.getUnitsSold());
                    first = false;
                }
            }
        %>];

        const revenueData = [<% 
            first = true;
            if (topProducts != null && !topProducts.isEmpty()) {
                for (TopSellingProduct product : topProducts) {
                    if (!first) out.print(", ");
                    out.print(product.getRevenue());
                    first = false;
                }
            }
        %>];
        
        new Chart(productsCtx, {
            type: 'bar',
            data: {
                labels: productLabels,
                datasets: [
                    {
                        label: 'Units Sold',
                        data: productData,
                        backgroundColor: 'rgba(54, 162, 235, 0.7)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1,
                        yAxisID: 'y'
                    },
                    {
                        label: 'Revenue (RM)',
                        data: revenueData,
                        backgroundColor: 'rgba(255, 99, 132, 0.7)',
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 1,
                        type: 'line',
                        yAxisID: 'y1'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        position: 'left',
                        title: {
                            display: true,
                            text: 'Units Sold'
                        }
                    },
                    y1: {
                        beginAtZero: true,
                        position: 'right',
                        title: {
                            display: true,
                            text: 'Revenue (RM)'
                        },
                        grid: {
                            drawOnChartArea: false
                        }
                    }
                }
            }
        });

        // Export functionality
        document.getElementById('export-btn').addEventListener('click', function() {
            // Create a CSV string
            let csvContent = "data:text/csv;charset=utf-8,";
            csvContent += "Rank,Product ID,Product Name,Category,Units Sold,Revenue (RM),% of Total Sales\n";
            
            const table = document.getElementById('top-products-table');
            const rows = table.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length > 1) { // Skip empty rows
                    let rowData = [];
                    cells.forEach(cell => {
                        // Remove currency symbol and clean data
                        let data = cell.textContent.replace('RM ', '');
                        rowData.push('"' + data + '"');
                    });
                    csvContent += rowData.join(',') + "\n";
                }
            });
            
            // Create download link
            const encodedUri = encodeURI(csvContent);
            const link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", "top_products_report.csv");
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });

        // Time period filter
        document.getElementById('time-period').addEventListener('change', function() {
            // In a real implementation, this would reload data based on the selected time period
            alert('This would filter data for: ' + this.value);
            // You would typically make an AJAX call here to get new data
        });

        // Chart type selector
        document.getElementById('chart-type').addEventListener('change', function() {
            // In a real implementation, this would change the chart data based on selection
            alert('This would change chart to: ' + this.value);
            // You would typically make an AJAX call here to get new data
        });
    </script>
</body>
</html>
