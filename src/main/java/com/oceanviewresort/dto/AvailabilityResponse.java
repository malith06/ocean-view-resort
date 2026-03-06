package com.oceanviewresort.dto;

public class AvailabilityResponse {
    private boolean success;
    private String message;

    private String roomType;
    private String checkIn;
    private String checkOut;

    private int capacity;
    private int booked;
    private int available;

    public AvailabilityResponse() {}

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getCheckIn() { return checkIn; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }

    public String getCheckOut() { return checkOut; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getBooked() { return booked; }
    public void setBooked(int booked) { this.booked = booked; }

    public int getAvailable() { return available; }
    public void setAvailable(int available) { this.available = available; }
}