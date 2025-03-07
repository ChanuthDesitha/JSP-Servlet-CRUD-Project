package com.example.demo11.servlet;

import com.example.demo11.dao.NotificationDAO;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/getNotifications")
public class NotificationServlet extends HttpServlet {

    private final NotificationDAO dao = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<String> notifications = dao.getUnreadNotifications();

        String json = new Gson().toJson(notifications);
        response.getWriter().write(json);
    }
}
