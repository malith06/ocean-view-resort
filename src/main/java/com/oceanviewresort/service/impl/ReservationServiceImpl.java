package com.oceanviewresort.service.impl;

import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;

import com.oceanviewresort.dao.ReservationAuditDao;
import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dao.impl.RoomRateDaoImpl;
import com.oceanviewresort.dto.ReservationCancelRequest;
import com.oceanviewresort.dto.ReservationCancelResponse;
import com.oceanviewresort.dto.ReservationCreateRequest;
import com.oceanviewresort.dto.ReservationResponse;
import com.oceanviewresort.dto.ReservationUpdateRequest;
import com.oceanviewresort.exception.ValidationException;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.service.ReservationService;
import com.oceanviewresort.util.ValidationUtil;

public class ReservationServiceImpl implements ReservationService {

    private final ReservationDao reservationDao;
    private final RoomRateDao roomRateDao;       
    private final ReservationAuditDao auditDao;  

    
    public ReservationServiceImpl(ReservationDao reservationDao, RoomRateDao roomRateDao, ReservationAuditDao auditDao) {
        this.reservationDao = reservationDao;
        this.roomRateDao = roomRateDao;
        this.auditDao = auditDao;
    }

 
    public ReservationServiceImpl(ReservationDao reservationDao, RoomRateDao roomRateDao) {
        this(reservationDao, roomRateDao, null);
    }

   
    public ReservationServiceImpl(ReservationDao reservationDao, ReservationAuditDao auditDao) {
        this(reservationDao, new RoomRateDaoImpl(), auditDao);
    }

  
    public ReservationServiceImpl(ReservationDao reservationDao) {
        this(reservationDao, new RoomRateDaoImpl(), null);
    }

    
    private void ensureAvailability(String roomType, LocalDate checkIn, LocalDate checkOut, String excludeReservationNo) {

        Integer capacity = roomRateDao.findCapacityByRoomType(roomType);
        if (capacity == null || capacity <= 0) {
            throw new ValidationException(Map.of(
                "roomType", "Room capacity not configured for " + roomType
            ));
        }

        int booked;
        if (excludeReservationNo == null) {
            booked = reservationDao.countOverlappingActiveReservations(roomType, checkIn, checkOut);
        } else {
            booked = reservationDao.countOverlappingActiveReservationsExclude(excludeReservationNo, roomType, checkIn, checkOut);
        }

        if (booked >= capacity) {
            throw new ValidationException(Map.of(
                "roomType",
                "No availability for " + roomType + " during selected dates. (Booked " + booked + "/" + capacity + ")"
            ));
        }
    }

    
    @Override
    public ReservationResponse createReservation(ReservationCreateRequest req) {

        String guestName = (req != null) ? req.getGuestName() : null;
        String address   = (req != null) ? req.getAddress() : null;
        String contactNo = (req != null) ? req.getContactNo() : null;
        String roomType  = (req != null) ? req.getRoomType() : null;
        String checkIn   = (req != null) ? req.getCheckIn() : null;
        String checkOut  = (req != null) ? req.getCheckOut() : null;

        Map<String, String> errors = ValidationUtil.validateReservation(
            guestName, address, contactNo, roomType, checkIn, checkOut
        );
        if (!errors.isEmpty()) throw new ValidationException(errors);

        LocalDate inDate = LocalDate.parse(checkIn.trim());
        LocalDate outDate = LocalDate.parse(checkOut.trim());

        
        ensureAvailability(roomType.trim().toUpperCase(), inDate, outDate, null);

        String resNo = reservationDao.nextReservationNo();

        Reservation r = new Reservation();
        r.setReservationNo(resNo);
        r.setGuestName(guestName.trim());
        r.setAddress(address.trim());
        r.setContactNo(contactNo.trim());
        r.setRoomType(roomType.trim().toUpperCase());
        r.setCheckIn(inDate);
        r.setCheckOut(outDate);

        boolean ok = reservationDao.insert(r);
        if (!ok) return fail("Failed to create reservation. Please try again.");

        if (auditDao != null) {
            auditDao.log(resNo, "CREATED", null, "Reservation created");
        }

        ReservationResponse resp = new ReservationResponse();
        resp.setSuccess(true);
        resp.setMessage("Reservation created successfully.");
        resp.setReservationNo(resNo);
        resp.setGuestName(r.getGuestName());
        resp.setAddress(r.getAddress());
        resp.setContactNo(r.getContactNo());
        resp.setRoomType(r.getRoomType());
        resp.setCheckIn(r.getCheckIn().toString());
        resp.setCheckOut(r.getCheckOut().toString());

       
        resp.setStatus("ACTIVE");

        return resp;
    }

   
    @Override
    public ReservationResponse getReservationByNo(String reservationNo) {
        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            return fail("Reservation number is required.");
        }

        Optional<Reservation> opt = reservationDao.findByReservationNo(reservationNo.trim());
        if (opt.isEmpty()) return fail("Reservation not found.");

        Reservation r = opt.get();

