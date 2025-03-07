package com.example.demo11.servlet;

import com.example.demo11.dao.UserDAO;
import com.example.demo11.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/userlist")
public class UserListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        List<User> userList = userDAO.getAllUsers();
        request.setAttribute("users", userList);
        request.getRequestDispatcher("userlist.jsp").forward(request, response);
    }
}
