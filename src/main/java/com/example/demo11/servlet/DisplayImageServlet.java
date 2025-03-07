package com.example.demo11.servlet;

import com.example.demo11.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/DisplayImageServlet")
public class DisplayImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT photo FROM users WHERE id=?")) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                InputStream imgStream = rs.getBinaryStream("photo");

                if (imgStream != null) {
                    sendImage(response, imgStream);
                } else {
                    sendDefaultImage(response);
                }
            } else {
                sendDefaultImage(response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }

    private void sendImage(HttpServletResponse response, InputStream imgStream) throws IOException {
        response.setContentType("image/jpeg");

        try (OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[1024];
            int bytesRead;

            while ((bytesRead = imgStream.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }

            os.flush();
        }
    }

    private void sendDefaultImage(HttpServletResponse response) throws IOException {
        response.setContentType("image/jpeg");

        try (InputStream defaultImgStream = getServletContext().getResourceAsStream("/img/default-image.jpg");
             OutputStream os = response.getOutputStream()) {

            if (defaultImgStream != null) {
                byte[] buffer = new byte[1024];
                int bytesRead;

                while ((bytesRead = defaultImgStream.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }

                os.flush();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Default image not found");
            }
        }
    }
}
