<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Search & Billing");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Search</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    /* ── Page banner ── */
    .search-banner {
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

    .search-banner::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8, transparent);
    }

    .search-banner::after {
      content: '';
      position: absolute;
      right: -50px; bottom: -50px;
      width: 180px; height: 180px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.10) 0%, transparent 70%);
      pointer-events: none;
    }

    .search-banner-text h2 {
      font-family: 'Playfair Display', sans-serif;
      font-size: 20px;
      font-weight: 800;
      color: #fff;
      margin: 0 0 4px;
      letter-spacing: -0.3px;
    }

    .search-banner-text p {
      margin: 0;
      font-size: 13px;
      color: rgba(255,255,255,0.42);
    }

    .search-badge {
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

    /* ── Search input row ── */
    .search-input-row {
      display: flex;
      align-items: flex-end;
      gap: 12px;
      flex-wrap: wrap;
      margin-bottom: 20px;
      padding-bottom: 20px;
      border-bottom: 1px solid rgba(15,30,60,0.07);
    }

    .search-input-row .field {
      flex: 1;
      min-width: 200px;
    }

    .btn-group {
      display: flex;
      gap: 10px;
      padding-bottom: 2px;
    }

    /* ── Result area ── */
    #result { min-height: 60px; }

    /* ── Res number + status header ── */
    .res-detail-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 14px;
      flex-wrap: wrap;
      padding-bottom: 16px;
      border-bottom: 1px solid rgba(15,30,60,0.07);
      margin-bottom: 16px;
    }

    .res-no-label {
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: #64748b;
      margin-bottom: 3px;
    }

    .res-no-value {
      font-family: 'Playfair Display', sans-serif;
      font-size: 26px;
      font-weight: 800;
      color: #0ea5e9;
      letter-spacing: -0.5px;
      line-height: 1;
    }

    /* Status pills */
    .status-pill-active {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: rgba(16,185,129,0.08);
      border: 1.5px solid rgba(16,185,129,0.22);
      border-radius: 999px;
      padding: 6px 16px;
      font-size: 12.5px;
      font-weight: 700;
      color: #059669;
    }

    .status-pill-cancelled {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: rgba(239,68,68,0.07);
      border: 1.5px solid rgba(239,68,68,0.20);
      border-radius: 999px;
      padding: 6px 16px;
      font-size: 12.5px;
      font-weight: 700;
      color: #dc2626;
    }

    .status-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: currentColor;
      flex-shrink: 0;
    }

    /* ── Cancel info box ── */
    .cancel-info-box {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      background: rgba(239,68,68,0.04);
      border: 1.5px solid rgba(239,68,68,0.14);
      border-radius: 10px;
      padding: 12px 14px;
      margin-bottom: 14px;
      font-size: 13px;
      color: #334155;
      line-height: 1.65;
    }

    /* ── Result action buttons ── */
    .result-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 16px;
      padding-top: 16px;
      border-top: 1px solid rgba(15,30,60,0.07);
    }

  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/partials/header.jsp" />

  <!-- Page banner -->
  <div class="search-banner">
    <div class="search-banner-text">
      <h2>Search &amp; Billing</h2>
      <p>Enter a reservation number to view details and manage the booking.</p>
    </div>
    <div class="search-badge">🔍 Lookup</div>
  </div>

 
  <div class="card">

    <form id="searchForm" class="no-print">
      <div class="search-input-row">
        <div class="field">
          <label>Reservation Number</label>
          <input name="reservationNo" placeholder="e.g. R0001" required>
        </div>
        <div class="btn-group">
          <button class="btn primary" type="submit">Search</button>
          <a class="btn ghost" href="<%=request.getContextPath()%>/reservation">Add</a>
        </div>
      </div>
    </form>

    <div id="result" class="helpBox">No result yet.</div>

  </div>

  <jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
