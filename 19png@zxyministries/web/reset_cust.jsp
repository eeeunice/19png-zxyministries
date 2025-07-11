<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reset Password</title>
  <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
  <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500&family=Abel&family=Playfair+Display&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { min-height: 100vh; background: linear-gradient(to top, #a8edea 0%, #fed6e3 100%); font-family: 'Jost', sans-serif; display: flex; align-items: center; justify-content: center; opacity: 0.95; }
    .overlay { width: 100%; max-width: 450px; min-height: 400px; background: linear-gradient(-225deg, #E3FDF5 50%, #FFE6FA 50%); box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1); border-radius: 10px; padding: 40px 30px; }
    .overlay form .con { display: flex; flex-direction: column; align-items: center; gap: 20px; }
    .overlay header { text-align: center; margin-bottom: 20px; }
    .overlay header h2 { font-family: 'Playfair Display', serif; font-size: 2.3em; color: #3e403f; }
    .overlay header p { letter-spacing: 0.05em; color: #5E6472; }
    .input-group { width: 100%; display: flex; align-items: center; background: #fff; border-radius: 8px; padding: 10px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1); }
    .input-item { margin-right: 10px; font-size: 1.2em; color: #6d44b8; }
    .form-input { flex: 1; border: none; outline: none; font-size: 1em; background: transparent; color: #5E6472; }
    .form-input::placeholder { color: #aaa; }
    .log-in { width: 100%; height: 50px; background: #6d44b8; border: none; border-radius: 8px; color: white; font-weight: bold; font-size: 1.1em; cursor: pointer; }
    .log-in:hover { background: #573b8a; }
    .back-link { margin-top: 15px; font-size: 0.95em; color: #6d44b8; text-decoration: none; }
    .back-link:hover { color: #573b8a; }
    .message { color: #28a745; font-size: 0.9em; text-align: center; }
    .error-message { color: #ff3860; font-size: 0.9em; text-align: center; }
  </style>
</head>
<body>
  <div class="overlay">
    <form action="${pageContext.request.contextPath}/CustomerResetServlets" method="post">
      <div class="con">
        <header class="head-form">
          <h2>Reset Password</h2>
          <p>Enter your email and new password</p>
        </header>
        <div class="message">
          <%= (request.getAttribute("successMessage") != null) ? request.getAttribute("successMessage").toString() : "" %>
        </div>
        <div class="error-message">
          <%= (request.getAttribute("errorMessage") != null) ? request.getAttribute("errorMessage").toString() : "" %>
        </div>
        <div class="input-group">
          <span class="input-item"><i class="fa fa-lock"></i></span>
          <input class="form-input" type="password" name="newPassword" placeholder="New Password" required>
        </div>
        <div class="input-group">
          <span class="input-item"><i class="fa fa-lock"></i></span>
          <input class="form-input" type="password" name="confirmPassword" placeholder="Confirm Password" required>
        </div>
        <button class="log-in" type="submit">Reset Password</button>
        <a class="back-link" href="Login_cust.jsp"><i class="fa fa-arrow-left"></i> Back to Login</a>
      </div>
    </form>
  </div>
</body>
</html>