package com.oceanviewresort.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.impl.ReservationDaoImpl;
import com.oceanviewresort.dto.ReservationResponse;
import com.oceanviewresort.dto.ReservationUpdateRequest;
import com.oceanviewresort.exception.ValidationException;
import com.oceanviewresort.service.ReservationService;
import com.oceanviewresort.service.impl.ReservationServiceImpl;

@WebServlet("/api/reservations/update")
public class ReservationUpdateApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private ReservationService reservationService;

    @Override
    public void init() {
        ReservationDao dao = new ReservationDaoImpl();
        reservationService = new ReservationServiceImpl(dao);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        try {
            ReservationUpdateRequest r = new ReservationUpdateRequest();
            r.setReservationNo(req.getParameter("reservationNo"));
            r.setGuestName(req.getParameter("guestName"));
            r.setAddress(req.getParameter("address"));
            r.setContactNo(req.getParameter("contactNo"));
            r.setRoomType(req.getParameter("roomType"));
            r.setCheckIn(req.getParameter("checkIn"));
            r.setCheckOut(req.getParameter("checkOut"));

            ReservationResponse result = reservationService.updateReservation(r);
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