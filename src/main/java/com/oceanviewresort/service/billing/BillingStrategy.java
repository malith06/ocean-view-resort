package com.oceanviewresort.service.billing;

import java.math.BigDecimal;

public interface BillingStrategy {
    BigDecimal calculateTotal(long nights, BigDecimal ratePerNight);
}
