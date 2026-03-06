package com.oceanviewresort.service;

import com.oceanviewresort.dto.AvailabilityResponse;

public interface AvailabilityService {
    AvailabilityResponse checkAvailability(String roomType, String checkIn, String checkOut);
}