package com.example.demo11.servlet;

import com.example.demo11.dao.NotificationDAO;
import com.example.demo11.dao.UserDAO;
import com.example.demo11.model.User;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/updateUser")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class UpdateUserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("id");

            if (idStr == null || idStr.isEmpty()) {
                System.out.println("Error: ID parameter is missing or empty!");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required.");
                return;
            }

            int id = Integer.parseInt(idStr);
            System.out.println("ID received in servlet: " + id);

            int userId = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String mobile = request.getParameter("mobile");


            User existingUser = userDAO.getUserById(userId);

            if (!email.equalsIgnoreCase(existingUser.getEmail()) && userDAO.emailExists(email)) {
                response.sendRedirect("updateUser.jsp?id=" + userId + "&error=email_taken");
                return;
            }

            Part filePart = request.getPart("photo");
            InputStream imageStream = (filePart != null && filePart.getSize() > 0) ? filePart.getInputStream() : null;

            User user = new User(id, name, email, password, mobile, imageStream);

            boolean isUpdated = userDAO.updateUser(user, imageStream);

            if (isUpdated) {
                NotificationDAO.UpdateNotification(id);
                response.sendRedirect("userlist");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update user.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
}
