package com.example.demo11.servlet;

import com.example.demo11.dao.NotificationDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/markNotificationsAsRead")
public class MarkNotificationsAsReadServlet extends HttpServlet {

    private final NotificationDAO dao = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        dao.markAllAsRead();
        response.setStatus(HttpServletResponse.SC_OK);
    }
}


