package com.oceanviewresort.service;

import static org.junit.jupiter.api.Assertions.*;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dto.BillResponse;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.service.impl.BillingServiceImpl;

public class BillingServiceImplTest {

    private BillingService service;

    @BeforeEach
    void setup() {
        ReservationDao reservationDao = new FakeReservationDao();
        RoomRateDao roomRateDao = new FakeRoomRateDao();
        service = new BillingServiceImpl(reservationDao, roomRateDao);
    }

    @Test
    void bill_shouldCalculateNights_andTotal() {
        BillResponse bill = service.generateBill("R0001");

        assertTrue(bill.isSuccess());
        assertEquals(2, bill.getNights());

      
        assertEquals(0, new BigDecimal("30000.00").compareTo(bill.getRatePerNight()));
        assertEquals(0, new BigDecimal("60000.00").compareTo(bill.getTotal()));
    }

    

    static class FakeReservationDao implements ReservationDao {

        @Override
        public Optional<Reservation> findByReservationNo(String reservationNo) {
            Reservation r = new Reservation();
            r.setReservationNo(reservationNo);
            r.setGuestName("Test User");
            r.setRoomType("DELUXE");
            r.setCheckIn(LocalDate.of(2026, 2, 1));
            r.setCheckOut(LocalDate.of(2026, 2, 3)); // 2 nights
            r.setStatus("ACTIVE");
            return Optional.of(r);
        }

        @Override
        public boolean insert(Reservation r) { return true; }

        @Override
        public String nextReservationNo() { return "R0001"; }

        @Override
        public boolean updateByReservationNo(Reservation r) { return true; }

        @Override
        public boolean cancelByReservationNo(String reservationNo, String reason) { return true; }

        @Override
        public long countCancelledBetween(Date from, Date to) { return 0; }

        
        @Override
        public int countOverlappingActiveReservations(String roomType, LocalDate checkIn, LocalDate checkOut) {
            return 0;
        }

        @Override
        public int countOverlappingActiveReservationsExclude(String reservationNo, String roomType, LocalDate checkIn, LocalDate checkOut) {
            return 0;
        }
    }

    static class FakeRoomRateDao implements RoomRateDao {
        @Override
        public BigDecimal findRateByRoomType(String roomType) {
            return new BigDecimal("30000.00"); 
        }

        @Override
        public Integer findCapacityByRoomType(String roomType) {
            return 10; 
        }
    }
}