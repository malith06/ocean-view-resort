package com.oceanviewresort.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.oceanviewresort.dao.UserDao;
import com.oceanviewresort.dao.impl.UserDaoImpl;
import com.oceanviewresort.dto.LoginRequest;
import com.oceanviewresort.dto.LoginResponse;
import com.oceanviewresort.service.AuthService;
import com.oceanviewresort.service.impl.AuthServiceImpl;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AuthService authService;

    @Override
    public void init() {
        UserDao userDao = new UserDaoImpl();
        this.authService = new AuthServiceImpl(userDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        LoginResponse result = authService.login(new LoginRequest(username, password));

        if (result != null && result.isSuccess()) {
            HttpSession session = req.getSession(true);

            
            session.setAttribute("user", username);

           
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.setAttribute("error", result != null ? result.getMessage() : "Login failed");
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }
}