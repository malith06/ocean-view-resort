package com.oceanviewresort.dao;

import java.sql.Date;
import java.util.List;
import java.util.Map;

public interface ReportDao {

    List<Map<String, Object>> reservationsByDateRange(Date from, Date to, String statusFilter);

    Map<String, Object> revenueSummary(Date from, Date to, String statusFilter);

    List<Map<String, Object>> roomTypeUsage(Date from, Date to, String statusFilter);

    int cancelledCount(Date from, Date to);
}