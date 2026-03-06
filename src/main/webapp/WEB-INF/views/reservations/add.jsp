<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Add Reservation");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Add Reservation</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    /* ── Page banner ── */
    .add-banner {
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

    .add-banner::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8, transparent);
    }

    .add-banner::after {
      content: '';
      position: absolute;
      right: -50px; bottom: -50px;
      width: 180px; height: 180px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.10) 0%, transparent 70%);
      pointer-events: none;
    }

    .add-banner-text h2 {
      font-family: 'Playfair Display', sans-serif;
      font-size: 20px;
      font-weight: 800;
      color: #fff;
      margin: 0 0 4px;
      letter-spacing: -0.3px;
    }

    .add-banner-text p {
      margin: 0;
      font-size: 13px;
      color: rgba(255,255,255,0.42);
    }

    .add-badge {
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

    /* ── Section divider label ── */
    .section-label {
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.09em;
      text-transform: uppercase;
      color: #64748b;
      margin-bottom: 14px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .section-label::after {
      content: '';
      flex: 1;
      height: 1px;
      background: rgba(15,30,60,0.07);
    }

    /* ── Form actions ── */
    .form-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 22px;
      padding-top: 18px;
      border-top: 1px solid rgba(15,30,60,0.07);
    }

    /* ── Right column ── */
    .right-stack {
      display: flex;
      flex-direction: column;
      gap: 18px;
    }

    /* ── After-create actions ── */
    #afterCreate {
      display: none;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 14px;
    }

    /* ── Avail actions ── */
    .avail-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 14px;
    }

  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/partials/header.jsp" />

  <!-- Page banner -->
  <div class="add-banner">
    <div class="add-banner-text">
      <h2>Add Reservation</h2>
      <p>Create a new reservation and generate a unique reservation number.</p>
    </div>
    <div class="add-badge">➕ New Booking</div>
  </div>

  <div class="grid two">

    <!-- LEFT: Reservation form -->
    <div class="card">
      <div class="cardTitle">Reservation Form</div>
      <div class="section-label">Guest Information</div>

      <form id="resForm" class="no-print">

        <div class="row two">
          <div class="field">
            <label>Guest Name</label>
            <input name="guestName" placeholder="Kamal Perera" required>
            <small class="err" data-err="guestName"></small>
          </div>

          <div class="field">
            <label>Contact Number</label>
            <input name="contactNo" placeholder="07XXXXXXXX" required>
            <small class="err" data-err="contactNo"></small>
          </div>
        </div>

        <div class="field" style="margin-top:14px;">
          <label>Address</label>
          <input name="address" placeholder="No 10, Main Street, Colombo" required>
          <small class="err" data-err="address"></small>
        </div>

        <div class="section-label" style="margin-top:22px;">Booking Details</div>

        <div class="row three">
          <div class="field">
            <label>Room Type</label>
            <select name="roomType" required>
              <option value="">Select</option>
              <option value="STANDARD">Standard (LKR 15,000)</option>
              <option value="DELUXE">Deluxe (LKR 30,000)</option>
              <option value="SUITE">Suite (LKR 50,000)</option>
            </select>
            <small class="err" data-err="roomType"></small>
          </div>

          <div class="field">
            <label>Check-in</label>
            <input type="date" name="checkIn" required>
            <small class="err" data-err="checkIn"></small>
          </div>

          <div class="field">
            <label>Check-out</label>
            <input type="date" name="checkOut" required>
            <small class="err" data-err="checkOut"></small>
          </div>
        </div>

        <div class="form-actions">
          <button class="btn primary" type="submit">Create Reservation</button>
          <a class="btn ghost" href="<%=request.getContextPath()%>/search">Go to Search</a>
        </div>

      </form>
    </div>

    <!-- RIGHT: Result + Availability -->
    <div class="right-stack">

      <!-- Result card -->
      <div class="card">
        <div class="cardTitle">Result</div>
        <div id="resultBox" class="helpBox">No reservation created yet.</div>
        <div id="afterCreate" class="no-print">
          <a id="btnBill" class="btn primary" href="#">Generate Bill</a>
          <button class="btn ghost" type="button" onclick="window.print()">Print</button>
        </div>
      </div>

      <!-- Availability card -->
      <div class="card">
        <div class="cardTitle">Check Availability</div>
        <p class="muted" style="margin-top:-8px; margin-bottom:14px; font-size:13px;">
          Check if rooms are available for a date range.
        </p>

        <form id="availForm" class="no-print">
          <div class="field">
            <label>Room Type</label>
            <select name="roomType" required>
              <option value="">Select</option>
              <option value="STANDARD">Standard</option>
              <option value="DELUXE">Deluxe</option>
              <option value="SUITE">Suite</option>
            </select>
          </div>

          <div class="row two" style="margin-top:12px;">
            <div class="field">
              <label>Check-in</label>
              <input type="date" name="checkIn" required />
            </div>
            <div class="field">
              <label>Check-out</label>
              <input type="date" name="checkOut" required />
            </div>
          </div>

          <div class="avail-actions">
            <button class="btn primary" type="submit">Check</button>
            <button class="btn ghost" type="button"
                    onclick="document.getElementById('availForm').reset(); resetAvailBox();">
              Clear
            </button>
          </div>
        </form>

        <div id="availBox" class="helpBox" style="margin-top:14px;">No check yet.</div>
      </div>

    </div>
  </div>

  <jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
  window.ctx = "<%=request.getContextPath()%>";

  // ----------------- Create Reservation -----------------
  (function(){
    var form = document.getElementById("resForm");
    if(!form) return;

    form.addEventListener("submit", function(e){
      e.preventDefault();
      clearErrors(form);

      var clientErrors = validateClientReservation(form);
      if(Object.keys(clientErrors).length > 0){
        showErrors(form, clientErrors);
        showToast("error","Fix errors","Please correct highlighted fields.");
        return;
      }

      var body = new URLSearchParams(new FormData(form)).toString();

      fetchJson(window.ctx + "/api/reservations", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
        body: body
      })
      .then(function(data){
        var box   = document.getElementById("resultBox");
        var after = document.getElementById("afterCreate");

        if(data && data.success){
          box.className = "";
          box.innerHTML =
            "<div style='display:flex;align-items:flex-start;gap:12px;" +
                 "background:rgba(16,185,129,0.05);border:1.5px solid rgba(16,185,129,0.18);" +
                 "border-radius:12px;padding:16px;'>" +
              "<span style='font-size:20px;flex-shrink:0;margin-top:2px;'>✅</span>" +
              "<div>" +
                "<div style='font-weight:700;color:#065f46;margin-bottom:10px;'>" + data.message + "</div>" +
                "<div style='font-size:11px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;" +
                     "color:#64748b;margin-bottom:3px;'>Reservation No</div>" +
                "<div style='font-family:'Playfair Display',sans-serif;font-size:28px;font-weight:800;color:#0ea5e9;" +
                     "letter-spacing:-0.5px;line-height:1;margin-bottom:12px;'>" +
                  data.reservationNo +
                "</div>" +
                "<div style='font-size:13px;color:#475569;line-height:1.7;'>" +
                  data.guestName + " &nbsp;•&nbsp; " + data.roomType + "<br/>" +
                  data.checkIn + " → " + data.checkOut +
                "</div>" +
              "</div>" +
            "</div>";

          document.getElementById("btnBill").href =
            window.ctx + "/bill?reservationNo=" + encodeURIComponent(data.reservationNo);

          after.style.display = "flex";
          showToast("success","Created","Reservation created successfully.");
          return;
        }

        if(data && data.errors){
          showErrors(form, data.errors);
          box.className = "helpBox";
          box.innerHTML =
            "<b>❌ Validation failed</b><br/>" +
            "<pre style='margin:10px 0 0;white-space:pre-wrap;font-size:12px;'>" +
              JSON.stringify(data.errors, null, 2) +
            "</pre>";
          after.style.display = "none";
          showToast("error","Failed","Validation failed");
          return;
        }

        box.className = "helpBox";
        box.innerHTML = "<b>❌ " + ((data && data.message) ? data.message : "Failed") + "</b>";
        after.style.display = "none";
        showToast("error","Failed", (data && data.message) ? data.message : "Try again");
      });
    });
  })();

  // ----------------- Check Availability -----------------
  (function(){
    var form = document.getElementById("availForm");
    var box  = document.getElementById("availBox");
    if(!form || !box) return;

    form.addEventListener("submit", function(e){
      e.preventDefault();

      var rt   = form.roomType.value;
      var inD  = form.checkIn.value;
      var outD = form.checkOut.value;

      if(!rt || !inD || !outD){
        showToast("error","Missing","Please fill all availability fields.");
        return;
      }

      var url = window.ctx + "/api/availability?roomType=" + encodeURIComponent(rt) +
                "&checkIn="  + encodeURIComponent(inD) +
                "&checkOut=" + encodeURIComponent(outD);

      box.className = "helpBox";
      box.innerHTML = "Checking availability...";

      fetchJson(url).then(function(data){
        if(data && data.success){
          var isAvail = data.available > 0;
          var accentColor = isAvail ? "rgba(16,185,129,0.20)" : "rgba(239,68,68,0.20)";
          var bgColor     = isAvail ? "rgba(16,185,129,0.04)" : "rgba(239,68,68,0.04)";
          var textColor   = isAvail ? "#065f46" : "#991b1b";
          var valColor    = isAvail ? "#059669"  : "#dc2626";

          box.className = "";
          box.innerHTML =
            "<div style='border:1.5px solid " + accentColor + ";background:" + bgColor + ";" +
                 "border-radius:10px;padding:14px;'>" +
              "<div style='font-weight:800;font-size:15px;color:" + textColor + ";margin-bottom:12px;'>" +
                (isAvail ? "✅ Available" : "❌ Fully Booked") +
              "</div>" +
              "<table class='table' style='margin-top:0;'>" +
                "<tr><td>Room Type</td><td><b>" + data.roomType + "</b></td></tr>" +
                "<tr><td>Date Range</td><td>" + data.checkIn + " → " + data.checkOut + "</td></tr>" +
                "<tr><td>Capacity</td><td>" + data.capacity + "</td></tr>" +
                "<tr><td>Booked</td><td>" + data.booked + "</td></tr>" +
                "<tr><td><b>Available</b></td>" +
                "<td><b style='color:" + valColor + ";'>" + data.available + "</b></td></tr>" +
              "</table>" +
            "</div>";

          if(isAvail) showToast("success","Available","Rooms are available.");
          else        showToast("error","Full","No rooms available for these dates.");
        } else {
          box.className = "helpBox";
          box.innerHTML = "<b>❌ " + ((data && data.message) ? data.message : "Failed") + "</b>";
          showToast("error","Failed", (data && data.message) ? data.message : "Try again");
        }
      });
    });
  })();

  function resetAvailBox(){
    var box = document.getElementById("availBox");
    if(box){
      box.className = "helpBox";
      box.innerHTML = "No check yet.";
    }
  }
</script>
</body>
</html>
