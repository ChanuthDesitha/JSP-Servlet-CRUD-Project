package com.example.demo11.servlet;

import com.example.demo11.dao.NotificationDAO;
import com.example.demo11.dao.UserDAO;
import com.example.demo11.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;

@WebServlet("/adduser")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class AddUserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String mobile = request.getParameter("mobile");

        if (userDAO.emailExists(email)) {
            response.sendRedirect("adduser.jsp?error=email_taken");
            return;
        }

        Part filePart = request.getPart("photo");
        InputStream imageStream = (filePart != null && filePart.getSize() > 0) ? filePart.getInputStream() : null;

        User newUser = new User(0, name, email, password, mobile, imageStream);

        boolean isAdded = userDAO.addUser(newUser);

        if (isAdded) {
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.addNotification("New user: " + name);

            response.sendRedirect("login.jsp?success");
        } else {
            response.sendRedirect("adduser.jsp?failed");
        }
    }
}
