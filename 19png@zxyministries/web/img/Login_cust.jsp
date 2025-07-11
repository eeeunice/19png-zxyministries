<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Overlay Login Form</title>
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
      max-width: 450px;
      min-height: 520px;
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
      gap: 20px;
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

    /* Eye icon */
    #eye {
      font-size: 1.1em;
      color: #aaa;
      margin-left: 8px;
      pointer-events: none; /* 禁止点击 */
    }

    /* Login button */
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

    /* Other buttons */
    .other {
      margin-top: 20px;
      display: flex;
      justify-content: space-between;
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
    
    /* 错误消息样式 */
    .error-message {
      color: #ff3860;
      font-size: 0.9em;
      margin-bottom: 15px;
      text-align: center;
      width: 100%;
    }
    
    .other {
  margin-top: 20px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  width: 100%;
  max-width: 400px; /* 限定整体最大宽度 */
  margin-left: auto;
  margin-right: auto;
}

.btn.submits {
  width: 100%;
  height: 50px;
  background: white;
  border: 2px solid #6d44b8;
  color: #6d44b8;
  border-radius: 10px;
  font-weight: 600;
  font-size: 0.95em;
  transition: all 0.3s ease;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.05);
  white-space: nowrap; /* 避免文字换行 */
}

.btn.submits:hover {
  background: #6d44b8;
  color: white;
  box-shadow: 2px 4px 12px rgba(0, 0, 0, 0.2);
}
.btn.submits {
  min-width: 150px;
}

  </style>

</head>

<body>

  <div class="overlay">
    <form action="LoginServlet" method="post">
      <div class="con">
        <header class="head-form">
          <h2>Log In</h2>
          <p>Login here using your Email and password</p>
        </header>

        <!-- Display error message if login fails -->
        <div class="error-message">
          <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
        </div>

        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-user-circle"></i>
          </span>
          <input class="form-input" id="txt-input" type="text" name="email" placeholder="@Email" required>
        </div>

        <div class="input-group">
          <span class="input-item">
            <i class="fa fa-key"></i>
          </span>
          <input class="form-input" type="password" placeholder="Password" id="pwd" name="password" required>
        </div>

        <button class="log-in" type="submit">Log In</button>

<div class="other">
  <button class="btn submits" type="button" onclick="location.href='forgot_cust.jsp'">
    <i class="fa fa-unlock-alt"></i> Forgot Password
  </button>
  <button class="btn submits" type="button" onclick="location.href='register_cust.jsp'">
    <i class="fa fa-user-plus"></i> Sign Up
  </button>
  <button class="btn submits" type="button" onclick="location.href='Login_mgn.jsp'">
    <i class="fa fa-user-tie"></i> Manager
  </button>
  <button class="btn submits" type="button" onclick="location.href='Login_Staff.jsp'">
    <i class="fa fa-user-gear"></i> Staff
  </button>
</div>
      </div>
    </form>
  </div>

</body>
</html>