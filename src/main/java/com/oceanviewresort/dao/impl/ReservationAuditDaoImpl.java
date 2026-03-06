package com.oceanviewresort.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.oceanviewresort.dao.ReservationAuditDao;
import com.oceanviewresort.util.DBConnection;

public class ReservationAuditDaoImpl implements ReservationAuditDao {

    private static final String SQL_INSERT =
        "INSERT INTO reservation_audit (reservation_no, action, action_by, details) VALUES (?,?,?,?)";

    @Override
    public boolean log(String reservationNo, String action, String actionBy, String details) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {

            ps.setString(1, reservationNo);
            ps.setString(2, action);
            ps.setString(3, actionBy);
            ps.setString(4, details);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            throw new RuntimeException("Audit log failed: " + e.getMessage(), e);
        }
    }
}