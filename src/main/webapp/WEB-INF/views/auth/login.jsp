<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    .login-wrap {
      min-height: 100vh;
      display: flex;
      align-items: stretch;
    }

    /* ── Left panel: hero image with overlay ── */
    .login-panel {
      width: 420px;
      flex-shrink: 0;
      position: relative;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 48px 44px;
    }

    /* Hero image layer */
    .login-panel-bg {
      position: absolute;
      inset: 0;
      background-image: url('<%=request.getContextPath()%>/assets/img/hero.jpg');
      background-size: cover;
      background-position: center;
      z-index: 0;
    }

    /* Dark gradient overlay for readability */
    .login-panel-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(
        160deg,
        rgba(15, 40, 80, 0.82) 0%,
        rgba(15, 52, 96, 0.75) 50%,
        rgba(12, 48, 90, 0.85) 100%
      );
      z-index: 1;
    }

    /* Top accent line */
    .login-panel::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8, transparent);
      z-index: 3;
    }

    /* All panel content sits above overlay */
    .panel-brand,
    .panel-middle,
    .panel-footer {
      position: relative;
      z-index: 2;
    }

    .panel-brand {
      display: flex;
      align-items: center;
      gap: 13px;
    }

    .panel-icon {
      width: 44px;
      height: 44px;
      border-radius: 12px;
      background: linear-gradient(135deg, #0ea5e9, #38bdf8);
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Playfair Display', sans-serif;
      font-weight: 800;
      font-size: 19px;
      color: #fff;
      box-shadow: 0 6px 20px rgba(14,165,233,0.35);
      flex-shrink: 0;
    }

    .panel-brand-name {
      font-family: 'Playfair Display', sans-serif;
      font-weight: 800;
      font-size: 19px;
      color: #fff;
      line-height: 1.15;
    }

    .panel-brand-sub {
      font-size: 10.5px;
      font-weight: 500;
      color: rgba(255,255,255,0.45);
      letter-spacing: 0.08em;
      text-transform: uppercase;
      margin-top: 2px;
    }

    .panel-middle { }

    .panel-heading {
      font-family: 'Playfair Display', sans-serif;
      font-size: 30px;
      font-weight: 800;
      color: #fff;
      line-height: 1.22;
      margin: 0 0 14px;
      letter-spacing: -0.5px;
      text-shadow: 0 2px 12px rgba(0,0,0,0.30);
    }

    .panel-desc {
      font-size: 14px;
      color: rgba(255,255,255,0.55);
      line-height: 1.72;
      max-width: 270px;
      margin: 0;
      text-shadow: 0 1px 6px rgba(0,0,0,0.25);
    }

    .panel-dots {
      display: flex;
      gap: 8px;
      margin-top: 30px;
    }

    .panel-dots span {
      display: block;
      height: 4px;
      border-radius: 4px;
      background: rgba(255,255,255,0.20);
    }

    .panel-dots span:first-child {
      width: 28px;
      background: #0ea5e9;
    }

    .panel-dots span:nth-child(2) { width: 14px; }
    .panel-dots span:nth-child(3) { width: 8px; }

    .panel-footer {
      font-size: 11.5px;
      color: rgba(255,255,255,0.30);
    }

    /* ── Right form area ── */
    .login-form-area {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 40px 24px;
      background:
        radial-gradient(ellipse at 80% 20%, rgba(14,165,233,0.05) 0%, transparent 55%),
        #f0f2f7;
    }

    .login-card {
      width: min(420px, 100%);
      background: #fff;
      border: 1px solid rgba(15,30,60,0.08);
      border-radius: 20px;
      box-shadow: 0 20px 48px rgba(13,27,42,0.11), 0 8px 16px rgba(13,27,42,0.06);
      padding: 36px;
      animation: slideUp 0.38s cubic-bezier(0.16,1,0.3,1) both;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(20px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .login-card-title {
      font-family: 'Playfair Display', sans-serif;
      font-size: 22px;
      font-weight: 800;
      color: #0a1628;
      letter-spacing: -0.3px;
      margin: 0 0 6px;
    }

    .login-card-sub {
      font-size: 14px;
      color: #64748b;
      margin: 0 0 26px;
    }

    .error-box {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      background: rgba(239,68,68,0.05);
      border: 1.5px solid rgba(239,68,68,0.20);
      border-radius: 10px;
      padding: 12px 14px;
      margin-bottom: 20px;
      color: #b91c1c;
      font-size: 13.5px;
      line-height: 1.5;
    }

    .form-group {
      margin-bottom: 16px;
    }

    .form-group label {
      display: block;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.09em;
      text-transform: uppercase;
      color: #64748b;
      margin-bottom: 7px;
    }

    .form-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 24px;
    }

    .form-actions .btn { flex: 1; min-width: 100px; }

    @media (max-width: 780px) {
      .login-panel { display: none; }
      .login-wrap { display: block; }
      .login-form-area {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }
    }
  </style>
</head>
<body>

  <div class="login-wrap">

    <!-- Left panel with hero.jpg background -->
    <div class="login-panel">
      <div class="login-panel-bg"></div>
      <div class="login-panel-overlay"></div>

      <div class="panel-brand">
        <img src="<%=request.getContextPath()%>/assets/img/logo.jpg" alt="Ocean View Logo"
             style="width:52px;height:52px;object-fit:cover;border-radius:50%;flex-shrink:0;box-shadow:0 4px 16px rgba(0,0,0,0.30);">
        <div>
          <div class="panel-brand-name">Ocean View</div>
          <div class="panel-brand-sub">Resort</div>
        </div>
      </div>

      <div class="panel-middle">
        <div class="panel-heading">Welcome<br>Back, Staff.</div>
        <p class="panel-desc">Sign in to manage reservations, generate bills, and view reports for Ocean View Resort.</p>
        <div class="panel-dots">
          <span></span><span></span><span></span>
        </div>
      </div>

      <div class="panel-footer">© <%= java.time.Year.now() %> Ocean View Resort</div>
    </div>

    <!-- Right form area -->
    <div class="login-form-area">
      <div class="login-card">

        <h2 class="login-card-title">Staff Login</h2>
        <p class="login-card-sub">Use your staff username and password.</p>

        <% String error = (String) request.getAttribute("error"); %>
        <% if(error != null){ %>
          <div class="error-box">
            <span>⚠</span>
            <span><b>Login failed:</b> <%=error%></span>
          </div>
        <% } %>

        <form method="post" action="<%=request.getContextPath()%>/login">
          <div class="form-group">
            <label>Username</label>
            <input name="username" placeholder="e.g. admin" required>
          </div>

          <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="••••••••" required>
          </div>

          <div class="form-actions">
            <button class="btn primary" type="submit">Login</button>
            <a class="btn ghost" href="<%=request.getContextPath()%>/help">Help</a>
          </div>
        </form>

      </div>
    </div>

  </div>

</body>
</html>


