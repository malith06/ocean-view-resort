<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Page not found</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/app.css">
  <style>

    .error-wrap {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      background:
        radial-gradient(ellipse at 25% 60%, rgba(14,165,233,0.06) 0%, transparent 55%),
        radial-gradient(ellipse at 75% 20%, rgba(56,189,248,0.04) 0%, transparent 50%),
        #f0f2f7;
    }

    .error-card {
      width: min(480px, 100%);
      background: #fff;
      border: 1px solid rgba(15,30,60,0.08);
      border-radius: 20px;
      box-shadow: 0 20px 48px rgba(13,27,42,0.11), 0 8px 16px rgba(13,27,42,0.06);
      padding: 48px 40px 40px;
      text-align: center;
      animation: slideUp 0.38s cubic-bezier(0.16,1,0.3,1) both;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(22px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .error-code {
      font-family: 'Syne', sans-serif;
      font-size: 88px;
      font-weight: 800;
      line-height: 1;
      letter-spacing: -4px;
      background: linear-gradient(135deg, #0284c7, #38bdf8);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 4px;
    }

    .error-divider {
      width: 48px;
      height: 4px;
      border-radius: 4px;
      background: linear-gradient(90deg, #0ea5e9, #38bdf8);
      margin: 16px auto;
    }

    .error-title {
      font-family: 'Syne', sans-serif;
      font-size: 20px;
      font-weight: 800;
      color: #0d1b2a;
      margin: 0 0 10px;
      letter-spacing: -0.3px;
    }

    .error-desc {
      font-size: 14px;
      color: #64748b;
      line-height: 1.65;
      margin: 0 0 28px;
    }

  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/partials/header.jsp" />

  <div class="error-wrap">
    <div class="error-card">

      <div class="error-code">404</div>
      <div class="error-divider"></div>
      <div class="error-title">Page Not Found</div>
      <p class="error-desc">Sorry, the page you are looking for doesn't exist or may have been moved.</p>
      <a class="btn primary" href="<%=request.getContextPath()%>/home">Go Home</a>

    </div>
  </div>

  <jsp:include page="/WEB-INF/views/partials/footer.jsp" />
</body>
</html>