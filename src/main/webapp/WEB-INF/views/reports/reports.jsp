<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Reports");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Reports</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    /* ── Page banner ── */
    .reports-banner {
      background: linear-gradient(130deg, #0f3460 0%, #1a4a7a 55%, #1a4d7c 100%);
      border-radius: 16px;
      padding: 24px 28px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      flex-wrap: wrap;
      position: relative;
      overflow: hidden;
      border: 1px solid rgba(14,165,233,0.15);
      margin-bottom: 20px;
    }

    .reports-banner::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8, transparent);
    }

    .reports-banner::after {
      content: '';
      position: absolute;
      right: -50px; bottom: -50px;
      width: 180px; height: 180px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.10) 0%, transparent 70%);
      pointer-events: none;
    }

    .reports-banner-text h2 {
      font-family: 'Playfair Display', sans-serif;
      font-size: 20px;
      font-weight: 800;
      color: #fff;
      margin: 0 0 4px;
      letter-spacing: -0.3px;
    }

    .reports-banner-text p {
      margin: 0;
      font-size: 13px;
      color: rgba(255,255,255,0.42);
    }

    .reports-badge {
      display: flex;
      align-items: center;
      gap: 7px;
      background: rgba(14,165,233,0.14);
      border: 1px solid rgba(14,165,233,0.24);
      border-radius: 999px;
      padding: 7px 15px;
      font-size: 12px;
      font-weight: 600;
      color: #38bdf8;
      white-space: nowrap;
      position: relative;
      z-index: 1;
    }

    /* ── Filter card ── */
    .filter-card .cardTitle {
      margin-bottom: 16px;
    }

    .filter-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 16px;
      padding-top: 16px;
      border-top: 1px solid rgba(15,30,60,0.07);
    }

    /* ── Summary cards inside right panel ── */
    .summary-block {
      margin-bottom: 20px;
    }

    .summary-block:last-child {
      margin-bottom: 0;
    }

    .summary-block-title {
      font-family: 'Playfair Display', sans-serif;
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: #64748b;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .summary-block-title::after {
      content: '';
      flex: 1;
      height: 1px;
      background: rgba(15,30,60,0.07);
    }

    /* ── Reservations table card ── */
    .reservations-card {
      margin-top: 18px;
    }

    .reservations-card .cardTitle {
      margin-bottom: 0;
    }

    .card-title-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
      margin-bottom: 4px;
    }

    /* ── Status badge inside table ── */
    .status-active {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      background: rgba(16,185,129,0.08);
      border: 1px solid rgba(16,185,129,0.20);
      border-radius: 999px;
      padding: 3px 10px;
      font-size: 11.5px;
      font-weight: 700;
      color: #059669;
    }

    .status-cancelled {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      background: rgba(239,68,68,0.07);
      border: 1px solid rgba(239,68,68,0.18);
      border-radius: 999px;
      padding: 3px 10px;
      font-size: 11.5px;
      font-weight: 700;
      color: #dc2626;
    }

    /* Revenue summary box styling */
    #revenueBox b, #cancelBox b {
      color: #0a1628;
    }

  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />

<!-- Page banner -->
<div class="reports-banner">
  <div class="reports-banner-text">
    <h2>Reports</h2>
    <p>Generate reservations, revenue, and room usage reports by date range.</p>
  </div>
  <div class="reports-badge">📊 Analytics</div>
</div>

<div class="grid two">

  <!-- LEFT: Filters -->
  <div class="card filter-card">
    <div class="cardTitle">Filters</div>

    <div class="row three">
      <div class="field">
        <label>From Date</label>
        <input type="date" id="fromDate">
      </div>

      <div class="field">
        <label>To Date</label>
        <input type="date" id="toDate">
      </div>

      <div class="field">
        <label>Status</label>
        <select id="statusFilter">
          <option value="ALL">All</option>
          <option value="ACTIVE">Active</option>
          <option value="CANCELLED">Cancelled</option>
        </select>
      </div>
    </div>

    <div class="filter-actions">
      <button class="btn primary" onclick="loadReservations()">📋 Reservations</button>
      <button class="btn ghost"   onclick="loadRevenue()">💰 Revenue</button>
      <button class="btn ghost"   onclick="loadRoomUsage()">🏨 Room Usage</button>
    </div>
  </div>

  <!-- RIGHT: Summary panels -->
  <div class="card">

    <div class="summary-block">
      <div class="summary-block-title">Revenue Summary</div>
      <div id="revenueBox" class="helpBox">No data</div>
    </div>

    <div class="summary-block">
      <div class="summary-block-title">Cancelled Count</div>
      <div id="cancelBox" class="helpBox">No data</div>
    </div>

    <div class="summary-block">
      <div class="summary-block-title">Room Type Usage</div>
      <div id="roomUsageTable" class="helpBox">No data</div>
    </div>

  </div>

</div>

<!-- Reservations table -->
<div class="card reservations-card">
  <div class="card-title-row">
    <div class="cardTitle">Reservations</div>
  </div>
  <div id="reservationsTable" class="helpBox" style="margin-top:12px;">No data</div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
function getRange(){
  var from   = document.getElementById("fromDate").value;
  var to     = document.getElementById("toDate").value;
  var status = document.getElementById("statusFilter").value;

  if(!from || !to){
    showToast("error","Missing dates","Select From and To dates.");
    return null;
  }
  return {from:from, to:to, status:status};
}

