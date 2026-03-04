<%@ page contentType="text/html; charset=UTF-8" %>

  </div> <%-- content --%>

<%
  Object userObj = session.getAttribute("user");
  boolean logged = (userObj != null);
%>

<% if(logged){ %>
  </div> <%-- main --%>
</div> <%-- app --%>
<% } %>

<!-- Toast -->
<div id="toast" class="toast no-print">
  <div class="t">Title</div>
  <div class="m">Message</div>
</div>

<!-- Footer bar -->
<div class="no-print" style="
  text-align: center;
  padding: 18px 0 26px;
  color: #94a3b8;
  font-size: 12px;
  font-family: 'Outfit', sans-serif;
  letter-spacing: 0.02em;
  border-top: 1px solid rgba(15,30,60,0.07);
  margin-top: 12px;
">
  <span style="color:#cbd5e1;">©</span>
  <%= java.time.Year.now() %>
  <span style="color:#0ea5e9; font-weight:700;">Ocean View Resort</span>
  <span style="color:#cbd5e1; margin:0 8px;">•</span>
  Reservation Management System
</div>

<script src="<%=request.getContextPath()%>/assets/js/app.js"></script>
<script>
  window.ctx = "<%=request.getContextPath()%>";
</script>

