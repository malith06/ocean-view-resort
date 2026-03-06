package com.oceanviewresort.service;

import java.util.List;
import java.util.Map;

public interface ReportService {
    List<Map<String, Object>> reservations(String fromDate, String toDate, String status);
    Map<String, Object> revenue(String fromDate, String toDate, String status);
    List<Map<String, Object>> roomUsage(String fromDate, String toDate, String status);

    int cancelledCount(String fromDate, String toDate);
}