package com.oceanviewresort.dao;

public interface ReservationAuditDao {
    boolean log(String reservationNo, String action, String actionBy, String details);
}