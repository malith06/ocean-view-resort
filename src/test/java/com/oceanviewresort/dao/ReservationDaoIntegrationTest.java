package com.oceanviewresort.dao;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;
import java.util.UUID;

import org.junit.jupiter.api.Test;

import com.oceanviewresort.dao.impl.ReservationDaoImpl;
import com.oceanviewresort.model.Reservation;

public class ReservationDaoIntegrationTest {

    @Test
    void insert_and_findByReservationNo_shouldWork() {

        ReservationDao dao = new ReservationDaoImpl();

        String uniqueNo = "TEST-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        Reservation r = new Reservation();
        r.setReservationNo(uniqueNo);
        r.setGuestName("JUnit User");
        r.setAddress("Test Address");
        r.setContactNo("0712345678");
        r.setRoomType("DELUXE");
        r.setCheckIn(LocalDate.now().plusDays(1));
        r.setCheckOut(LocalDate.now().plusDays(2));

        boolean ok = dao.insert(r);
        assertTrue(ok);

        assertTrue(dao.findByReservationNo(uniqueNo).isPresent());
    }

	
}