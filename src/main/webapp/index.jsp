<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; }
        .container { max-width: 420px; margin: 48px auto; padding: 24px; border: 1px solid #e5e7eb; border-radius: 12px; }
        .title { margin: 0 0 16px; }
        .field { margin-bottom: 12px; display: grid; gap: 6px; }
        .error {
            border: 1px solid #fecaca; background: #fee2e2; color: #991b1b;
            padding: 10px 12px; border-radius: 10px; margin-bottom: 16px;
        }
        .btn { padding: 10px 14px; border: 0; border-radius: 10px; cursor: pointer; }
        .btn-primary { background: #111827; color: white; }
        .hint { color: #6b7280; font-size: 12px; margin-top: 6px; }
        input[type="text"], input[type="password"] {
            padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="title">Iniciar Sesión</h1>

    <!-- Bloque de error: se muestra solo cuando ?error=1 -->
    <%
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <div class="error">Usuario o contraseña incorrectos. Inténtalo nuevamente.</div>
    <%
        }
    %>

    <form action="LoginServlet" method="post" autocomplete="off">
        <div class="field">
            <label for="username">Usuario</label>
            <input type="text" id="username" name="username"
                   required>
        </div>

        <div class="field">
            <label for="password">Contraseña</label>
            <input type="password" id="password" name="password" required>
            <div class="hint">Pista: usa admin / 1234 en este demo.</div>
        </div>

        <button class="btn btn-primary" type="submit">Entrar</button>
    </form>
</div>
</body>
</html>
