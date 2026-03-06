package com.oceanviewresort.service.impl;

import java.time.LocalDate;

import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dto.AvailabilityResponse;

public class AvailabilityServiceImpl implements com.oceanviewresort.service.AvailabilityService {

    private final ReservationDao reservationDao;
    private final RoomRateDao roomRateDao;

    public AvailabilityServiceImpl(ReservationDao reservationDao, RoomRateDao roomRateDao) {
        this.reservationDao = reservationDao;
        this.roomRateDao = roomRateDao;
    }

    @Override
    public AvailabilityResponse checkAvailability(String roomType, String checkIn, String checkOut) {

        AvailabilityResponse res = new AvailabilityResponse();

        if (roomType == null || roomType.trim().isEmpty()) {
            res.setSuccess(false);
            res.setMessage("Room type is required.");
            return res;
        }
        if (checkIn == null || checkIn.trim().isEmpty()) {
            res.setSuccess(false);
            res.setMessage("Check-in date is required.");
            return res;
        }
        if (checkOut == null || checkOut.trim().isEmpty()) {
            res.setSuccess(false);
            res.setMessage("Check-out date is required.");
            return res;
        }

        LocalDate inDate;
        LocalDate outDate;
        try {
            inDate = LocalDate.parse(checkIn.trim());
            outDate = LocalDate.parse(checkOut.trim());
        } catch (Exception e) {
            res.setSuccess(false);
            res.setMessage("Invalid date format. Use YYYY-MM-DD.");
            return res;
        }

        if (!outDate.isAfter(inDate)) {
            res.setSuccess(false);
            res.setMessage("Check-out must be after check-in.");
            return res;
        }

        String rt = roomType.trim().toUpperCase();

        Integer capacity = roomRateDao.findCapacityByRoomType(rt);
        if (capacity == null || capacity <= 0) {
            res.setSuccess(false);
            res.setMessage("Capacity not configured for " + rt);
            return res;
        }

        int booked = reservationDao.countOverlappingActiveReservations(rt, inDate, outDate);
        int available = Math.max(0, capacity - booked);

        res.setSuccess(true);
        res.setRoomType(rt);
        res.setCheckIn(inDate.toString());
        res.setCheckOut(outDate.toString());
        res.setCapacity(capacity);
        res.setBooked(booked);
        res.setAvailable(available);

        res.setMessage(available > 0 ? "Available" : "No rooms available");
        return res;
    }
}