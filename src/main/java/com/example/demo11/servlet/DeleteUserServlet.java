package com.example.demo11.servlet;

import com.example.demo11.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/deleteuser")
public class DeleteUserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(userId);
        response.sendRedirect("userlist");
    }
}