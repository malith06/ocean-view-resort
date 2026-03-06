package com.oceanviewresort.service.impl;

import java.math.BigDecimal;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dto.BillResponse;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.service.BillingService;

public class BillingServiceImpl implements BillingService {

    private final ReservationDao reservationDao;
    private final RoomRateDao roomRateDao;

    public BillingServiceImpl(ReservationDao reservationDao, RoomRateDao roomRateDao) {
        this.reservationDao = reservationDao;
        this.roomRateDao = roomRateDao;
    }

    @Override
    public BillResponse generateBill(String reservationNo) {
        if (isBlank(reservationNo)) return fail("Reservation number is required.");

        Optional<Reservation> opt = reservationDao.findByReservationNo(reservationNo.trim());
        if (opt.isEmpty()) return fail("Reservation not found.");

        Reservation r = opt.get();

        // If you are using cancel feature
        if ("CANCELLED".equalsIgnoreCase(r.getStatus())) {
            return fail("Cannot generate bill. This reservation is CANCELLED.");
        }

        if (r.getCheckIn() == null || r.getCheckOut() == null) return fail("Reservation dates are missing.");
        if (!r.getCheckOut().isAfter(r.getCheckIn())) return fail("Invalid reservation dates (check-out must be after check-in).");

        int nights = (int) ChronoUnit.DAYS.between(r.getCheckIn(), r.getCheckOut());
        if (nights <= 0) return fail("Nights must be at least 1.");

        String roomType = r.getRoomType();
        if (isBlank(roomType)) return fail("Room type is missing.");

        BigDecimal rate = roomRateDao.findRateByRoomType(roomType.trim());
        if (rate == null) return fail("Room rate not found for room type: " + roomType);

        BigDecimal total = rate.multiply(BigDecimal.valueOf(nights));

        BillResponse res = new BillResponse();
        res.setSuccess(true);
        res.setMessage("Bill generated successfully.");
        res.setReservationNo(r.getReservationNo());
        res.setGuestName(r.getGuestName());
        res.setRoomType(r.getRoomType());

        
        res.setCheckIn(r.getCheckIn().toString());
        res.setCheckOut(r.getCheckOut().toString());

        res.setNights(nights);
        res.setRatePerNight(rate);
        res.setTotal(total);
        return res;
    }

    private BillResponse fail(String msg) {
        BillResponse res = new BillResponse();
        res.setSuccess(false);
        res.setMessage(msg);
        return res;
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
