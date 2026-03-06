<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Bill");
  String reservationNo = request.getParameter("reservationNo");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Bill</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>
    /* ── Bill layout ── */
    .bill-wrapper {
      max-width: 720px;
      margin: 0 auto;
      display: flex;
      flex-direction: column;
      gap: 18px;
    }

    /* ── Page header bar ── */
    .bill-header-card {
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 14px;
    }

    .bill-header-left h2 {
      font-family: 'Syne', sans-serif;
      font-size: 22px;
      font-weight: 800;
      letter-spacing: -0.3px;
      color: #0d1b2a;
      margin: 0 0 4px;
    }

    .bill-header-left p {
      margin: 0;
      font-size: 13.5px;
      color: #64748b;
    }

    .bill-header-left p b {
      color: #0ea5e9;
      font-weight: 700;
      font-family: 'Syne', sans-serif;
      letter-spacing: 0.03em;
    }

    /* ── Loading / result box ── */
    #billBox {
      min-height: 120px;
    }

    /* ── Invoice card (injected by JS, styled via billBox children) ── */
    .invoice-top {
      display: flex;
      justify-content: space-between;
      gap: 16px;
      flex-wrap: wrap;
      padding-bottom: 18px;
      border-bottom: 1px solid rgba(15,30,60,0.08);
      margin-bottom: 18px;
    }

    .invoice-label {
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: #64748b;
      margin-bottom: 4px;
    }

    .invoice-value {
      font-family: 'Syne', sans-serif;
      font-size: 17px;
      font-weight: 800;
      color: #0d1b2a;
    }

    .invoice-value-sm {
      font-size: 14px;
      font-weight: 700;
      color: #0d1b2a;
    }

    /* ── Action buttons bar ── */
    .bill-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      align-items: center;
    }

    /* ── Thank-you banner ── */
    .thankyou-banner {
      display: flex;
      align-items: center;
      gap: 12px;
      background: linear-gradient(120deg, rgba(14,165,233,0.07), rgba(56,189,248,0.04));
      border: 1.5px solid rgba(14,165,233,0.18);
      border-radius: 10px;
      padding: 14px 18px;
      font-size: 14px;
      color: #0d1b2a;
      margin-top: 4px;
    }

    .thankyou-icon {
      font-size: 22px;
      flex-shrink: 0;
    }

    /* ── Print styles ── */
    @media print {
      .bill-wrapper { max-width: 100%; }
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/partials/header.jsp" />

  <div class="bill-wrapper">

    <!-- Header bar -->
    <div class="card bill-header-card">
      <div class="bill-header-left">
        <h2>Invoice</h2>
        <p>Reservation No: <b id="resNo"><%= reservationNo == null ? "" : reservationNo %></b></p>
      </div>
      <div class="bill-actions no-print">
        <button class="btn primary" type="button" onclick="window.print()">
          🖨 Print Bill
        </button>
        <a class="btn ghost" href="<%=request.getContextPath()%>/search">← Back</a>
      </div>
    </div>

    <!-- Bill content (populated by JS) -->
    <div class="card">
      <div id="billBox" class="helpBox">Loading bill...</div>
    </div>

  </div>

  <jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
(function(){
  var resNo = "<%= reservationNo == null ? "" : reservationNo %>";
  var box = document.getElementById("billBox");

  if(!resNo || resNo.trim()==="" || resNo==="null"){
    box.innerHTML = "<b>❌ Reservation number missing.</b>";
    return;
  }

  fetchJson(window.ctx + "/api/bill?reservationNo=" + encodeURIComponent(resNo))
    .then(function(data){
      if(data && data.success){

        var nights = Number(data.nights || 0);
        var rate   = Number(data.ratePerNight || 0);
        var total  = Number(data.total || data.totalAmount || 0);

        box.style.border = "none";
        box.style.background = "transparent";
        box.style.padding = "0";

        box.innerHTML =
          /* ── Guest + Date info row ── */
          "<div style='display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap;" +
               "padding-bottom:18px;border-bottom:1px solid rgba(15,30,60,0.08);margin-bottom:18px;'>" +

            "<div>" +
              "<div style='font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:#64748b;margin-bottom:4px;'>Guest</div>" +
              "<div style='font-family:Syne,sans-serif;font-size:18px;font-weight:800;color:#0d1b2a;'>" + (data.guestName || "-") + "</div>" +
              "<div style='margin-top:10px;font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:#64748b;margin-bottom:4px;'>Room Type</div>" +
              "<div style='font-size:14px;font-weight:700;color:#0d1b2a;'>" + (data.roomType || "-") + "</div>" +
            "</div>" +

            "<div style='text-align:right;'>" +
              "<div style='font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:#64748b;margin-bottom:4px;'>Check-in</div>" +
              "<div style='font-size:14px;font-weight:700;color:#0d1b2a;'>" + (data.checkIn || "-") + "</div>" +
              "<div style='margin-top:10px;font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:#64748b;margin-bottom:4px;'>Check-out</div>" +
              "<div style='font-size:14px;font-weight:700;color:#0d1b2a;'>" + (data.checkOut || "-") + "</div>" +
            "</div>" +

          "</div>" +

          /* ── Billing table ── */
          "<table class='table' style='margin-top:0;'>" +
            "<thead><tr>" +
              "<th>Description</th>" +
              "<th style='text-align:right;'>Amount</th>" +
            "</tr></thead>" +
            "<tbody>" +
              "<tr>" +
                "<td>Nights stayed</td>" +
                "<td style='text-align:right;font-weight:700;'>" + nights + " night" + (nights !== 1 ? "s" : "") + "</td>" +
              "</tr>" +
              "<tr>" +
                "<td>Rate per night</td>" +
                "<td style='text-align:right;font-weight:700;'>LKR " + rate.toFixed(2) + "</td>" +
              "</tr>" +
              "<tr style='background:rgba(14,165,233,0.04);'>" +
                "<td style='font-family:Syne,sans-serif;font-weight:800;font-size:15px;'>Total Amount</td>" +
                "<td style='text-align:right;font-family:Syne,sans-serif;font-weight:800;font-size:17px;color:#0ea5e9;'>LKR " + total.toFixed(2) + "</td>" +
              "</tr>" +
            "</tbody>" +
          "</table>" +

          /* ── Thank-you banner ── */
          "<div style='display:flex;align-items:center;gap:12px;" +
               "background:linear-gradient(120deg,rgba(14,165,233,0.07),rgba(56,189,248,0.04));" +
               "border:1.5px solid rgba(14,165,233,0.18);border-radius:10px;" +
               "padding:14px 18px;margin-top:20px;font-size:14px;color:#0d1b2a;'>" +
            "<span style='font-size:22px;'>🌊</span>" +
            "<span>Thank you for staying with <b>Ocean View Resort</b>. We look forward to welcoming you again.</span>" +
          "</div>";

        showToast("success","Bill ready","You can print now.");
      } else {
        box.innerHTML = "<b>❌ " + ((data && data.message) ? data.message : "Failed") + "</b>";
        showToast("error","Failed", (data && data.message) ? data.message : "Try again");
      }
    });
})();
</script>
</body>
</html>
