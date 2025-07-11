<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Error Page</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
</head>
<body>
    <h1>Internal Server Error</h1>
    <p>Sorry, there was a problem processing your request.</p>
    <p>Error details: <%= exception.getMessage() %></p>
    <a href="index.jsp">Return to Home Page</a>
</body>
</html>