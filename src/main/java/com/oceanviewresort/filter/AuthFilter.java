package com.oceanviewresort.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        boolean isPublic =
                path.equals("/") ||
                path.equals("/index.jsp") ||
                path.equals("/login") ||
                path.equals("/help") ||
                path.startsWith("/assets/") ||
                path.equals("/db-test"); // optional debug

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        if (!loggedIn) {
            // ✅ If API request, return JSON (not redirect HTML)
            if (path.startsWith("/api/")) {
                resp.setStatus(401);
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Unauthorized. Please login.\"}");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