        ReservationResponse resp = new ReservationResponse();
        resp.setSuccess(true);
        resp.setMessage("Reservation found.");
        resp.setReservationNo(r.getReservationNo());
        resp.setGuestName(r.getGuestName());
        resp.setAddress(r.getAddress());
        resp.setContactNo(r.getContactNo());
        resp.setRoomType(r.getRoomType());
        resp.setCheckIn(r.getCheckIn() != null ? r.getCheckIn().toString() : null);
        resp.setCheckOut(r.getCheckOut() != null ? r.getCheckOut().toString() : null);

        
        resp.setStatus(r.getStatus() != null ? r.getStatus() : "ACTIVE");
        resp.setCancelReason(r.getCancelReason());
        resp.setCancelledAt(r.getCancelledAt() != null ? r.getCancelledAt().toString() : null);

        return resp;
    }

   
    @Override
    public ReservationResponse updateReservation(ReservationUpdateRequest req) {

        String reservationNo = (req != null) ? req.getReservationNo() : null;
        String guestName = (req != null) ? req.getGuestName() : null;
        String address   = (req != null) ? req.getAddress() : null;
        String contactNo = (req != null) ? req.getContactNo() : null;
        String roomType  = (req != null) ? req.getRoomType() : null;
        String checkIn   = (req != null) ? req.getCheckIn() : null;
        String checkOut  = (req != null) ? req.getCheckOut() : null;

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            throw new ValidationException(Map.of("reservationNo", "Reservation number is required."));
        }

        Optional<Reservation> existing = reservationDao.findByReservationNo(reservationNo.trim());
        if (existing.isEmpty()) return fail("Reservation not found.");

        if ("CANCELLED".equalsIgnoreCase(existing.get().getStatus())) {
            return fail("Cannot update a cancelled reservation.");
        }

        Map<String, String> errors = ValidationUtil.validateReservation(
            guestName, address, contactNo, roomType, checkIn, checkOut
        );
        if (!errors.isEmpty()) throw new ValidationException(errors);

        LocalDate inDate = LocalDate.parse(checkIn.trim());
        LocalDate outDate = LocalDate.parse(checkOut.trim());

       
        ensureAvailability(roomType.trim().toUpperCase(), inDate, outDate, reservationNo.trim());

        Reservation updated = new Reservation();
        updated.setReservationNo(reservationNo.trim());
        updated.setGuestName(guestName.trim());
        updated.setAddress(address.trim());
        updated.setContactNo(contactNo.trim());
        updated.setRoomType(roomType.trim().toUpperCase());
        updated.setCheckIn(inDate);
        updated.setCheckOut(outDate);

        boolean ok = reservationDao.updateByReservationNo(updated);
        if (!ok) return fail("Update failed. Please try again.");

        if (auditDao != null) {
            auditDao.log(updated.getReservationNo(), "UPDATED", null, "Reservation updated");
        }

        ReservationResponse resp = new ReservationResponse();
        resp.setSuccess(true);
        resp.setMessage("Reservation updated successfully.");
        resp.setReservationNo(updated.getReservationNo());
        resp.setGuestName(updated.getGuestName());
        resp.setAddress(updated.getAddress());
        resp.setContactNo(updated.getContactNo());
        resp.setRoomType(updated.getRoomType());
        resp.setCheckIn(updated.getCheckIn().toString());
        resp.setCheckOut(updated.getCheckOut().toString());
        resp.setStatus("ACTIVE");
        return resp;
    }

    
    @Override
    public ReservationCancelResponse cancelReservation(ReservationCancelRequest req, String actionBy) {

        ReservationCancelResponse out = new ReservationCancelResponse();

        if (req == null || req.getReservationNo() == null || req.getReservationNo().trim().isEmpty()) {
            out.setSuccess(false);
            out.setMessage("Reservation number is required.");
            return out;
        }

        String reservationNo = req.getReservationNo().trim();
        String reason = (req.getReason() == null) ? "" : req.getReason().trim();
        if (reason.isEmpty()) reason = "No reason provided";

        Optional<Reservation> existing = reservationDao.findByReservationNo(reservationNo);
        if (existing.isEmpty()) {
            out.setSuccess(false);
            out.setMessage("Reservation not found.");
            return out;
        }

        if ("CANCELLED".equalsIgnoreCase(existing.get().getStatus())) {
            out.setSuccess(false);
            out.setMessage("Reservation is already cancelled.");
            out.setReservationNo(reservationNo);
            out.setStatus("CANCELLED");
            return out;
        }

        boolean ok = reservationDao.cancelByReservationNo(reservationNo, reason);
        if (!ok) {
            out.setSuccess(false);
            out.setMessage("Cancel failed. Please try again.");
            return out;
        }

        if (auditDao != null) {
            auditDao.log(reservationNo, "CANCELLED", actionBy, reason);
        }

        out.setSuccess(true);
        out.setMessage("Reservation cancelled successfully.");
        out.setReservationNo(reservationNo);
        out.setStatus("CANCELLED");
        return out;
    }

    private ReservationResponse fail(String msg) {
        ReservationResponse r = new ReservationResponse();
        r.setSuccess(false);
        r.setMessage(msg);
        return r;
    }
}