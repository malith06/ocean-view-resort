package com.oceanviewresort.controller;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dao.impl.ReservationDaoImpl;
import com.oceanviewresort.dao.impl.RoomRateDaoImpl;
import com.oceanviewresort.dto.BillResponse;
import com.oceanviewresort.service.BillingService;
import com.oceanviewresort.service.impl.BillingServiceImpl;

@WebServlet("/api/bill")
public class BillingApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private BillingService billingService;

    @Override
    public void init() {
        ReservationDao reservationDao = new ReservationDaoImpl();
        RoomRateDao roomRateDao = new RoomRateDaoImpl();
        this.billingService = new BillingServiceImpl(reservationDao, roomRateDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        String reservationNo = req.getParameter("reservationNo");

        BillResponse result = billingService.generateBill(reservationNo);
        resp.getWriter().write(gson.toJson(result));
    }
}