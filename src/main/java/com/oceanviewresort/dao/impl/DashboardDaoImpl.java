package com.oceanviewresort.dao.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.oceanviewresort.dao.DashboardDao;
import com.oceanviewresort.util.DBConnection;

public class DashboardDaoImpl implements DashboardDao {

    private static final String SQL_TODAY_CHECKINS =
        "SELECT COUNT(*) AS cnt FROM reservations " +
        "WHERE status='ACTIVE' AND check_in = CURDATE()";

    private static final String SQL_TODAY_CHECKOUTS =
        "SELECT COUNT(*) AS cnt FROM reservations " +
        "WHERE status='ACTIVE' AND check_out = CURDATE()";

    private static final String SQL_ACTIVE_RESERVATIONS =
        "SELECT COUNT(*) AS cnt FROM reservations WHERE status='ACTIVE'";

    
    private static final String SQL_REVENUE_THIS_MONTH =
        "SELECT COALESCE(SUM(DATEDIFF(r.check_out, r.check_in) * rr.rate_per_night),0) AS total " +
        "FROM reservations r " +
        "JOIN room_rates rr ON UPPER(rr.room_type)=UPPER(r.room_type) " +
        "WHERE r.status='ACTIVE' " +
        "AND YEAR(r.check_in) = YEAR(CURDATE()) " +
        "AND MONTH(r.check_in) = MONTH(CURDATE())";

    @Override
    public int countTodayCheckIns() {
        return queryInt(SQL_TODAY_CHECKINS);
    }

    @Override
    public int countTodayCheckOuts() {
        return queryInt(SQL_TODAY_CHECKOUTS);
    }

    @Override
    public int countActiveReservations() {
        return queryInt(SQL_ACTIVE_RESERVATIONS);
    }

    @Override
    public BigDecimal revenueThisMonthActiveOnly() {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_REVENUE_THIS_MONTH);
             ResultSet rs = ps.executeQuery()) {

            rs.next();
            BigDecimal v = rs.getBigDecimal("total");
            return (v != null) ? v : BigDecimal.ZERO;

        } catch (Exception e) {
            throw new RuntimeException("DashboardDao.revenueThisMonthActiveOnly failed: " + e.getMessage(), e);
        }
    }

    private int queryInt(String sql) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            rs.next();
            return rs.getInt("cnt");

        } catch (Exception e) {
            throw new RuntimeException("DashboardDao query failed: " + e.getMessage(), e);
        }
    }
}