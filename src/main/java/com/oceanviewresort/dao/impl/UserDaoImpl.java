package com.oceanviewresort.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Optional;

import com.oceanviewresort.dao.UserDao;
import com.oceanviewresort.model.User;
import com.oceanviewresort.util.DBConnection;

public class UserDaoImpl implements UserDao {

    private static final String SQL_FIND_BY_USERNAME =
            "SELECT id, username, password_hash, role, status, created_at " +
            "FROM users WHERE username = ? LIMIT 1";

    @Override
    public Optional<User> findByUsername(String username) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_USERNAME)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();

                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));

                // created_at could be null in some DB configs, so safe:
                if (rs.getTimestamp("created_at") != null) {
                    u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }

                return Optional.of(u);
            }

        } catch (Exception e) {
            throw new RuntimeException("UserDao.findByUsername failed: " + e.getMessage(), e);
        }
    }
}
