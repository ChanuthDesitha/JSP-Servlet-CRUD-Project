<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.example.demo11.model.User" %>
<%
  if (session.getAttribute("user") == null) {
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
    response.sendRedirect("login.jsp");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>User List</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 40px;
      background-color: #f4f4f4;
      text-align: center;
    }

    h2 {
      color: #333;
      margin-bottom: 20px;
    }

    .container {
      max-width: 800px;
      margin: auto;
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    th, td {
      border: 1px solid black;
      padding: 12px;
      text-align: left;
    }

    th {
      background-color: #007bff;
      color: white;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #e6f7ff;
    }

    .back-link {
      display: inline-block;
      margin-top: 20px;
      padding: 10px 20px;
      background-color: #007bff;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      transition: background 0.3s ease-in-out;
    }

    .back-link:hover {
      background-color: #0056b3;
    }
    a {
      text-decoration: none;
    }

    .notification-container {
      position: fixed;
      top: 15px;
      right: 20px;
      z-index: 1000;
      font-family: 'Poppins', Arial, sans-serif;
      cursor: pointer;
      background: linear-gradient(135deg, #4caf50, #81c784);
      padding: 10px 20px;
      border-radius: 30px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
      display: flex;
      align-items: center;
      gap: 10px;
      color: white;
      transition: background 0.3s ease;
    }

    .notification-icon {
      font-size: 20px;
      color: white;
    }

    .notification-text {
      font-size: 16px;
      font-weight: bold;
    }

    .notification-dropdown {
      display: none;
      position: absolute;
      top: 40px;
      right: 0;
      background-color: white;
      border: 1px solid #ccc;
      box-shadow: 0 2px 5px rgba(0,0,0,0.2);
      max-height: 200px;
      overflow-y: auto;
      width: 250px;
      z-index: 999;
      font-family: Arial, sans-serif;
    }

    .notification-dropdown div {
      padding: 10px;
      border-bottom: 1px solid #eee;
      font-size: 14px;
    }

    .notification-dropdown div:last-child {
      border-bottom: none;
    }

    .logout-link {
      position: fixed;
      top: 10px;
      right: 10px;
      background-color: #dc3545;
      color: white;
      padding: 8px 16px;
      text-decoration: none;
      border-radius: 5px;
      font-weight: bold;
      transition: 0.3s;
    }
    .logout-link:hover {
      background-color: #c82333;
    }
  </style>
</head>
<body>

<div class="notification-container" onclick="toggleNotifications()">
  <i class="fa fa-bell notification-icon"></i>
  <span id="notificationCount" class="notification-badge">0</span>
  <div id="notificationList" class="notification-dropdown"></div>
</div>

<h2>User List</h2>
<table>
  <tr>
    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Mobile</th>
    <th>Photo</th>
  </tr>
  <%
    List<User> users = (List<User>) request.getAttribute("users");
    if (users != null) {
      for (User user : users) {
  %>
  <tr>
    <td><%= user.getId() %></td>
    <td><%= user.getName() %></td>
    <td><%= user.getEmail() %></td>
    <td><%= user.getMobile() %></td>
    <td>
      <%
        String imageSource = "DisplayImageServlet?id=" + user.getId();
      %>

      <img src="<%= imageSource %>" alt="User Image" width="50" height="50">
    </td>
    <td>
      <a href="updateUser.jsp?id=<%= user.getId() %>" class="btn edit">Update</a>  /
      <a href="deleteuser?id=<%= user.getId() %>" class="btn delete" onclick="return confirm('Are you sure?')">Delete</a>
    </td>
  </tr>
  <%
      }
    }
  %>
</table>
<br></br></br>
<a href="adduser.jsp">Add New User</a>
</br></br>
------------------------------------------------------------------------------------------------
</br></br>
<a href="logout" onclick="return confirm('Are you sure you want to logout?')">Logout</a>

<script>
  const socket = new WebSocket("ws://localhost:8080/demo11_war_exploded/notifications");

  socket.onmessage = function (event) {
    document.getElementById("notificationCount").innerText = event.data;
  };

  let notificationsVisible = false;

  function toggleNotifications() {
    const listDiv = document.getElementById('notificationList');
    if (notificationsVisible) {
      listDiv.style.display = 'none';
      notificationsVisible = false;
    } else {
      fetch('/demo11_war_exploded/getNotifications')
              .then(response => response.json())
              .then(data => {
                if (data.length > 0) {
                  listDiv.innerHTML = data.map(msg => `<div>${msg}</div>`).join('');
                } else {
                  listDiv.innerHTML = "<div>No new notifications</div>";
                }
                listDiv.style.display = 'block';
                notificationsVisible = true;

                // After showing the list, mark them as read.
                fetch('/demo11_war_exploded/markNotificationsAsRead')
                        .then(() => {
                          document.getElementById('notificationCount').innerText = '0';
                        });
              });
    }
  }

  document.addEventListener('click', function (event) {
    const container = document.querySelector('.notification-container');
    if (!container.contains(event.target)) {
      document.getElementById('notificationList').style.display = 'none';
      notificationsVisible = false;
    }
  });
</script>

</body>
</html>
