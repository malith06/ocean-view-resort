// app.js 

function showToast(type, title, message) {
  var t = document.getElementById("toast");
  if (!t) return;

  t.className = "toast show " + (type || "");

  var titleEl = t.querySelector(".t");
  var msgEl = t.querySelector(".m");

  if (titleEl) titleEl.textContent = title || "";
  if (msgEl) msgEl.textContent = message || "";

  clearTimeout(window.__toastTimer);
  window.__toastTimer = setTimeout(function () {
    t.classList.remove("show");
  }, 2800);
}

function fetchJson(url, options) {
  return fetch(url, options)
    .then(function (res) {
      return res.text();
    })
    .then(function (text) {
      try {
        return JSON.parse(text);
      } catch (e) {
        return { success: false, message: "Invalid server response" };
      }
    })
    .catch(function () {
      return { success: false, message: "Network error" };
    });
}

// ---------- form error helpers ----------
function clearErrors(form) {
  var errs = form.querySelectorAll("[data-err]");
  for (var i = 0; i < errs.length; i++) errs[i].textContent = "";

  var inputs = form.querySelectorAll("input,select");
  for (var j = 0; j < inputs.length; j++) inputs[j].classList.remove("input-error");
}

function showErrors(form, errors) {
  for (var field in errors) {
    if (!errors.hasOwnProperty(field)) continue;

    var msg = errors[field];
    var holder = form.querySelector("[data-err='" + field + "']");
    var input = form.querySelector("[name='" + field + "']");

    if (holder) holder.textContent = msg;
    if (input) input.classList.add("input-error");
  }
}

// ---------- client validation (same rules as ValidationUtil) ----------
function validateClientReservation(form) {
  var errors = {};

  var guestName = (form.guestName.value || "").trim();
  var address = (form.address.value || "").trim();
  var contactNo = (form.contactNo.value || "").trim();
  var roomType = (form.roomType.value || "").trim();
  var checkIn = form.checkIn.value;
  var checkOut = form.checkOut.value;

  if (!guestName) errors.guestName = "Guest name is required.";
  else if (!/^[A-Za-z ]{2,50}$/.test(guestName)) errors.guestName = "Only letters and spaces allowed (2–50 chars).";

  if (!address) errors.address = "Address is required.";
  else if (address.length < 5) errors.address = "Address is too short.";

  if (!contactNo) errors.contactNo = "Contact number is required.";
  else if (!/^\d{9,12}$/.test(contactNo)) errors.contactNo = "Contact must be 9–12 digits.";

  if (!roomType) errors.roomType = "Room type is required.";

  if (!checkIn) errors.checkIn = "Check-in date is required.";
  if (!checkOut) errors.checkOut = "Check-out date is required.";

  if (checkIn) {
    var today = new Date(); today.setHours(0,0,0,0);
    var inD = new Date(checkIn + "T00:00:00");
    if (inD < today) errors.checkIn = "Check-in must be today or a future date.";
  }

  if (checkIn && checkOut) {
    var inD2 = new Date(checkIn + "T00:00:00");
    var outD = new Date(checkOut + "T00:00:00");
    if (outD <= inD2) errors.checkOut = "Check-out must be after check-in.";
  }

  return errors;
}