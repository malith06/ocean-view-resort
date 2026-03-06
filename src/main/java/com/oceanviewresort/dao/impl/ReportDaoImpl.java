package com.oceanviewresort.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import com.oceanviewresort.dao.ReportDao;
import com.oceanviewresort.util.DBConnection;

public class ReportDaoImpl implements ReportDao {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    private String normalizeStatus(String statusFilter) {
        if (statusFilter == null) return "ALL";
        String s = statusFilter.trim().toUpperCase();
        if (s.isEmpty()) return "ALL";
        if (!s.equals("ALL") && !s.equals("ACTIVE") && !s.equals("CANCELLED")) return "ALL";
        return s;
    }

    @Override
    public List<Map<String, Object>> reservationsByDateRange(Date from, Date to, String statusFilter) {

        String status = normalizeStatus(statusFilter);

        String sql =
            "SELECT reservation_no, guest_name, contact_no, room_type, check_in, check_out, status " +
            "FROM reservations " +
            "WHERE check_in BETWEEN ? AND ? ";

        if (!"ALL".equals(status)) {
            sql += "AND status = ? ";
        }

        sql += "ORDER BY check_in ASC";

        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, from);
            ps.setDate(2, to);
            if (!"ALL".equals(status)) {
                ps.setString(3, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("reservationNo", rs.getString("reservation_no"));
                    row.put("guestName", rs.getString("guest_name"));
                    row.put("contactNo", rs.getString("contact_no"));
                    row.put("roomType", rs.getString("room_type"));
                    row.put("checkIn", rs.getDate("check_in").toString());
                    row.put("checkOut", rs.getDate("check_out").toString());
                    row.put("status", rs.getString("status"));
                    list.add(row);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Map<String, Object> revenueSummary(Date from, Date to, String statusFilter) {

        String status = normalizeStatus(statusFilter);

        String sql =
            "SELECT " +
            "COUNT(*) AS totalReservations, " +
            "COALESCE(SUM(DATEDIFF(r.check_out, r.check_in)),0) AS totalNights, " +
            "COALESCE(SUM(DATEDIFF(r.check_out, r.check_in) * rr.rate_per_night),0) AS totalRevenue " +
            "FROM reservations r " +
            "JOIN room_rates rr ON UPPER(rr.room_type) = UPPER(r.room_type) " +
            "WHERE r.check_in BETWEEN ? AND ? ";

        if (!"ALL".equals(status)) {
            sql += "AND r.status = ? ";
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("totalReservations", 0);
        result.put("totalNights", 0);
        result.put("totalRevenue", 0);

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, from);
            ps.setDate(2, to);
            if (!"ALL".equals(status)) {
                ps.setString(3, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    result.put("totalReservations", rs.getInt("totalReservations"));
                    result.put("totalNights", rs.getInt("totalNights"));
                    result.put("totalRevenue", rs.getBigDecimal("totalRevenue"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public List<Map<String, Object>> roomTypeUsage(Date from, Date to, String statusFilter) {

        String status = normalizeStatus(statusFilter);

        String sql =
            "SELECT room_type, COUNT(*) AS count " +
            "FROM reservations " +
            "WHERE check_in BETWEEN ? AND ? ";

        if (!"ALL".equals(status)) {
            sql += "AND status = ? ";
        }

        sql += "GROUP BY room_type ORDER BY count DESC";

        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, from);
            ps.setDate(2, to);
            if (!"ALL".equals(status)) {
                ps.setString(3, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("roomType", rs.getString("room_type"));
                    row.put("count", rs.getInt("count"));
                    list.add(row);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public int cancelledCount(Date from, Date to) {
        String sql =
            "SELECT COUNT(*) AS cancelledCount " +
            "FROM reservations " +
            "WHERE status='CANCELLED' AND cancelled_at BETWEEN ? AND ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, from);
            ps.setDate(2, to);

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt("cancelledCount");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
