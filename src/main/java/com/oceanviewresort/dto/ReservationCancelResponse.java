package com.oceanviewresort.dto;

public class ReservationCancelResponse {
    private boolean success;
    private String message;
    private String reservationNo;
    private String status;

    public ReservationCancelResponse() {}

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}