<%@ page import="com.example.demo11.model.User" %>
<%@ page import="com.example.demo11.dao.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int userId = 0;
    if (request.getParameter("id") != null) {
        userId = Integer.parseInt(request.getParameter("id"));
    }
    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserById(userId);

    if (user == null) {
        response.sendRedirect("error.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update User</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }

        form {
            width: 500px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="number"],
        input[type="file"],
        button {
            width: 100%;
            padding: 8px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }

        input[type="file"] {
            padding: 3px;
        }

        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        /* Error message styling */
        .error {
            font-size: 12px;
            color: red;
            display: block;
            margin-top: -8px;
            margin-bottom: 10px;
        }

        form > label,
        form > input {
            margin-bottom: 15px;
        }

        form > button {
            margin-top: 15px;
        }

    </style>
</head>
<body>
<h2>Update User</h2>
<form name="userForm" action="updateUser" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
    <input type="hidden" name="id" value="<%= user.getId() %>">

    <label>Name:</label>
    <input type="text" name="name" id="name" value="<%= user.getName() %>" maxlength="15"
           oninput="this.value = this.value.replace(/\s/g, '')">
    <span id="nameError" class="error" style="color: red;"></span>

    <label>Email:</label>
    <input type="text" name="email" id="email" value="<%= user.getEmail() %>" maxlength="25"
           oninput="this.value = this.value.replace(/\s/g, '')">
    <span id="emailError" class="error" style="color: red;">
    <%= request.getParameter("error") != null && request.getParameter("error").equals("email_taken") ? "This email is already taken. Please choose a different one." : "" %>
</span>

    <label>Password:</label>
    <input type="password" name="password" id="password" placeholder="Enter new password" maxlength="6"
           oninput="this.value = this.value.replace(/\s/g, '')">
    <span id="passwordError" class="error" style="color: red;"></span>

    <label>Confirm Password:</label>
    <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm password" maxlength="6"
           oninput="this.value = this.value.replace(/\s/g, '')">
    <span id="confirmPasswordError" class="error" style="color: red;"></span>


    <label>Mobile:</label>
    <input type="text" name="mobile" value="<%= user.getMobile() %>"
           oninput="this.value=this.value.replace(/[^0-9]/g,'')">
    <span id="mobileError" class="error" style="color: red;"></span>

    <label>Photo:</label>
    <input type="file" name="photo" id="photo" accept=".jpg,.jpeg,.png"><br>

    <button type="submit">Update</button>
</form>

<script>
    function validateForm() {
        document.querySelectorAll('.error').forEach(e => e.innerText = '');

        let isValid = true;

        let name = document.forms["userForm"]["name"].value.trim();
        let email = document.forms["userForm"]["email"].value.trim();
        let password = document.getElementById('password').value.trim();
        let confirmPassword = document.getElementById('confirmPassword').value.trim();
        let mobile = document.forms["userForm"]["mobile"].value.trim();
        let photo = document.forms["userForm"]["photo"].value.trim();

        if (name === "") {
            document.getElementById('nameError').innerText = "Enter User Name.";
            isValid = false;
        } else if (name.length > 15) {
            document.getElementById('nameError').innerText = "User Name cannot exceed 15 characters.";
            isValid = false;
        }

        if (email === "") {
            document.getElementById('emailError').innerText = "Enter Email.";
            isValid = false;
        } else {
            let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                document.getElementById('emailError').innerText = "Please enter a valid email.";
                isValid = false;
            } else if (/\s/.test(email)) {
                document.getElementById('emailError').innerText = "Email cannot contain spaces.";
                isValid = false;
            } else if (email.length > 25) {
                document.getElementById('emailError').innerText = "Email cannot exceed 25 characters.";
                isValid = false;
            }
        }

        if (password === "") {
            document.getElementById('passwordError').innerText = "Enter Password.";
            isValid = false;
        } else if (password.length < 3) {
            document.getElementById('passwordError').innerText = "Password must be at least 3 characters.";
            isValid = false;
        } else if (password.length > 6) {
            document.getElementById('passwordError').innerText = "Password cannot exceed 6 characters.";
            isValid = false;
        } else if (/\s/.test(password)) {
            document.getElementById('passwordError').innerText = "Password cannot contain spaces.";
            isValid = false;
        }

        if (confirmPassword === "") {
            document.getElementById('confirmPasswordError').innerText = "Enter Confirm Password.";
            isValid = false;
        } else if (confirmPassword !== password) {
            document.getElementById('confirmPasswordError').innerText = "Passwords do not match.";
            isValid = false;
        }

        if (mobile === "") {
            document.getElementById('mobileError').innerText = "Enter Mobile Number.";
            isValid = false;
        } else {
            let mobilePattern = /^\d{10,12}$/;
            if (!mobilePattern.test(mobile)) {
                document.getElementById('mobileError').innerText = "Mobile number must be between 10 and 12 digits.";
                isValid = false;
            }
        }

        if (photo !== "") {
            let allowedExtensions = /\.(jpg|jpeg|png)$/i;
            if (!allowedExtensions.test(photo)) {
                document.getElementById('photoError').innerText = "Only JPG, JPEG, or PNG files are allowed.";
                isValid = false;
            }
        }
        return isValid;
    }
</script>

</body>
</html>
