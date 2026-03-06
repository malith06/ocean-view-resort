package com.oceanviewresort.service;

import com.oceanviewresort.dto.ReservationCancelRequest;
import com.oceanviewresort.dto.ReservationCancelResponse;
import com.oceanviewresort.dto.ReservationCreateRequest;
import com.oceanviewresort.dto.ReservationResponse;
import com.oceanviewresort.dto.ReservationUpdateRequest;

public interface ReservationService {
    ReservationResponse createReservation(ReservationCreateRequest req);
    ReservationResponse getReservationByNo(String reservationNo);
    ReservationResponse updateReservation(ReservationUpdateRequest req);
    ReservationCancelResponse cancelReservation(ReservationCancelRequest req, String actionBy);
}