<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String ctx = request.getContextPath();
  Object userObj = session.getAttribute("user");
  boolean logged = (userObj != null);

  String path = request.getRequestURI().substring(ctx.length());
  String pageTitle = (String) request.getAttribute("pageTitle");
  if(pageTitle == null) pageTitle = "Ocean View";

  String activeDash    = path.startsWith("/dashboard")   ? "active" : "";
  String activeAdd     = path.startsWith("/reservation")  ? "active" : "";
  String activeSearch  = path.startsWith("/search")       ? "active" : "";
  String activeReports = path.startsWith("/reports")      ? "active" : "";
  String activeHelp    = path.startsWith("/help")         ? "active" : "";
%>

<% if(!logged){ %>
  <!-- ── Not logged in: minimal topbar ── -->
  <div class="topbar no-print">
    <div class="topbarInner">
      <div style="display:flex;align-items:center;gap:12px;">
        <img src="<%=ctx%>/assets/img/logo.jpg" alt="Logo"
             style="width:34px;height:34px;object-fit:cover;border-radius:50%;box-shadow:0 2px 8px rgba(0,0,0,0.18);flex-shrink:0;">
        <div class="pageTitle">Ocean View</div>
      </div>
      <div>
        <a class="btn primary" href="<%=ctx%>/login">Login</a>
      </div>
    </div>
  </div>
  <div class="content">

<% } else { %>

<!-- ── Logged in: full app shell ── -->
<div class="app">

  <!-- Sidebar -->
  <aside class="sidebar no-print">

    <div class="brandBox">
      <img src="<%=ctx%>/assets/img/logo.jpg" alt="Ocean View Logo"
           style="width:44px;height:44px;object-fit:cover;border-radius:50%;flex-shrink:0;box-shadow:0 4px 12px rgba(0,0,0,0.25);">
      <div>
        <div class="brandName">Ocean View</div>
        <div class="brandSub">Staff Panel</div>
      </div>
    </div>

    <div class="navGroup">
      <a class="sideLink <%=activeDash%>"    href="<%=ctx%>/dashboard">
        <span class="sideDot"></span> Dashboard
      </a>
      <a class="sideLink <%=activeAdd%>"     href="<%=ctx%>/reservation">
        <span class="sideDot"></span> Add Reservation
      </a>
      <a class="sideLink <%=activeSearch%>"  href="<%=ctx%>/search">
        <span class="sideDot"></span> Search &amp; Billing
      </a>
      <a class="sideLink <%=activeReports%>" href="<%=ctx%>/reports">
        <span class="sideDot"></span> Reports
      </a>
      <a class="sideLink <%=activeHelp%>"    href="<%=ctx%>/help">
        <span class="sideDot"></span> Help
      </a>
    </div>

    <div class="sideFooter">
      Logged in as: <b><%= String.valueOf(userObj) %></b>
    </div>

    <a href="<%=ctx%>/logout" style="
      display:flex;
      align-items:center;
      justify-content:center;
      gap:9px;
      margin-top:14px;
      padding:13px 16px;
      border-radius:10px;
      background:rgba(239,68,68,0.15);
      border:1.5px solid rgba(239,68,68,0.35);
      color:#f87171;
      font-size:14px;
      font-weight:700;
      letter-spacing:0.01em;
      transition:all 0.18s ease;
      text-decoration:none;
    "
    onmouseover="this.style.background='rgba(239,68,68,0.28)';this.style.borderColor='rgba(239,68,68,0.60)';this.style.color='#fca5a5';"
    onmouseout="this.style.background='rgba(239,68,68,0.15)';this.style.borderColor='rgba(239,68,68,0.35)';this.style.color='#f87171';">
      <span style="font-size:15px;">⏻</span> Logout
    </a>

  </aside>

  <!-- Main -->
  <div class="main">

    <!-- Topbar — searchBox & topRight removed as requested -->
    <div class="topbar no-print">
      <div class="topbarInner">
        <div class="pageTitle"><%=pageTitle%></div>
      </div>
    </div>

    <div class="content">

<% } %>
