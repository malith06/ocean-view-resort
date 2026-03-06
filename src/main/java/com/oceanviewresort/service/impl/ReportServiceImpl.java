package com.oceanviewresort.service.impl;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.oceanviewresort.dao.ReportDao;
import com.oceanviewresort.service.ReportService;

public class ReportServiceImpl implements ReportService {

    private final ReportDao reportDao;

    public ReportServiceImpl(ReportDao reportDao) {
        this.reportDao = reportDao;
    }

    private Date[] parseRange(String fromDate, String toDate) {
        if (fromDate == null || fromDate.trim().isEmpty())
            throw new IllegalArgumentException("fromDate is required");
        if (toDate == null || toDate.trim().isEmpty())
            throw new IllegalArgumentException("toDate is required");

        LocalDate from = LocalDate.parse(fromDate.trim());
        LocalDate to = LocalDate.parse(toDate.trim());

        if (to.isBefore(from)) throw new IllegalArgumentException("toDate must be after fromDate");

        return new Date[]{ Date.valueOf(from), Date.valueOf(to) };
    }

    private String normalizeStatus(String status) {
        if (status == null) return "ALL";
        String s = status.trim().toUpperCase();
        if (s.isEmpty()) return "ALL";
        if (!s.equals("ALL") && !s.equals("ACTIVE") && !s.equals("CANCELLED")) return "ALL";
        return s;
    }

    @Override
    public List<Map<String, Object>> reservations(String fromDate, String toDate, String status) {
        Date[] range = parseRange(fromDate, toDate);
        return reportDao.reservationsByDateRange(range[0], range[1], normalizeStatus(status));
    }

    @Override
    public Map<String, Object> revenue(String fromDate, String toDate, String status) {
        Date[] range = parseRange(fromDate, toDate);
        return reportDao.revenueSummary(range[0], range[1], normalizeStatus(status));
    }

    @Override
    public List<Map<String, Object>> roomUsage(String fromDate, String toDate, String status) {
        Date[] range = parseRange(fromDate, toDate);
        return reportDao.roomTypeUsage(range[0], range[1], normalizeStatus(status));
    }

    @Override
    public int cancelledCount(String fromDate, String toDate) {
        Date[] range = parseRange(fromDate, toDate);
        return reportDao.cancelledCount(range[0], range[1]);
    }
}
