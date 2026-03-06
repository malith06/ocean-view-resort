package com.oceanviewresort.controller;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.impl.ReservationDaoImpl;
import com.oceanviewresort.dto.ReservationCreateRequest;
import com.oceanviewresort.dto.ReservationResponse;
import com.oceanviewresort.exception.ValidationException;
import com.oceanviewresort.service.ReservationService;
import com.oceanviewresort.service.impl.ReservationServiceImpl;

import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/reservations")
public class ReservationApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private ReservationService reservationService;

    @Override
    public void init() {
        ReservationDao reservationDao = new ReservationDaoImpl();
        this.reservationService = new ReservationServiceImpl(reservationDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        String reservationNo = req.getParameter("reservationNo");
        if (reservationNo != null) reservationNo = reservationNo.trim();

        ReservationResponse result = reservationService.getReservationByNo(reservationNo);
        resp.getWriter().write(gson.toJson(result));
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        try {
            ReservationCreateRequest r = new ReservationCreateRequest();
            r.setGuestName(req.getParameter("guestName"));
            r.setAddress(req.getParameter("address"));
            r.setContactNo(req.getParameter("contactNo"));
            r.setRoomType(req.getParameter("roomType"));
            r.setCheckIn(req.getParameter("checkIn"));
            r.setCheckOut(req.getParameter("checkOut"));

            ReservationResponse result = reservationService.createReservation(r);
            resp.getWriter().write(gson.toJson(result));

        } catch (ValidationException ve) {
            Map<String, Object> errorRes = new HashMap<>();
            errorRes.put("success", false);
            errorRes.put("message", "Validation failed");
            errorRes.put("errors", ve.getErrors());

            resp.setStatus(400);
            resp.getWriter().write(gson.toJson(errorRes));

        } catch (Exception e) {
            Map<String, Object> errorRes = new HashMap<>();
            errorRes.put("success", false);
            errorRes.put("message", "Server error: " + e.getMessage());

            resp.setStatus(500);
            resp.getWriter().write(gson.toJson(errorRes));
        }
    }
}