(function(){
  var form = document.getElementById("searchForm");
  if(!form) return;

  form.addEventListener("submit", function(e){
    e.preventDefault();
    var no = new FormData(form).get("reservationNo");

    fetchJson(window.ctx + "/api/reservations?reservationNo=" + encodeURIComponent(no))
      .then(function(data){
        var result = document.getElementById("result");

        if(data && data.success){

          var status      = (data.status || "ACTIVE").toUpperCase();
          var isCancelled = (status === "CANCELLED");

          /* Status pill */
          var statusPill = isCancelled
            ? "<span class='status-pill-cancelled'><span class='status-dot'></span> CANCELLED</span>"
            : "<span class='status-pill-active'><span class='status-dot'></span> ACTIVE</span>";

          /* Action buttons */
          var billBtn = isCancelled
            ? "<button class='btn ghost' type='button' disabled style='opacity:.5;cursor:not-allowed;'>Bill Disabled</button>"
            : "<a class='btn primary' href='" + window.ctx + "/bill?reservationNo=" + encodeURIComponent(data.reservationNo) + "'>Generate Bill</a>";

          var editBtn = isCancelled
            ? "<button class='btn ghost' type='button' disabled style='opacity:.5;cursor:not-allowed;'>Edit Disabled</button>"
            : "<a class='btn ghost' href='" + window.ctx + "/edit?reservationNo=" + encodeURIComponent(data.reservationNo) + "'>Edit</a>";

          var cancelBtn = isCancelled
            ? ""
            : "<button class='btn danger' type='button' onclick='cancelReservation(\"" + data.reservationNo + "\")'>Cancel</button>";

          /* Cancel info block */
          var cancelInfoBlock = "";
          if(isCancelled){
            cancelInfoBlock =
              "<div class='cancel-info-box'>" +
                "<span style='font-size:18px;flex-shrink:0;'>🚫</span>" +
                "<div>" +
                  "<div style='font-weight:700;color:#991b1b;margin-bottom:3px;'>Reservation Cancelled</div>" +
                  "<div><span style='color:#64748b;'>Reason:</span> " + (data.cancelReason || "-") + "</div>" +
                  "<div><span style='color:#64748b;'>Cancelled At:</span> " + (data.cancelledAt || "-") + "</div>" +
                "</div>" +
              "</div>";
          }

          /* Clear helpBox styling */
          result.className = "";
          result.style.border     = "none";
          result.style.padding    = "0";
          result.style.background = "transparent";

          result.innerHTML =
            /* Res No + Status pill header */
            "<div class='res-detail-header'>" +
              "<div>" +
                "<div class='res-no-label'>Reservation No</div>" +
                "<div class='res-no-value'>" + data.reservationNo + "</div>" +
              "</div>" +
              statusPill +
            "</div>" +

            /* Cancel info (only if cancelled) */
            cancelInfoBlock +

            /* Details table */
            "<table class='table' style='margin-top:0;'>" +
              "<tr><td style='color:#64748b;width:36%;'>Guest Name</td><td><b>" + data.guestName + "</b></td></tr>" +
              "<tr><td style='color:#64748b;'>Contact</td><td>" + data.contactNo + "</td></tr>" +
              "<tr><td style='color:#64748b;'>Address</td><td>" + data.address + "</td></tr>" +
              "<tr><td style='color:#64748b;'>Room Type</td><td><b>" + data.roomType + "</b></td></tr>" +
              "<tr><td style='color:#64748b;'>Dates</td><td>" + data.checkIn + " → " + data.checkOut + "</td></tr>" +
            "</table>" +

            /* Action buttons */
            "<div class='result-actions no-print'>" +
              billBtn +
              editBtn +
              cancelBtn +
              "<button class='btn ghost' type='button' onclick='window.print()'>🖨 Print</button>" +
            "</div>";

          showToast("success","Found","Reservation loaded.");

        } else {
          result.className        = "helpBox";
          result.style.border     = "";
          result.style.padding    = "";
          result.style.background = "";
          result.innerHTML = "<b>❌ " + ((data && data.message) ? data.message : "Not found") + "</b>";
          showToast("error","Not found", (data && data.message) ? data.message : "Try again");
        }
      });
  });
})();

function cancelReservation(resNo){
  var reason = prompt("Enter cancel reason:");
  if(reason === null) return;

  reason = (reason || "").trim();
  if(reason.length === 0){
    showToast("error","Reason required","Please enter a reason.");
    return;
  }

  var body = new URLSearchParams();
  body.append("reservationNo", resNo);
  body.append("reason", reason);

  fetchJson(window.ctx + "/api/reservations/cancel", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
    body: body.toString()
  }).then(function(data){
    if(data && data.success){
      showToast("success","Cancelled", data.message);

      var input = document.querySelector("[name='reservationNo']");
      if(input) input.value = resNo;

      var form = document.getElementById("searchForm");
      if(form) form.dispatchEvent(new Event("submit"));
    } else {
      showToast("error","Failed", (data && data.message) ? data.message : "Cancel failed");
    }
  });
}
</script>
</body>
</html>

