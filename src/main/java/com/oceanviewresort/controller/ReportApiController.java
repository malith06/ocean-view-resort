package com.oceanviewresort.controller;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.oceanviewresort.dao.ReportDao;
import com.oceanviewresort.dao.impl.ReportDaoImpl;
import com.oceanviewresort.dto.report.ApiResponse;
import com.oceanviewresort.service.ReportService;
import com.oceanviewresort.service.impl.ReportServiceImpl;

@WebServlet("/api/reports")
public class ReportApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private ReportService reportService;

    @Override
    public void init() {
        ReportDao dao = new ReportDaoImpl();
        reportService = new ReportServiceImpl(dao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        String type = req.getParameter("type");
        String from = req.getParameter("from");
        String to = req.getParameter("to");
        String status = req.getParameter("status"); // ✅ NEW

        try {
            if (type == null) throw new IllegalArgumentException("type is required");

            switch (type) {
                case "reservations":
                    resp.getWriter().write(gson.toJson(
                        new ApiResponse<>(true, "OK", reportService.reservations(from, to, status))
                    ));
                    break;

                case "revenue":
                    resp.getWriter().write(gson.toJson(
                        new ApiResponse<>(true, "OK", reportService.revenue(from, to, status))
                    ));
                    break;

                case "roomUsage":
                    resp.getWriter().write(gson.toJson(
                        new ApiResponse<>(true, "OK", reportService.roomUsage(from, to, status))
                    ));
                    break;

                case "cancelledCount":
                    resp.getWriter().write(gson.toJson(
                        new ApiResponse<>(true, "OK", reportService.cancelledCount(from, to))
                    ));
                    break;

                default:
                    throw new IllegalArgumentException("Invalid type");
            }

        } catch (Exception e) {
            resp.setStatus(400);
            resp.getWriter().write(gson.toJson(
                new ApiResponse<>(false, e.getMessage(), null)
            ));
        }
    }
}