package com.oceanviewresort.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Optional;

import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.util.DBConnection;

public class ReservationDaoImpl implements ReservationDao {

    private static final String SQL_INSERT =
        "INSERT INTO reservations (reservation_no, guest_name, address, contact_no, room_type, check_in, check_out) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_FIND_BY_RES_NO =
        "SELECT id, reservation_no, guest_name, address, contact_no, room_type, check_in, check_out, created_at, " +
        "status, cancel_reason, cancelled_at " +
        "FROM reservations WHERE reservation_no = ? LIMIT 1";

    private static final String SQL_UPDATE_BY_RES_NO =
        "UPDATE reservations SET guest_name=?, address=?, contact_no=?, room_type=?, check_in=?, check_out=? " +
        "WHERE reservation_no=?";

   
    private static final String SQL_LOCK_SEQ =
        "SELECT next_val FROM reservation_seq WHERE id=1 FOR UPDATE";

    private static final String SQL_UPDATE_SEQ =
        "UPDATE reservation_seq SET next_val = ? WHERE id=1";

   
    private static final String SQL_CANCEL =
        "UPDATE reservations SET status='CANCELLED', cancel_reason=?, cancelled_at=NOW() " +
        "WHERE reservation_no=? AND status <> 'CANCELLED'";

    
    private static final String SQL_COUNT_CANCELLED =
        "SELECT COUNT(*) AS cnt FROM reservations " +
        "WHERE status='CANCELLED' AND cancelled_at BETWEEN ? AND ?";
    
    private static final String SQL_COUNT_OVERLAP =
    	    "SELECT COUNT(*) AS cnt FROM reservations " +
    	    "WHERE status='ACTIVE' AND UPPER(room_type)=? " +
    	    "AND (check_in < ? AND check_out > ?)";

    	private static final String SQL_COUNT_OVERLAP_EXCLUDE =
    	    "SELECT COUNT(*) AS cnt FROM reservations " +
    	    "WHERE status='ACTIVE' AND reservation_no <> ? AND UPPER(room_type)=? " +
    	    "AND (check_in < ? AND check_out > ?)";

    @Override
    public boolean insert(Reservation r) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {

            ps.setString(1, r.getReservationNo());
            ps.setString(2, r.getGuestName());
            ps.setString(3, r.getAddress());
            ps.setString(4, r.getContactNo());
            ps.setString(5, r.getRoomType());
            ps.setDate(6, java.sql.Date.valueOf(r.getCheckIn()));
            ps.setDate(7, java.sql.Date.valueOf(r.getCheckOut()));

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            throw new RuntimeException("ReservationDao.insert failed: " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<Reservation> findByReservationNo(String reservationNo) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_RES_NO)) {

            ps.setString(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();

                Reservation r = new Reservation();
                r.setId(rs.getInt("id"));
                r.setReservationNo(rs.getString("reservation_no"));
                r.setGuestName(rs.getString("guest_name"));
                r.setAddress(rs.getString("address"));
                r.setContactNo(rs.getString("contact_no"));
                r.setRoomType(rs.getString("room_type"));
                r.setCheckIn(rs.getDate("check_in").toLocalDate());
                r.setCheckOut(rs.getDate("check_out").toLocalDate());

                if (rs.getTimestamp("created_at") != null) {
                    r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }

              
                r.setStatus(rs.getString("status"));
                r.setCancelReason(rs.getString("cancel_reason"));
                if (rs.getTimestamp("cancelled_at") != null) {
                    r.setCancelledAt(rs.getTimestamp("cancelled_at").toLocalDateTime());
                }

                return Optional.of(r);
            }

        } catch (Exception e) {
            throw new RuntimeException("ReservationDao.findByReservationNo failed: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean updateByReservationNo(Reservation r) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_UPDATE_BY_RES_NO)) {

            ps.setString(1, r.getGuestName());
            ps.setString(2, r.getAddress());
            ps.setString(3, r.getContactNo());
            ps.setString(4, r.getRoomType());
            ps.setDate(5, java.sql.Date.valueOf(r.getCheckIn()));
            ps.setDate(6, java.sql.Date.valueOf(r.getCheckOut()));
            ps.setString(7, r.getReservationNo());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            throw new RuntimeException("ReservationDao.updateByReservationNo failed: " + e.getMessage(), e);
        }
    }

    @Override
    public String nextReservationNo() {
        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            int nextVal;

            // lock row
            try (PreparedStatement ps = con.prepareStatement(SQL_LOCK_SEQ);
                 ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    throw new RuntimeException("reservation_seq not initialized (missing id=1 row)");
                }
                nextVal = rs.getInt("next_val");
            }

            // update next value
            try (PreparedStatement ps2 = con.prepareStatement(SQL_UPDATE_SEQ)) {
                ps2.setInt(1, nextVal + 1);
                ps2.executeUpdate();
            }

            con.commit();
            return String.format("R%04d", nextVal);

        } catch (Exception e) {
            throw new RuntimeException("Failed to generate reservation no: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean cancelByReservationNo(String reservationNo, String reason) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_CANCEL)) {

            ps.setString(1, reason);
            ps.setString(2, reservationNo);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            throw new RuntimeException("ReservationDao.cancelByReservationNo failed: " + e.getMessage(), e);
        }
    }

    @Override
    public long countCancelledBetween(java.sql.Date from, java.sql.Date to) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_COUNT_CANCELLED)) {

            ps.setDate(1, from);
            ps.setDate(2, to);

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getLong("cnt");
            }

        } catch (Exception e) {
            throw new RuntimeException("ReservationDao.countCancelledBetween failed: " + e.getMessage(), e);
        }
    }
    @Override
    public int countOverlappingActiveReservations(String roomType, java.time.LocalDate checkIn, java.time.LocalDate checkOut) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_COUNT_OVERLAP)) {

            ps.setString(1, roomType.trim().toUpperCase());
            ps.setDate(2, java.sql.Date.valueOf(checkOut)); // end
            ps.setDate(3, java.sql.Date.valueOf(checkIn));  // start

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt("cnt");
            }

        } catch (Exception e) {
            throw new RuntimeException("ReservationDao.countOverlappingActiveReservations failed: " + e.getMessage(), e);
        }
    }

    @Override
    public int countOverlappingActiveReservationsExclude(String reservationNo, String roomType, java.time.LocalDate checkIn, java.time.LocalDate checkOut) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_COUNT_OVERLAP_EXCLUDE)) {

            ps.setString(1, reservationNo);
            ps.setString(2, roomType.trim().toUpperCase());
            ps.setDate(3, java.sql.Date.valueOf(checkOut));
            ps.setDate(4, java.sql.Date.valueOf(checkIn));

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt("cnt");
            }

        } catch (Exception e) {
            throw new RuntimeException("ReservationDao.countOverlappingActiveReservationsExclude failed: " + e.getMessage(), e);
        }
    }
}

