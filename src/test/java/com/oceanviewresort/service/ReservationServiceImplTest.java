package com.oceanviewresort.service;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dto.ReservationCancelRequest;
import com.oceanviewresort.dto.ReservationCancelResponse;
import com.oceanviewresort.dto.ReservationCreateRequest;
import com.oceanviewresort.dto.ReservationResponse;
import com.oceanviewresort.dto.ReservationUpdateRequest;
import com.oceanviewresort.exception.ValidationException;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.service.impl.ReservationServiceImpl;

public class ReservationServiceImplTest {

    private ReservationService service;
    private FakeReservationDao fakeResDao;
    private FakeRoomRateDao fakeRoomRateDao;

    @BeforeEach
    void setup() {
        fakeResDao = new FakeReservationDao();
        fakeRoomRateDao = new FakeRoomRateDao();
        service = new ReservationServiceImpl(fakeResDao, fakeRoomRateDao); // ✅ inject roomRateDao
    }

    @Test
    void createReservation_shouldFail_whenGuestNameMissing() {
        ReservationCreateRequest req = validReq();
        req.setGuestName("");
        assertThrows(ValidationException.class, () -> service.createReservation(req));
    }

    @Test
    void createReservation_shouldCreate_andGenerateReservationNo() {
        ReservationResponse res = service.createReservation(validReq());

        assertTrue(res.isSuccess());
        assertNotNull(res.getReservationNo());
        assertTrue(res.getReservationNo().matches("R\\d{4}"));
        assertNotNull(fakeResDao.lastInserted.get());
    }

    @Test
    void createReservation_shouldFail_whenNoAvailability() {
        // make capacity = 1
        fakeRoomRateDao.capacity = 1;

        // simulate already booked 1 overlapping reservation
        fakeResDao.overlapCount = 1;

        assertThrows(ValidationException.class, () -> service.createReservation(validReq()));
    }

    @Test
    void updateReservation_shouldUpdateFields_whenValid() {
        ReservationResponse created = service.createReservation(validReq());

        ReservationUpdateRequest up = new ReservationUpdateRequest();
        up.setReservationNo(created.getReservationNo());
        up.setGuestName("Nimal Silva");
        up.setAddress("No 99, Updated Road");
        up.setContactNo("0711111111");
        up.setRoomType("SUITE");
        up.setCheckIn(LocalDate.now().plusDays(2).toString());
        up.setCheckOut(LocalDate.now().plusDays(5).toString());

        ReservationResponse updated = service.updateReservation(up);

        assertTrue(updated.isSuccess());
        assertEquals("Nimal Silva", updated.getGuestName());
        assertEquals("SUITE", updated.getRoomType());
    }

    @Test
    void cancelReservation_shouldCancel_whenActive() {
        ReservationResponse created = service.createReservation(validReq());

        ReservationCancelRequest cr = new ReservationCancelRequest();
        cr.setReservationNo(created.getReservationNo());
        cr.setReason("Customer requested cancellation");

        ReservationCancelResponse out = service.cancelReservation(cr, "admin");

        assertTrue(out.isSuccess());
        assertEquals("CANCELLED", out.getStatus());
        assertEquals(created.getReservationNo(), out.getReservationNo());

        assertEquals("CANCELLED", fakeResDao.lastInserted.get().getStatus());
    }

    // ---------- helper ----------
    private ReservationCreateRequest validReq() {
        ReservationCreateRequest req = new ReservationCreateRequest();
        req.setGuestName("Kamal Perera");
        req.setAddress("No 10, Main Street");
        req.setContactNo("0712345678");
        req.setRoomType("DELUXE");
        req.setCheckIn(LocalDate.now().plusDays(1).toString());
        req.setCheckOut(LocalDate.now().plusDays(3).toString());
        return req;
    }

    // ---------- Fake Reservation DAO ----------
    static class FakeReservationDao implements ReservationDao {

        private final AtomicReference<Reservation> lastInserted = new AtomicReference<>();
        private final AtomicInteger seq = new AtomicInteger(1);

        int overlapCount = 0; // control availability outcome

        @Override
        public boolean insert(Reservation r) {
            r.setStatus("ACTIVE");
            lastInserted.set(r);
            return true;
        }

        @Override
        public Optional<Reservation> findByReservationNo(String reservationNo) {
            Reservation r = lastInserted.get();
            if (r != null && r.getReservationNo() != null && r.getReservationNo().equals(reservationNo)) {
                return Optional.of(r);
            }
            return Optional.empty();
        }

        @Override
        public String nextReservationNo() {
            return String.format("R%04d", seq.getAndIncrement());
        }

        @Override
        public boolean updateByReservationNo(Reservation r) {
            Reservation cur = lastInserted.get();
            if (cur == null) return false;
            if (!cur.getReservationNo().equals(r.getReservationNo())) return false;

            cur.setGuestName(r.getGuestName());
            cur.setAddress(r.getAddress());
            cur.setContactNo(r.getContactNo());
            cur.setRoomType(r.getRoomType());
            cur.setCheckIn(r.getCheckIn());
            cur.setCheckOut(r.getCheckOut());
            lastInserted.set(cur);
            return true;
        }

        @Override
        public boolean cancelByReservationNo(String reservationNo, String reason) {
            Reservation cur = lastInserted.get();
            if (cur == null) return false;
            if (!cur.getReservationNo().equals(reservationNo)) return false;
            if ("CANCELLED".equalsIgnoreCase(cur.getStatus())) return false;

            cur.setStatus("CANCELLED");
            cur.setCancelReason(reason);
            lastInserted.set(cur);
            return true;
        }

        @Override
        public long countCancelledBetween(Date from, Date to) {
            Reservation cur = lastInserted.get();
            if (cur == null) return 0;
            return "CANCELLED".equalsIgnoreCase(cur.getStatus()) ? 1 : 0;
        }

      
        @Override
        public int countOverlappingActiveReservations(String roomType, LocalDate checkIn, LocalDate checkOut) {
            return overlapCount;
        }

        @Override
        public int countOverlappingActiveReservationsExclude(String reservationNo, String roomType, LocalDate checkIn, LocalDate checkOut) {
            return overlapCount;
        }
    }

    // ---------- Fake RoomRate DAO ----------
    static class FakeRoomRateDao implements RoomRateDao {

        int capacity = 10;

        @Override
        public java.math.BigDecimal findRateByRoomType(String roomType) {
            return new java.math.BigDecimal("30000.00");
        }

        @Override
        public Integer findCapacityByRoomType(String roomType) {
            return capacity;
        }
    }
}