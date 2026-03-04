<%@ page contentType="text/html; charset=UTF-8" %>
<%
  Object user = session.getAttribute("user");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login");
  } else {
    response.sendRedirect(request.getContextPath() + "/reservation");
  }
%>