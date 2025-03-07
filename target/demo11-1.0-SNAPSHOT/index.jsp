<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
  <title>Home</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #b3d4f5;
      text-align: center;
      margin: 50px;
    }

    h2 {
      color: #333;
      margin-bottom: 20px;
      font-size: 26px;
      font-weight: bold;
    }

    .container {
      max-width: 500px;
      margin: auto;
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
      transition: transform 0.3s ease-in-out;
    }

    label {
      display: block;
      text-align: left;
      font-weight: bold;
      margin: 10px 0 5px;
      color: #444;
    }

    input[type="text"],
    input[type="email"],
    input[type="password"],
    input[type="file"] {
      width: 100%;
      padding: 12px;
      border: 2px solid #ddd;
      border-radius: 6px;
      font-size: 16px;
      transition: border 0.3s ease-in-out;
    }

    input:focus {
      border: 2px solid #007bff;
      outline: none;
      box-shadow: 0px 0px 8px rgba(0, 123, 255, 0.4);
    }

    button {
      width: 100%;
      padding: 12px;
      font-size: 18px;
      background: linear-gradient(135deg, #28a745, #ffdd57);
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background 0.3s ease-in-out, transform 0.2s;
      margin-top: 15px;
    }

    button:active {
      transform: translateY(1px);
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Welcome to User Management System</h2>
  <form action="login.jsp" method="GET">
    <button type="submit"> Login </button>
  </form>
</div>
</body>
</html>