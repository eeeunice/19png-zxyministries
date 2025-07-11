<%@page import="java.util.List"%>
<%@page import="domain.Contact"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Contact Management</title>
        <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

        <link href="./css/Product_Admin.css" rel="stylesheet">
        <style>

            h1 {
                color: #333;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            table, th, td {
                border: 1px solid #ccc;
            }

            th, td {
                padding: 12px;
                text-align: left;
            }

            form {
                margin-top: 20px;
            }

            .btn {
                padding: 8px 14px;
                text-decoration: none;
                background-color: #1a5d42;
                color: white;
                border-radius: 4px;
                margin-right: 5px;
                border: none;
                cursor: pointer;
                width: 140px;
                display: inline-block;
                text-align: center;
            }

            .btn:hover {
                background-color: #1b8f52;
            }

            input[type="text"] {
                padding: 8px;
                width: 200px;
                margin-right: 10px;
            }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="container">
                <div class="header-content">
                    <div class="logo">
                        <i class="fas fa-boxes"></i>
                        <h1>Contact Us</h1>
                    </div>
                    <div class="user-area">
                        <a href="staffProfile.jsp?id=<%= session.getAttribute("staffId")%>" class="user-profile-link">
                            <div class="user-profile">
                                <div class="user-avatar">S</div>
                                <span><%= session.getAttribute("staffName") != null ? session.getAttribute("staffName") : "Staff"%></span>
                                <i class="fas fa-user-cog profile-icon"></i>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <%
            String message = (String) request.getAttribute("message");
            String managerId = (String) session.getAttribute("managerId");  // Retrieve session managerId
            String staffId = (String) session.getAttribute("staffId");      // Retrieve session staffId
        %>

        <% if (message != null) {%>
        <p style="color: green;"><%= message%></p>
        <% } %>

        <!-- Search Form -->
        <form action="adminContact" method="post">
            <label for="searchId">Search by Contact ID:</label>
            <input type="text" id="searchId" name="searchId" placeholder="e.g. C001" />
            <button type="submit" class="btn">Search</button>
        </form>

        <%
            List<Contact> contacts = (List<Contact>) request.getAttribute("contacts");
            if (contacts != null && !contacts.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>

        <table>
            <tr>
                <th>Contact ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Description</th>
                <th>Status</th>
                <th>Last Updated</th>
                <th>Done By</th> <!-- New Column for Manager/Staff ID -->
                <th>Actions</th>
            </tr>
            <%
                for (Contact c : contacts) {
            %>
            <tr>
                <td><%= c.getContactusId()%></td>
                <td><%= c.getName()%></td>
                <td><%= c.getEmail()%></td>
                <td><%= c.getPhoneNumber()%></td>
                <td><%= c.getDescription()%></td>
                <td><%= c.getStatus()%></td>
                <td><%= (c.getCurrentUpdate() != null) ? sdf.format(c.getCurrentUpdate()) : "N/A"%></td>
                <td>
                    <%
                        // Display the assigned manager or staff ID if the task is complete
                        if ("Complete".equalsIgnoreCase(c.getStatus())) {
                            String assignedUser = (c.getManagerId() != null) ? c.getManagerId() : c.getStaffId();
                            out.print(assignedUser);
                        } else {
                            out.print("Pending");
                        }
                    %>
                </td>
                <td>
                    <% if (!"Complete".equalsIgnoreCase(c.getStatus())) {%>
                    <form action="adminContact" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" value="<%= c.getContactusId()%>" />
                        <button type="submit" class="btn">Complete</button>
                    </form>
                    <% }%>
                    <form action="adminContact" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this record?');">
                        <input type="hidden" name="action" value="delete" />
                        <input type="hidden" name="id" value="<%= c.getContactusId()%>" />
                        <button type="submit" class="btn">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <%
        } else {
            String searchId = request.getParameter("searchId");
            if (searchId != null && !searchId.isEmpty()) {
        %>
        <p style="color: red;">No record found with ID "<%= searchId%>".</p>
        <%
        } else {
        %>
        <p>No contact records found.</p>
        <%
                }
            }
        %>

    </body>
</html>
