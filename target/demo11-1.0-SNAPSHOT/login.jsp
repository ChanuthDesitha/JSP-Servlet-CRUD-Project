<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <style>
    body {
      background-color: #f4f4f4;
    }
    .login-container {
      max-width: 400px;
      margin: 100px auto;
      padding: 20px;
      background: #fff;
      border-radius: 10px;
      box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    }
    .error {
      color: red;
      font-size: 14px;
    }
  </style>
</head>
<body>

<div class="container">
  <div class="login-container">
    <h3 class="text-center">Login</h3>

    <!-- Display error message if login fails -->
    <%
      String error = request.getParameter("error");
      if ("invalid".equals(error)) {
    %>
    <p class="error text-center">Invalid email or password. Please try again.</p>
    <% } %>

    <form action="login" method="post" onsubmit="return validateForm()">
      <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="email" id="email" name="email" class="form-control" required>
      </div>

      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input type="password" id="password" name="password" class="form-control" required>
      </div>

      <button type="submit" class="btn btn-primary w-100">Login</button>
    </form>

    <p class="mt-3 text-center">Don't have an account? <a href="adduser.jsp">Register here</a></p>
  </div>
</div>

<script>
  function validateForm() {
    var email = document.getElementById("email").value.trim();
    var password = document.getElementById("password").value.trim();
    if (email === "" || password === "") {
      alert("Both fields are required.");
      return false;
    }
    return true;
  }
</script>

</body>
</html>
