package com.oceanviewresort.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.Gson;
import com.oceanviewresort.dao.ReservationAuditDao;
import com.oceanviewresort.dao.ReservationDao;
import com.oceanviewresort.dao.RoomRateDao;
import com.oceanviewresort.dao.impl.ReservationAuditDaoImpl;
import com.oceanviewresort.dao.impl.ReservationDaoImpl;
import com.oceanviewresort.dao.impl.RoomRateDaoImpl;
import com.oceanviewresort.dto.ReservationCancelRequest;
import com.oceanviewresort.dto.ReservationCancelResponse;
import com.oceanviewresort.service.ReservationService;
import com.oceanviewresort.service.impl.ReservationServiceImpl;

@WebServlet("/api/reservations/cancel")
public class ReservationCancelApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private ReservationService reservationService;

    @Override
    public void init() {
        ReservationDao reservationDao = new ReservationDaoImpl();
        RoomRateDao roomRateDao = new RoomRateDaoImpl();          
        ReservationAuditDao auditDao = new ReservationAuditDaoImpl();

        
        this.reservationService = new ReservationServiceImpl(reservationDao, roomRateDao, auditDao);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        try {
            String reservationNo = req.getParameter("reservationNo");
            String reason = req.getParameter("reason");

            String actionBy = null;
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                actionBy = String.valueOf(session.getAttribute("user"));
            }

            ReservationCancelRequest cr = new ReservationCancelRequest();
            cr.setReservationNo(reservationNo);
            cr.setReason(reason);

            ReservationCancelResponse result = reservationService.cancelReservation(cr, actionBy);
            resp.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Server error: " + e.getMessage());
            resp.setStatus(500);
            resp.getWriter().write(gson.toJson(error));
        }
    }
}