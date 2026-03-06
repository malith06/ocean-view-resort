<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setAttribute("pageTitle", "Edit Reservation");
  String reservationNo = request.getParameter("reservationNo");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Reservation</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    /* ── Page banner ── */
    .edit-banner {
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

    .edit-banner::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8, transparent);
    }

    .edit-banner::after {
      content: '';
      position: absolute;
      right: -50px; bottom: -50px;
      width: 180px; height: 180px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(14,165,233,0.10) 0%, transparent 70%);
      pointer-events: none;
    }

    .edit-banner-text h2 {
      font-family: 'Playfair Display', sans-serif;
      font-size: 20px;
      font-weight: 800;
      color: #fff;
      margin: 0 0 4px;
      letter-spacing: -0.3px;
    }

    .edit-banner-text p {
      margin: 0;
      font-size: 13px;
      color: rgba(255,255,255,0.42);
    }

    .edit-banner-text p b {
      color: #38bdf8;
      font-family: 'Playfair Display', sans-serif;
      letter-spacing: 0.03em;
    }

    .edit-badge {
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

    /* ── Two-column layout ── */
    .edit-layout {
      display: grid;
      grid-template-columns: 1.15fr 0.85fr;
      gap: 18px;
    }

    @media (max-width: 980px) {
      .edit-layout { grid-template-columns: 1fr; }
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

    /* ── Status / result panel ── */
    .status-card {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    /* ── Info box (loaded state) ── */
    .info-box {
      background: rgba(14,165,233,0.05);
      border: 1.5px solid rgba(14,165,233,0.14);
      border-radius: 10px;
      padding: 14px 16px;
      font-size: 13.5px;
      color: #334155;
      line-height: 1.6;
    }

    /* ── Tips card ── */
    .tip-list {
      display: flex;
      flex-direction: column;
      gap: 10px;
      margin-top: 4px;
    }

    .tip-item {
      display: flex;
      align-items: flex-start;
      gap: 9px;
      font-size: 13px;
      color: #475569;
      line-height: 1.6;
    }

    .tip-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: #0ea5e9;
      flex-shrink: 0;
      margin-top: 7px;
    }

  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />

<!-- Page banner -->
<div class="edit-banner">
  <div class="edit-banner-text">
    <h2>Edit Reservation</h2>
    <p>Updating reservation: <b id="resNo"><%= reservationNo == null ? "" : reservationNo %></b></p>
  </div>
  <div class="edit-badge">✏️ Edit Mode</div>
</div>

<div class="edit-layout">

  <!-- LEFT: Edit form -->
  <div class="card">
    <div class="cardTitle">Reservation Details</div>

    <form id="editForm" style="margin-top:4px;">
      <!-- ✅ IMPORTANT: keep this hidden input -->
      <input type="hidden" name="reservationNo" id="reservationNoHidden"
             value="<%= reservationNo == null ? "" : reservationNo %>"/>

      <div class="section-label">Guest Information</div>

      <div class="row two">
        <div class="field">
          <label>Guest Name</label>
          <input name="guestName" placeholder="Guest Name" required>
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
        <input name="address" placeholder="Address" required>
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
        <button class="btn primary" type="submit">Save Changes</button>
        <a class="btn ghost" href="<%=request.getContextPath()%>/search">← Back</a>
      </div>

    </form>
  </div>

  <!-- RIGHT: Status + Tips -->
  <div class="status-card">

    <!-- Result box -->
    <div class="card">
      <div class="cardTitle">Status</div>
      <div id="result" class="helpBox">Load reservation to edit…</div>
    </div>

    <!-- Tips card -->
    <div class="card">
      <div class="cardTitle">Edit Guidelines</div>
      <div class="tip-list">
        <div class="tip-item">
          <div class="tip-dot"></div>
          <span>Reservation data is loaded automatically when this page opens.</span>
        </div>
        <div class="tip-item">
          <div class="tip-dot"></div>
          <span>Guest name must contain only letters and spaces (2–50 chars).</span>
        </div>
        <div class="tip-item">
          <div class="tip-dot"></div>
          <span>Contact number must be 9–12 digits with no spaces or dashes.</span>
        </div>
        <div class="tip-item">
          <div class="tip-dot"></div>
          <span>Check-out date must always be after the check-in date.</span>
        </div>
        <div class="tip-item">
          <div class="tip-dot"></div>
          <span>Only <b>ACTIVE</b> reservations can be edited.</span>
        </div>
      </div>
    </div>

  </div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
(function(){
  var resNo = "<%= reservationNo == null ? "" : reservationNo %>";
  var form  = document.getElementById("editForm");
  var box   = document.getElementById("result");

  if(!resNo || resNo.trim() === "" || resNo === "null"){
    box.innerHTML = "<b>❌ Reservation number missing.</b>";
    return;
  }

  // ✅ FIX: make sure hidden field is always filled
  form.reservationNo.value = resNo;

  // Load existing data
  fetchJson(window.ctx + "/api/reservations?reservationNo=" + encodeURIComponent(resNo))
    .then(function(data){
      if(data && data.success){
        form.guestName.value = data.guestName || "";
        form.address.value   = data.address   || "";
        form.contactNo.value = data.contactNo || "";
        form.roomType.value  = (data.roomType || "").toUpperCase();
        form.checkIn.value   = data.checkIn   || "";
        form.checkOut.value  = data.checkOut  || "";

        box.className = "";
        box.innerHTML =
          "<div style='display:flex;align-items:flex-start;gap:10px;" +
               "background:rgba(14,165,233,0.05);border:1.5px solid rgba(14,165,233,0.14);" +
               "border-radius:10px;padding:14px;'>" +
            "<span style='font-size:18px;flex-shrink:0;'>✅</span>" +
            "<div style='font-size:13.5px;color:#334155;line-height:1.6;'>" +
              "Reservation <b style='color:#0ea5e9;font-family:'Playfair Display',sans-serif;'>" + resNo + "</b> loaded.<br/>" +
              "Make your changes and click <b>Save Changes</b>." +
            "</div>" +
          "</div>";
      } else {
        box.className = "helpBox";
        box.innerHTML = "<b>❌ " + (data ? data.message : "Failed to load reservation.") + "</b>";
      }
    });

  form.addEventListener("submit", function(e){
    e.preventDefault();
    clearErrors(form);

    // ✅ again ensure it is not lost
    form.reservationNo.value = resNo;

    var errs = validateClientReservation(form);
    if(Object.keys(errs).length){
      showErrors(form, errs);
      showToast("error","Fix errors","Please correct the highlighted fields.");
      return;
    }

    // ✅ Send URL-encoded like add.jsp (very stable)
    var body = new URLSearchParams(new FormData(form)).toString();

    fetchJson(window.ctx + "/api/reservations/update", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
      body: body
    }).then(function(data){
      if(data && data.success){
        box.className = "";
        box.innerHTML =
          "<div style='display:flex;align-items:flex-start;gap:10px;" +
               "background:rgba(16,185,129,0.05);border:1.5px solid rgba(16,185,129,0.18);" +
               "border-radius:10px;padding:14px;'>" +
            "<span style='font-size:18px;flex-shrink:0;'>✅</span>" +
            "<div style='font-size:13.5px;color:#065f46;font-weight:600;'>" + data.message + "</div>" +
          "</div>";
        showToast("success","Updated","Reservation updated successfully.");
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
        showToast("error","Validation","Please check inputs.");
        return;
      }

      box.className = "helpBox";
      box.innerHTML = "<b>❌ " + (data ? data.message : "Update failed") + "</b>";
      showToast("error","Failed", (data ? data.message : "Update failed"));
    });
  });
})();
</script>
</body>
</html>