function fetchReport(type){
  var range = getRange();
  if(!range) return Promise.resolve(null);

  var url = window.ctx + "/api/reports?type=" + encodeURIComponent(type) +
            "&from="   + encodeURIComponent(range.from) +
            "&to="     + encodeURIComponent(range.to) +
            "&status=" + encodeURIComponent(range.status);

  return fetchJson(url);
}

function statusBadge(status){
  if(!status) return "";
  var s = status.toUpperCase();
  if(s === "ACTIVE")    return "<span class='status-active'>● ACTIVE</span>";
  if(s === "CANCELLED") return "<span class='status-cancelled'>● CANCELLED</span>";
  return "<b>" + s + "</b>";
}

function loadReservations(){
  fetchReport("reservations").then(function(data){
    var box = document.getElementById("reservationsTable");
    if(!data || !data.success){
      box.innerHTML = "<b>❌ " + (data ? data.message : "Error") + "</b>";
      return;
    }

    var rows = data.data || [];
    if(rows.length === 0){
      box.innerHTML = "No records found for the selected range.";
      return;
    }

    var html =
      "<table class='table'>" +
        "<thead><tr>" +
          "<th>No</th>" +
          "<th>Status</th>" +
          "<th>Guest</th>" +
          "<th>Contact</th>" +
          "<th>Room</th>" +
          "<th>Check-in</th>" +
          "<th>Check-out</th>" +
        "</tr></thead>" +
        "<tbody>";

    for(var i = 0; i < rows.length; i++){
      var r = rows[i];
      html += "<tr>" +
        "<td><b>" + (r.reservationNo || "") + "</b></td>" +
        "<td>" + statusBadge(r.status) + "</td>" +
        "<td>" + (r.guestName  || "") + "</td>" +
        "<td>" + (r.contactNo  || "") + "</td>" +
        "<td>" + (r.roomType   || "") + "</td>" +
        "<td>" + (r.checkIn    || "") + "</td>" +
        "<td>" + (r.checkOut   || "") + "</td>" +
      "</tr>";
    }

    html += "</tbody></table>";
    box.innerHTML = html;
    box.style.border = "none";
    box.style.padding = "0";
    box.style.background = "transparent";
    showToast("success","Loaded","Reservations report ready.");
  });
}

function loadRevenue(){
  fetchReport("revenue").then(function(data){
    var box = document.getElementById("revenueBox");
    if(!data || !data.success){
      box.innerHTML = "<b>❌ " + (data ? data.message : "Error") + "</b>";
      return;
    }
    var r = data.data || {};
    box.innerHTML =
      "<table class='table' style='margin-top:0;'>" +
        "<tr><td>Total Reservations</td><td style='text-align:right;'><b>" + (r.totalReservations ?? 0) + "</b></td></tr>" +
        "<tr><td>Total Nights</td><td style='text-align:right;'><b>" + (r.totalNights ?? 0) + "</b></td></tr>" +
        "<tr style='background:rgba(14,165,233,0.04);'>" +
          "<td style='font-weight:700;'>Total Revenue</td>" +
          "<td style='text-align:right;font-family:'Playfair Display',sans-serif;font-weight:800;color:#0ea5e9;'>Rs. " + (r.totalRevenue ?? 0) + "</td>" +
        "</tr>" +
      "</table>";
    box.style.border  = "none";
    box.style.padding = "0";
    box.style.background = "transparent";
  });

  // cancelled count — no status filter
  var range = getRange();
  if(!range) return;

  var url = window.ctx + "/api/reports?type=cancelledCount" +
            "&from=" + encodeURIComponent(range.from) +
            "&to="   + encodeURIComponent(range.to);

  fetchJson(url).then(function(data){
    var box = document.getElementById("cancelBox");
    if(!data || !data.success){
      box.innerHTML = "<b>❌ " + (data ? data.message : "Error") + "</b>";
      return;
    }
    box.innerHTML =
      "<div style='font-family:'Playfair Display',sans-serif;font-size:28px;font-weight:800;color:#0a1628;line-height:1;margin-bottom:4px;'>" +
        data.data +
      "</div>" +
      "<div style='font-size:12px;color:#94a3b8;'>cancellations in selected period</div>";
    box.style.border  = "none";
    box.style.padding = "0";
    box.style.background = "transparent";
  });
}

function loadRoomUsage(){
  fetchReport("roomUsage").then(function(data){
    var box = document.getElementById("roomUsageTable");
    if(!data || !data.success){
      box.innerHTML = "<b>❌ " + (data ? data.message : "Error") + "</b>";
      return;
    }
    var rows = data.data || [];
    if(rows.length === 0){
      box.innerHTML = "No records found.";
      return;
    }
    var html =
      "<table class='table' style='margin-top:0;'>" +
        "<thead><tr><th>Room Type</th><th style='text-align:right;'>Bookings</th></tr></thead>" +
        "<tbody>";
    for(var i = 0; i < rows.length; i++){
      html +=
        "<tr>" +
          "<td>" + rows[i].roomType + "</td>" +
          "<td style='text-align:right;font-weight:700;'>" + rows[i].count + "</td>" +
        "</tr>";
    }
    html += "</tbody></table>";
    box.innerHTML = html;
    box.style.border  = "none";
    box.style.padding = "0";
    box.style.background = "transparent";
  });
}
</script>
</body>
</html>

