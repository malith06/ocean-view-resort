package com.oceanviewresort.dao.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.util.DBConnection;

public class RoomRateDaoImpl implements RoomRateDao {

    private static final String SQL_FIND_RATE =
        "SELECT rate_per_night FROM room_rates WHERE UPPER(room_type) = ? LIMIT 1";

    private static final String SQL_FIND_CAPACITY =
        "SELECT capacity FROM room_rates WHERE UPPER(room_type) = ? LIMIT 1";

    @Override
    public BigDecimal findRateByRoomType(String roomType) {
        if (roomType == null || roomType.trim().isEmpty()) return null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_RATE)) {

            ps.setString(1, roomType.trim().toUpperCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return rs.getBigDecimal("rate_per_night");
            }

        } catch (Exception e) {
            throw new RuntimeException("RoomRateDao.findRateByRoomType failed: " + e.getMessage(), e);
        }
    }

    @Override
    public Integer findCapacityByRoomType(String roomType) {
        if (roomType == null || roomType.trim().isEmpty()) return null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_CAPACITY)) {

            ps.setString(1, roomType.trim().toUpperCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return rs.getInt("capacity");
            }

        } catch (Exception e) {
            throw new RuntimeException("RoomRateDao.findCapacityByRoomType failed: " + e.getMessage(), e);
        }
    }
}