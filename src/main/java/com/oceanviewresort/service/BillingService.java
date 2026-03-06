package com.oceanviewresort.service;

import com.oceanviewresort.dto.BillResponse;

public interface BillingService {
    BillResponse generateBill(String reservationNo);
}
