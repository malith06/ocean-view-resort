package com.oceanviewresort.controller;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.oceanviewresort.dao.DashboardDao;
import com.oceanviewresort.dao.impl.DashboardDaoImpl;
import com.oceanviewresort.dto.DashboardMetricsResponse;
import com.oceanviewresort.service.DashboardService;
import com.oceanviewresort.service.impl.DashboardServiceImpl;

@WebServlet("/api/dashboard/metrics")
public class DashboardMetricsApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private DashboardService service;

    @Override
    public void init() {
        DashboardDao dao = new DashboardDaoImpl();
        service = new DashboardServiceImpl(dao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        DashboardMetricsResponse result = service.getMetrics();
        resp.getWriter().write(gson.toJson(result));
    }
}