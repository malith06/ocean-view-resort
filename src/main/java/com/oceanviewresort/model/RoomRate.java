package com.oceanviewresort.model;

import java.math.BigDecimal;

public class RoomRate {
    private String roomType;
    private BigDecimal ratePerNight;

    public RoomRate() {}

    public RoomRate(String roomType, BigDecimal ratePerNight) {
        this.roomType = roomType;
        this.ratePerNight = ratePerNight;
    }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public BigDecimal getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(BigDecimal ratePerNight) { this.ratePerNight = ratePerNight; }
}
