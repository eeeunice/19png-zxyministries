<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get the current session without creating a new one if none exists
    HttpSession userSession = request.getSession(false);
    
    // Check if there's a session attribute to determine user type
    String redirectPage = "index.html"; // Default redirect
    
    if (userSession != null) {
        // Determine user type based on session attributes
        if (userSession.getAttribute("customerId") != null) {
            redirectPage = "Login_cust.jsp";
        } else if (userSession.getAttribute("staffId") != null) {
            redirectPage = "Login_Staff.jsp";
        } else if (userSession.getAttribute("managerId") != null) {
            redirectPage = "Login_mgn.jsp";
        }
        
        // Invalidate the session
        userSession.invalidate();
    }
    
    // Redirect to the appropriate login page
    response.sendRedirect(redirectPage);
%>