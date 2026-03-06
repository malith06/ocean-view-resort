package com.oceanviewresort.service.billing;

public class BillingStrategyFactory {

    private BillingStrategyFactory() {}

    public static BillingStrategy getStrategy(String roomType) {
    
        return new StandardBillingStrategy();
    }
}
