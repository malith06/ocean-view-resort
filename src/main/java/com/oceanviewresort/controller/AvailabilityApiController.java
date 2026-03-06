package com.oceanviewresort.controller;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dao.impl.ReservationDaoImpl;
import com.oceanviewresort.dao.impl.RoomRateDaoImpl;
import com.oceanviewresort.dto.AvailabilityResponse;
import com.oceanviewresort.service.AvailabilityService;
import com.oceanviewresort.service.impl.AvailabilityServiceImpl;

@WebServlet("/api/availability")
public class AvailabilityApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private AvailabilityService service;

    @Override
    public void init() {
        ReservationDao reservationDao = new ReservationDaoImpl();
        RoomRateDao roomRateDao = new RoomRateDaoImpl();
        service = new AvailabilityServiceImpl(reservationDao, roomRateDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        String roomType = req.getParameter("roomType");
        String checkIn = req.getParameter("checkIn");
        String checkOut = req.getParameter("checkOut");

        AvailabilityResponse result = service.checkAvailability(roomType, checkIn, checkOut);
        resp.getWriter().write(gson.toJson(result));
    }
}