package com.oceanviewresort.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oceanviewresort.util.DBConnection;


@WebServlet("/db-test")
public class DbTestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain; charset=UTF-8");

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) AS cnt FROM room_rates")) {

            rs.next();
            int count = rs.getInt("cnt");

            resp.getWriter().println("✅ DB Connection OK");
            resp.getWriter().println("room_rates rows = " + count);

        } catch (Exception e) {
            resp.getWriter().println("❌ DB Connection FAILED");
            resp.getWriter().println(e.getMessage());
        }
    }
}

