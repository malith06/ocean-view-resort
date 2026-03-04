package com.oceanviewresort.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://127.0.0.1:3306/ocean_view_resort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "12345678"; 

    public static Connection getConnection() {
        try {
            // MySQL Driver (for mysql-connector-j 8+)
            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            // show real error
            throw new RuntimeException("Database connection failed: " + e.getMessage(), e);
        }
    }
}
