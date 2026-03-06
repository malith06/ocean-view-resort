package com.oceanviewresort.service.impl;

import java.math.BigDecimal;

import com.oceanviewresort.dao.DashboardDao;
import com.oceanviewresort.dto.DashboardMetricsResponse;
import com.oceanviewresort.service.DashboardService;

public class DashboardServiceImpl implements DashboardService {

    private final DashboardDao dashboardDao;

    public DashboardServiceImpl(DashboardDao dashboardDao) {
        this.dashboardDao = dashboardDao;
    }

    @Override
    public DashboardMetricsResponse getMetrics() {
        DashboardMetricsResponse res = new DashboardMetricsResponse();
        try {
            int in = dashboardDao.countTodayCheckIns();
            int out = dashboardDao.countTodayCheckOuts();
            int active = dashboardDao.countActiveReservations();
            BigDecimal revenue = dashboardDao.revenueThisMonthActiveOnly();

            res.setSuccess(true);
            res.setMessage("OK");
            res.setTodayCheckIns(in);
            res.setTodayCheckOuts(out);
            res.setActiveReservations(active);
            res.setRevenueThisMonth(revenue);
            return res;

        } catch (Exception e) {
            res.setSuccess(false);
            res.setMessage("Failed: " + e.getMessage());
            res.setTodayCheckIns(0);
            res.setTodayCheckOuts(0);
            res.setActiveReservations(0);
            res.setRevenueThisMonth(BigDecimal.ZERO);
            return res;
        }
    }
}