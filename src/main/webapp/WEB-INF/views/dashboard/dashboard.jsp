<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Dashboard");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    /* ── Welcome banner ── */
    .welcome-banner {
      background: linear-gradient(130deg, #0f3460 0%, #1a4a7a 55%, #1a4d7c 100%);
      border-radius: 16px;
      padding: 28px 30px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 20px;
      flex-wrap: wrap;
      position: relative;
      overflow: hidden;
      border: 1px solid rgba(14,165,233,0.15);
      margin-bottom: 18px;
    }

    .welcome-banner::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8, transparent);
    }

    .welcome-banner::after {
      content: '';
      position: absolute;
      right: -60px; bottom: -60px;
      width: 220px; height: 220px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.11) 0%, transparent 70%);
      pointer-events: none;
    }

    .welcome-text h2 {
      font-family: 'Playfair Display', sans-serif;
      font-size: 22px;
      font-weight: 800;
      color: #fff;
      margin: 0 0 5px;
      letter-spacing: -0.3px;
    }

    .welcome-text p {
      margin: 0;
      font-size: 13.5px;
      color: rgba(255,255,255,0.42);
    }

    .welcome-badge {
      display: flex;
      align-items: center;
      gap: 8px;
      background: rgba(14,165,233,0.14);
      border: 1px solid rgba(14,165,233,0.24);
      border-radius: 999px;
      padding: 8px 16px;
      font-size: 12.5px;
      font-weight: 600;
      color: #38bdf8;
      white-space: nowrap;
      position: relative;
      z-index: 1;
    }

    .live-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: #0ea5e9;
      animation: livePulse 2s ease-in-out infinite;
      flex-shrink: 0;
    }

    @keyframes livePulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50%       { opacity: 0.45; transform: scale(0.72); }
    }

    /* ── Metric cards ── */
    .metric-card {
      position: relative;
      overflow: hidden;
    }

    .metric-card::after {
      content: '';
      position: absolute;
      top: -28px; right: -28px;
      width: 100px; height: 100px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.06) 0%, transparent 70%);
      pointer-events: none;
    }

    .metric-icon {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      margin-bottom: 14px;
    }

    .metric-icon.blue  { background: rgba(14,165,233,0.10); }
    .metric-icon.green { background: rgba(16,185,129,0.10); }
    .metric-icon.amber { background: rgba(245,158,11,0.10); }

    .metric-label {
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: #64748b;
      margin-bottom: 6px;
    }

    .metric-number {
      font-family: 'Playfair Display', sans-serif;
      font-size: 38px;
      font-weight: 800;
      color: #0a1628;
      letter-spacing: -1.5px;
      line-height: 1;
      margin-bottom: 10px;
    }

    .metric-divider {
      height: 1px;
      background: rgba(15,30,60,0.06);
      margin: 10px 0;
    }

    .metric-sub {
      font-size: 12px;
      color: #94a3b8;
      line-height: 1.5;
    }

    /* ── Revenue card ── */
    .revenue-card {
      background: linear-gradient(135deg, #0f3460 0%, #1a4d7c 100%);
      border-color: rgba(14,165,233,0.14);
      position: relative;
      overflow: hidden;
    }

    .revenue-card::after {
      content: '';
      position: absolute;
      bottom: -50px; right: -50px;
      width: 200px; height: 200px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.10) 0%, transparent 70%);
      pointer-events: none;
    }

    .revenue-card .cardTitle {
      color: rgba(255,255,255,0.48);
    }

    .revenue-card .metric-sub {
      color: rgba(255,255,255,0.32);
    }

    .revenue-amount {
      font-family: 'Playfair Display', sans-serif;
      font-size: 28px;
      font-weight: 800;
      color: #fff;
      letter-spacing: -0.8px;
      line-height: 1.1;
      margin: 8px 0 8px;
      position: relative;
      z-index: 1;
    }

    /* ── Quick actions ── */
    .action-buttons {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-bottom: 16px;
    }

    .tip-box {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      background: rgba(14,165,233,0.05);
      border: 1.5px solid rgba(14,165,233,0.13);
      border-radius: 10px;
      padding: 12px 14px;
      font-size: 13px;
      color: #475569;
      line-height: 1.6;
    }

    .tip-icon { font-size: 15px; flex-shrink: 0; margin-top: 2px; }

  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/partials/header.jsp" />

  <!-- Welcome banner -->
  <div class="welcome-banner">
    <div class="welcome-text">
      <h2>Dashboard Analytics</h2>
      <p>Quick overview of today's operations and monthly revenue.</p>
    </div>
    <div class="welcome-badge">
      <span class="live-dot"></span>
      Live Data
    </div>
  </div>

  <!-- 3 metric cards -->
  <div class="grid three" style="margin-bottom:18px;">

    <div class="card metric-card">
      <div class="metric-icon blue">📥</div>
      <div class="metric-label">Today's Check-ins</div>
      <div class="metric-number" id="m_in">—</div>
      <div class="metric-divider"></div>
      <div class="metric-sub">ACTIVE reservations starting today</div>
    </div>

    <div class="card metric-card">
      <div class="metric-icon green">📤</div>
      <div class="metric-label">Today's Check-outs</div>
      <div class="metric-number" id="m_out">—</div>
      <div class="metric-divider"></div>
      <div class="metric-sub">ACTIVE reservations ending today</div>
    </div>

    <div class="card metric-card">
      <div class="metric-icon amber">📋</div>
      <div class="metric-label">Active Reservations</div>
      <div class="metric-number" id="m_active">—</div>
      <div class="metric-divider"></div>
      <div class="metric-sub">All active bookings in the system</div>
    </div>

  </div>

  <!-- Revenue + Quick actions -->
  <div class="grid two">

    <div class="card revenue-card">
      <div class="cardTitle">Revenue This Month (ACTIVE)</div>
      <div class="revenue-amount" id="m_rev">—</div>
      <div class="metric-sub">Based on nights × rate for current month</div>
    </div>

    <div class="card">
      <div class="cardTitle">Quick Actions</div>
      <div class="action-buttons">
        <a class="btn primary" href="<%=request.getContextPath()%>/reservation">Add Reservation</a>
        <a class="btn ghost"   href="<%=request.getContextPath()%>/search">Search &amp; Billing</a>
        <a class="btn ghost"   href="<%=request.getContextPath()%>/reports">Reports</a>
      </div>
      <div class="tip-box">
        <span class="tip-icon">💡</span>
        <span>Tip: Use <b>Availability Check</b> on Add Reservation page to avoid conflicts.</span>
      </div>
    </div>

  </div>

  <jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
(function(){
  var inEl  = document.getElementById("m_in");
  var outEl = document.getElementById("m_out");
  var actEl = document.getElementById("m_active");
  var revEl = document.getElementById("m_rev");

  fetchJson(window.ctx + "/api/dashboard/metrics").then(function(data){
    if(!data || !data.success){
      showToast("error","Dashboard","Failed to load metrics");
      return;
    }

    inEl.textContent  = data.todayCheckIns;
    outEl.textContent = data.todayCheckOuts;
    actEl.textContent = data.activeReservations;

    var rev = Number(data.revenueThisMonth || 0);
    revEl.textContent = "LKR " + rev.toFixed(2);
  });
})();
</script>
</body>
</html>

