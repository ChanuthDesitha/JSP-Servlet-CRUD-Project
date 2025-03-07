<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Add User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #f4f4f4, #ddd);
            text-align: center;
            padding: 50px;
            margin: 0;
        }

        h2 {
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }

        form {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            display: inline-block;
            text-align: left;
            max-width: 400px;
            width: 100%;
        }

        input, number {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 8px 0 2px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        input:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }

        button {
            background: #28a745;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 18px;
            width: 100%;
            transition: 0.3s;
            margin-top: 15px;
        }

        button:hover {
            background: #218838;
            transform: scale(1.05);
        }

        .back-link {
            display: block;
            margin-top: 15px;
            text-decoration: none;
            color: #007bff;
            font-size: 16px;
            transition: 0.3s;
        }

        .back-link:hover {
            text-decoration: underline;
            color: #0056b3;
        }

        .error {
            color: red;
            font-size: 13px;
            margin-top: -5px;
            margin-bottom: 10px;
            display: block;
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
    </style>

    <script>
        function validateForm() {
            document.querySelectorAll('.error').forEach(e => e.innerText = '');

            let isValid = true;

            let name = document.forms["userForm"]["name"].value.trim();
            let email = document.forms["userForm"]["email"].value.trim();
            let password = document.forms["userForm"]["password"].value.trim();
            let confirmPassword = document.forms["userForm"]["confirmPassword"].value.trim();
            let mobile = document.forms["userForm"]["mobile"].value.trim();
            let photo = document.forms["userForm"]["photo"].value.trim();

            if (name === "") {
                document.getElementById('nameError').innerText = "Enter User Name.";
                isValid = false;
            } else if (name.length > 15) {
                document.getElementById('nameError').innerText = "User Name cannot exceed 15 characters.";
                isValid = false;
            } else if (/\s/.test(name)) {
                document.getElementById('nameError').innerText = "User Name cannot contain spaces.";
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
                } else if (email.includes(" ")) {
                    document.getElementById('emailError').innerText = "Email cannot contain spaces.";
                    isValid = false;
                } else if (email.length > 50) {
                    document.getElementById('emailError').innerText = "Email must be less than 50 characters.";
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

</head>
<body>
<div class="container">
    <form name="userForm" action="adduser" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
        <h2>Register User</h2>

        <input type="text" name="name" placeholder="UserName" maxlength="15"
               oninput="this.value = this.value.replace(/\s/g, '')"><br>
        <span class="error" id="nameError"></span><br>

        <input type="text" name="email" id="email" placeholder="Email" maxlength="25" oninput="this.value = this.value.replace(/\s/g, '')"><br>
        <span class="error" id="emailError">
            <%= request.getParameter("error") != null && request.getParameter("error").equals("email_taken") ? "This email is already taken. Please choose a different one." : "" %>
        </span><br>

        <input type="password" name="password" id="password" placeholder="Password" maxlength="6"
               oninput="this.value = this.value.replace(/\s/g, '')"><br>
        <span class="error" id="passwordError"></span><br>

        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password" maxlength="6"
               oninput="this.value = this.value.replace(/\s/g, '')"><br>
        <span class="error" id="confirmPasswordError"></span><br>


        <input type="text" name="mobile" id="mobile" placeholder="Mobile Number" maxlength="12"
               oninput="this.value=this.value.replace(/[^0-9]/g,'')">
        <span class="error" id="mobileError"></span>

        <p style="text-align: center;">Example Profile Photo</p>
        <img id="photoPreview" src="img/default-image.jpg" alt="Profile Photo"
             style="width:75px;height:75px;border-radius:50%;object-fit:cover;border:1px solid #ccc;margin-bottom:10px;display:block;margin-left:auto;margin-right:auto;">

        <input type="file" name="photo" accept=".jpg, .jpeg, .png" onchange="validatePhoto()"><br>
        <span class="error" id="photoError"></span>

        <button type="submit">Add</button>

        <a href="login.jsp" class="back-link">Back to Login</a>
    </form>
</div>
</body>
</html>