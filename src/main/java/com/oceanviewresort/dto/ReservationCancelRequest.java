package com.oceanviewresort.dto;

public class ReservationCancelRequest {
    private String reservationNo;
    private String reason;

    public ReservationCancelRequest() {}

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}