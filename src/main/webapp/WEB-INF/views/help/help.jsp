<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Help");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Help</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    /* ── Page header ── */
    .help-banner {
      background: linear-gradient(130deg, #0f3460 0%, #1a4a7a 55%, #1a4d7c 100%);
      border-radius: 16px;
      padding: 26px 30px;
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

    .help-banner::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8, transparent);
    }

    .help-banner::after {
      content: '';
      position: absolute;
      right: -50px; bottom: -50px;
      width: 180px; height: 180px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.10) 0%, transparent 70%);
      pointer-events: none;
    }

    .help-banner-text h2 {
      font-family: 'Playfair Display', sans-serif;
      font-size: 21px;
      font-weight: 800;
      color: #fff;
      margin: 0 0 5px;
      letter-spacing: -0.3px;
    }

    .help-banner-text p {
      margin: 0;
      font-size: 13.5px;
      color: rgba(255,255,255,0.42);
    }

    .help-badge {
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

    /* ── Section cards ── */
    .help-section {
      display: flex;
      flex-direction: column;
      gap: 14px;
    }

    .help-block {
      background: #fff;
      border: 1px solid rgba(15,30,60,0.08);
      border-radius: 14px;
      box-shadow: 0 4px 12px rgba(13,27,42,0.06);
      overflow: hidden;
      transition: box-shadow 0.18s ease;
    }

    .help-block:hover {
      box-shadow: 0 8px 24px rgba(13,27,42,0.09);
    }

    .help-block-header {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 18px 20px;
      border-bottom: 1px solid rgba(15,30,60,0.07);
      background: #f8faff;
    }

    .help-step-badge {
      width: 32px;
      height: 32px;
      border-radius: 9px;
      background: linear-gradient(135deg, #0284c7, #0ea5e9);
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Playfair Display', sans-serif;
      font-size: 13px;
      font-weight: 800;
      color: #fff;
      flex-shrink: 0;
      box-shadow: 0 4px 10px rgba(14,165,233,0.28);
    }

    .help-step-badge.warning {
      background: linear-gradient(135deg, #d97706, #f59e0b);
      box-shadow: 0 4px 10px rgba(245,158,11,0.28);
    }

    .help-block-title {
      font-family: 'Playfair Display', sans-serif;
      font-size: 15px;
      font-weight: 800;
      color: #0a1628;
      letter-spacing: -0.1px;
    }

    .help-block-body {
      padding: 18px 20px;
    }

    .help-block-body ul {
      margin: 0;
      padding-left: 20px;
      display: flex;
      flex-direction: column;
      gap: 7px;
    }

    .help-block-body li {
      font-size: 14px;
      color: #334155;
      line-height: 1.6;
    }

    .help-block-body ul ul {
      margin-top: 6px;
      padding-left: 18px;
      gap: 5px;
    }

    .help-block-body ul ul li {
      font-size: 13.5px;
      color: #475569;
    }

    .help-note {
      display: flex;
      align-items: flex-start;
      gap: 9px;
      margin-top: 14px;
      background: rgba(14,165,233,0.05);
      border: 1.5px solid rgba(14,165,233,0.13);
      border-radius: 9px;
      padding: 11px 14px;
      font-size: 13px;
      color: #475569;
      line-height: 1.6;
    }

    .help-note-icon { font-size: 14px; flex-shrink: 0; margin-top: 2px; }

    /* Troubleshooting specific */
    .trouble-block .help-step-badge {
      background: linear-gradient(135deg, #64748b, #94a3b8);
      box-shadow: 0 4px 10px rgba(100,116,139,0.22);
    }

    .trouble-item {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      padding: 10px 0;
      border-bottom: 1px solid rgba(15,30,60,0.06);
    }

    .trouble-item:last-child { border-bottom: none; padding-bottom: 0; }
    .trouble-item:first-child { padding-top: 0; }

    .trouble-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: #0ea5e9;
      flex-shrink: 0;
      margin-top: 7px;
    }

    .trouble-item-text {
      font-size: 13.5px;
      color: #334155;
      line-height: 1.6;
    }

  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/partials/header.jsp" />

  <!-- Page banner -->
  <div class="help-banner">
    <div class="help-banner-text">
      <h2>Staff Help Guide</h2>
      <p>Follow these steps to use the Ocean View Resort Reservation System correctly.</p>
    </div>
    <div class="help-badge">📖 Reference Guide</div>
  </div>

  <div class="help-section">

    <!-- 1) Add Reservation -->
    <div class="help-block">
      <div class="help-block-header">
        <div class="help-step-badge">1</div>
        <div class="help-block-title">Add Reservation</div>
      </div>
      <div class="help-block-body">
        <ul>
          <li>Go to <b>Add Reservation</b> from the sidebar.</li>
          <li>Fill in <b>Guest Name</b>, <b>Contact Number</b>, and <b>Address</b>.</li>
          <li>Select a <b>Room Type</b> (Standard / Deluxe / Suite).</li>
          <li>Choose <b>Check-in</b> and <b>Check-out</b> dates.</li>
          <li>Click <b>Create Reservation</b>.</li>
          <li>The system will generate a unique <b>Reservation Number</b> (Example: <b>R0005</b>).</li>
        </ul>
        <div class="help-note">
          <span class="help-note-icon">⚠️</span>
          <span><b>Important:</b> Check-out must be after check-in. If the room type is fully booked for the dates, the system will show a "No availability" message.</span>
        </div>
      </div>
    </div>

    <!-- 2) Search Reservation -->
    <div class="help-block">
      <div class="help-block-header">
        <div class="help-step-badge">2</div>
        <div class="help-block-title">Search Reservation</div>
      </div>
      <div class="help-block-body">
        <ul>
          <li>Go to <b>Search &amp; Billing</b>.</li>
          <li>Enter the <b>Reservation Number</b> (Example: <b>R0005</b>).</li>
          <li>Click <b>Search</b>.</li>
          <li>The system displays guest details, room type, dates, and <b>Status</b>.</li>
        </ul>
        <div class="help-note">
          <span class="help-note-icon">ℹ️</span>
          <span><b>Status:</b> <b>ACTIVE</b> = valid booking, <b>CANCELLED</b> = booking cancelled. Cancelled reservations cannot generate bills.</span>
        </div>
      </div>
    </div>

    <!-- 3) Generate Bill & Print -->
    <div class="help-block">
      <div class="help-block-header">
        <div class="help-step-badge">3</div>
        <div class="help-block-title">Generate Bill &amp; Print</div>
      </div>
      <div class="help-block-body">
        <ul>
          <li>After searching an <b>ACTIVE</b> reservation, click <b>Generate Bill</b>.</li>
          <li>The bill shows:
            <ul>
              <li>Guest Name, Room Type, Dates</li>
              <li><b>Total Nights</b> (Check-out − Check-in)</li>
              <li><b>Rate per Night</b></li>
              <li><b>Total Amount</b> (Nights × Rate)</li>
            </ul>
          </li>
          <li>Click <b>Print Bill</b> to print the invoice.</li>
        </ul>
        <div class="help-note">
          <span class="help-note-icon">🚫</span>
          <span>If a reservation is <b>CANCELLED</b>, bill generation is blocked to prevent incorrect billing.</span>
        </div>
      </div>
    </div>

    <!-- 4) Reports -->
    <div class="help-block">
      <div class="help-block-header">
        <div class="help-step-badge">4</div>
        <div class="help-block-title">Reports</div>
      </div>
      <div class="help-block-body">
        <ul>
          <li>Go to <b>Reports</b> from the sidebar.</li>
          <li>Select <b>From Date</b> and <b>To Date</b>.</li>
          <li>Select a <b>Status Filter</b>:
            <ul>
              <li><b>ALL</b> = show both ACTIVE and CANCELLED</li>
              <li><b>ACTIVE</b> = show only active reservations</li>
              <li><b>CANCELLED</b> = show only cancelled reservations</li>
            </ul>
          </li>
          <li>Click the report buttons:
            <ul>
              <li><b>Reservations</b> → list of bookings in that date range with status</li>
              <li><b>Revenue</b> → totals (reservations, nights, revenue)</li>
              <li><b>Room Usage</b> → how many bookings per room type</li>
            </ul>
          </li>
        </ul>
        <div class="help-note">
          <span class="help-note-icon">💡</span>
          <span>Tip: Use <b>ALL</b> to audit cancellations and <b>ACTIVE</b> for accurate revenue reporting.</span>
        </div>
      </div>
    </div>

    <!-- 5) Logout -->
    <div class="help-block">
      <div class="help-block-header">
        <div class="help-step-badge">5</div>
        <div class="help-block-title">Logout</div>
      </div>
      <div class="help-block-body">
        <ul>
          <li>Click <b>Logout</b> from the sidebar when you finish work.</li>
          <li>This securely ends your session and protects staff access.</li>
        </ul>
      </div>
    </div>

    <!-- Troubleshooting -->
    <div class="help-block trouble-block">
      <div class="help-block-header">
        <div class="help-step-badge" style="background:linear-gradient(135deg,#64748b,#94a3b8);box-shadow:0 4px 10px rgba(100,116,139,0.22);">⚙</div>
        <div class="help-block-title">Troubleshooting (Common Issues)</div>
      </div>
      <div class="help-block-body">
        <div class="trouble-item">
          <div class="trouble-dot"></div>
          <div class="trouble-item-text"><b>Reservation not found</b> → Check the reservation number format (Example: R0005).</div>
        </div>
        <div class="trouble-item">
          <div class="trouble-dot"></div>
          <div class="trouble-item-text"><b>No availability</b> → Room type is fully booked for the chosen dates. Try different dates or room type.</div>
        </div>
        <div class="trouble-item">
          <div class="trouble-dot"></div>
          <div class="trouble-item-text"><b>Bill disabled</b> → Reservation is CANCELLED. Only ACTIVE bookings can generate bills.</div>
        </div>
        <div class="trouble-item">
          <div class="trouble-dot"></div>
          <div class="trouble-item-text"><b>Date errors</b> → Check-out must be after check-in.</div>
        </div>
      </div>
    </div>

  </div>

  <jsp:include page="/WEB-INF/views/partials/footer.jsp" />
</body>
</html>

