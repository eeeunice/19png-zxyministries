<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%
    LocalDate today = LocalDate.now();
    String formattedDate = today.toString(); // Format the date as "yyyy-MM-dd"
%>
<!DOCTYPE html>

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Register Account</title>
  <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500&family=Abel&family=Playfair+Display&display=swap" rel="stylesheet">

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      min-height: 100vh;
      background: linear-gradient(to top, #a8edea 0%, #fed6e3 100%);
      background-attachment: fixed;
      background-repeat: no-repeat;
      font-family: 'Jost', sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0.95;
    }

    /* Overlay container */
    .overlay {
      width: 100%;
      max-width: 550px;
      min-height: 700px;
      background: linear-gradient(-225deg, #E3FDF5 50%, #FFE6FA 50%);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
      border-radius: 10px;
      padding: 40px 30px;
      transition: 0.3s ease;
    }

    /* Form content */
    .overlay form .con {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 15px;
    }

    .overlay header {
      text-align: center;
      margin-bottom: 20px;
    }

    .overlay header h2 {
      font-family: 'Playfair Display', serif;
      font-size: 2.5em;
      color: #3e403f;
    }

    .overlay header p {
      letter-spacing: 0.05em;
      color: #5E6472;
    }

    /* Input group */
    .input-group {
      width: 100%;
      display: flex;
      align-items: center;
      background: #fff;
      border-radius: 8px;
      padding: 10px;
      box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
    }

    .input-item {
      margin-right: 10px;
      font-size: 1.2em;
      color: #6d44b8;
    }

    .form-input {
      flex: 1;
      border: none;
      outline: none;
      font-size: 1em;
      background: transparent;
      color: #5E6472;
    }

    .form-input::placeholder {
      color: #aaa;
    }

    /* Register button */
    .register-btn {
      width: 100%;
      height: 50px;
      background: #6d44b8;
      border: none;
      border-radius: 8px;
      color: white;
      font-weight: bold;
      font-size: 1.1em;
      cursor: pointer;
      transition: background 0.3s ease, transform 0.2s ease;
      margin-top: 10px;
    }

    .register-btn:hover {
      background: #573b8a;
      transform: translateY(-2px);
    }

    /* Other buttons */
    .other {
      margin-top: 20px;
      display: flex;
      justify-content: center;
      width: 100%;
    }

    .btn.submits {
      width: 48%;
      height: 45px;
      border: 2px solid #6d44b8;
      background: transparent;
      color: #6d44b8;
      border-radius: 8px;
      font-weight: bold;
      transition: all 0.3s ease;
      cursor: pointer;
    }

    .btn.submits:hover {
      background: #6d44b8;
      color: white;
    }
    
    /* Error message style */
    .error-message {
      color: #ff3860;
      font-size: 0.9em;
      margin-bottom: 15px;
      text-align: center;
      width: 100%;
    }
    
    /* Gender selection style */
    .gender-group {
      width: 100%;
      display: flex;
      justify-content: space-around;
      background: #fff;
      border-radius: 8px;
      padding: 10px;
      box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
    }
    
    .gender-option {
      display: flex;
      align-items: center;
    }
    
    .gender-option label {
      margin-left: 5px;
      color: #5E6472;
    }
  </style>

</head>

<body>

  <div class="overlay">
    <form action="RegisterServlet" method="post">
      <div class="con">
        <header class="head-form">
          <h2>Register Account</h2>
          <p>Create your personal account</p>
        </header>

        <!-- Display error message if registration fails -->
        <div class="error-message">
          <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
        </div>

        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-user"></i>
          </span>
          <input class="form-input" type="text" name="custname" placeholder="Full Name" required>
        </div>

        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-envelope"></i>
          </span>
          <input class="form-input" type="email" name="email" placeholder="Email Address" required>
        </div>
        
        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-user-circle"></i>
          </span>
          <input class="form-input" type="text" name="username" placeholder="Username" required>
        </div>

        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-key"></i>
          </span>
          <input class="form-input" type="password" name="password" placeholder="Password" required>
        </div>
        
        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-key"></i>
          </span>
          <input class="form-input" type="password" name="confirmPassword" placeholder="Confirm Password" required>
        </div>

        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-phone"></i>
          </span>
          <input class="form-input" type="text" name="phonenum" placeholder="Phone Number" required>
        </div>
        
        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-calendar"></i>
          </span>
          <input class="form-input" type="date" name="dateofbirth" placeholder="Date of Birth" required max="<%= formattedDate %>">
        </div>
        
        
        <div class="gender-group">
          <span class="input-item">
            <i class="fa fa-venus-mars"></i>
          </span>
          <div class="gender-option">
            <input type="radio" id="male" name="gender" value="M" required>
            <label for="male">Male</label>
          </div>
          <div class="gender-option">
            <input type="radio" id="female" name="gender" value="F">
            <label for="female">Female</label>
          </div>
        </div>

        <button class="register-btn" type="submit">Register</button>

        <div class="other">
          <button class="btn submits" type="button" onclick="location.href='Login_cust.jsp'">Already have an account? Login</button>
        </div>
      </div>
    </form>
  </div>

</body>
</html>
