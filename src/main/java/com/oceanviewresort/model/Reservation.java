package com.oceanviewresort.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Reservation {
    private int id;
    private String reservationNo;
    private String guestName;
    private String address;
    private String contactNo;
    private String roomType;
    private LocalDate checkIn;
    private LocalDate checkOut;
    private LocalDateTime createdAt;
    private String status;       
    private String cancelReason;
    private LocalDateTime cancelledAt;

    public Reservation() {}

    public Reservation(int id, String reservationNo, String guestName, String address, String contactNo,
                       String roomType, LocalDate checkIn, LocalDate checkOut,
                       LocalDateTime createdAt, String status, String cancelReason, LocalDateTime cancelledAt) {
        this.id = id;
        this.reservationNo = reservationNo;
        this.guestName = guestName;
        this.address = address;
        this.contactNo = contactNo;
        this.roomType = roomType;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.createdAt = createdAt;
        this.status = status;
        this.cancelReason = cancelReason;
        this.cancelledAt = cancelledAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNo() { return contactNo; }
    public void setContactNo(String contactNo) { this.contactNo = contactNo; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public LocalDate getCheckIn() { return checkIn; }
    public void setCheckIn(LocalDate checkIn) { this.checkIn = checkIn; }

    public LocalDate getCheckOut() { return checkOut; }
    public void setCheckOut(LocalDate checkOut) { this.checkOut = checkOut; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }

    public LocalDateTime getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(LocalDateTime cancelledAt) { this.cancelledAt = cancelledAt; }
}
