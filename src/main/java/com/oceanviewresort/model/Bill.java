package com.oceanviewresort.model;

import java.math.BigDecimal;

public class Bill {
    private String reservationNo;
    private String guestName;
    private String roomType;

    private long nights;
    private BigDecimal ratePerNight;
    private BigDecimal totalAmount;

    public Bill() {}

    public Bill(String reservationNo, String guestName, String roomType,
                long nights, BigDecimal ratePerNight, BigDecimal totalAmount) {
        this.reservationNo = reservationNo;
        this.guestName = guestName;
        this.roomType = roomType;
        this.nights = nights;
        this.ratePerNight = ratePerNight;
        this.totalAmount = totalAmount;
    }

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public long getNights() { return nights; }
    public void setNights(long nights) { this.nights = nights; }

    public BigDecimal getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(BigDecimal ratePerNight) { this.ratePerNight = ratePerNight; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}
