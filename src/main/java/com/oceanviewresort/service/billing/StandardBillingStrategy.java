package com.oceanviewresort.service.billing;

import java.math.BigDecimal;

public class StandardBillingStrategy implements BillingStrategy {

    @Override
    public BigDecimal calculateTotal(long nights, BigDecimal ratePerNight) {
        if (nights <= 0) return BigDecimal.ZERO;
        if (ratePerNight == null) return BigDecimal.ZERO;
        return ratePerNight.multiply(BigDecimal.valueOf(nights));
    }
}
