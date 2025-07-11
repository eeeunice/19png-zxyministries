<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Forgot Password</title>
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
      font-family: 'Jost', sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0.95;
    }

    .overlay {
      width: 100%;
      max-width: 450px;
      min-height: 400px;
      background: linear-gradient(-225deg, #E3FDF5 50%, #FFE6FA 50%);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
      border-radius: 10px;
      padding: 40px 30px;
      transition: 0.3s ease;
    }

    .overlay form .con {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 20px;
    }

    .overlay header {
      text-align: center;
      margin-bottom: 20px;
    }

    .overlay header h2 {
      font-family: 'Playfair Display', serif;
      font-size: 2.3em;
      color: #3e403f;
    }

    .overlay header p {
      letter-spacing: 0.05em;
      color: #5E6472;
    }

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

    .log-in {
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
    }

    .log-in:hover {
      background: #573b8a;
      transform: translateY(-2px);
    }

    .back-link {
      margin-top: 15px;
      font-size: 0.95em;
      color: #6d44b8;
      text-decoration: none;
      transition: color 0.2s ease;
    }

    .back-link:hover {
      color: #573b8a;
    }

    .message {
      color: #28a745;
      font-size: 0.9em;
      text-align: center;
    }

    .error-message {
      color: #ff3860;
      font-size: 0.9em;
      text-align: center;
    }
  </style>

</head>
<body>

  <div class="overlay">
    <form action="ForgetMgnServlet" method="post">
      <div class="con">
        <header class="head-form">
          <h2>Forgot Password</h2>
          <p>Enter your email to receive reset instructions</p>
        </header>

        <!-- Success or error messages -->
        <div class="message">
          <%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %>
        </div>
        <div class="error-message">
          <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
        </div>

        <div class="input-group">
          <span class="input-item"><i class="fa fa-envelope"></i></span>
          <input class="form-input" type="email" name="email" placeholder="Your Email" required>
        </div>

        <button class="log-in" type="submit">Reset Password</button>

        <a class="back-link" href="Login_mgn.jsp"><i class="fa fa-arrow-left"></i> Back to Login</a>
      </div>
    </form>
  </div>

</body>
</html>
