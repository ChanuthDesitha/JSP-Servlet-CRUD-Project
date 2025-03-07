package com.example.demo11.servlet;

import com.example.demo11.dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean isAuthenticated = userDAO.authenticateUser(email, password);

        if (isAuthenticated) {
            HttpSession session = request.getSession();
            session.setAttribute("user", email);
            response.sendRedirect("userlist");
        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}
