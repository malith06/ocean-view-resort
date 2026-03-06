package com.oceanviewresort.dao;

import java.math.BigDecimal;

public interface DashboardDao {
    int countTodayCheckIns();
    int countTodayCheckOuts();
    int countActiveReservations();
    BigDecimal revenueThisMonthActiveOnly();
}