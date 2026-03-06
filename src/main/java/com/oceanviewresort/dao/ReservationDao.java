package com.oceanviewresort.dao;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Optional;

import com.oceanviewresort.model.Reservation;

public interface ReservationDao {

    boolean insert(Reservation r);

    Optional<Reservation> findByReservationNo(String reservationNo);

    String nextReservationNo();

    boolean updateByReservationNo(Reservation r);

    boolean cancelByReservationNo(String reservationNo, String reason);

    long countCancelledBetween(Date from, Date to);

    
    int countOverlappingActiveReservations(String roomType, LocalDate checkIn, LocalDate checkOut);

    int countOverlappingActiveReservationsExclude(String reservationNo, String roomType, LocalDate checkIn, LocalDate checkOut);
}