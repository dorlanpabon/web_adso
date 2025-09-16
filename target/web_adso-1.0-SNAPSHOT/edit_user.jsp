<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar usuario</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .box { max-width: 420px; padding: 16px; border: 1px solid #ddd; border-radius: 10px; }
        label { display:block; margin-top:10px; }
        input[type="text"], input[type="password"] { width:100%; padding:8px; }
        .actions { margin-top:16px; display:flex; gap:8px; }
    </style>
</head>
<body>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    Integer id = (Integer) request.getAttribute("id");
    String username = (String) request.getAttribute("username");
%>

<h1>Editar usuario</h1>

<div class="box">
    <form action="UpdateUserServlet" method="post">
        <input type="hidden" name="id" value="<%= id %>">

        <label for="username">Usuario</label>
        <input type="text" id="username" name="username" value="<%= username %>" required>

        <label for="password">Nueva contraseña (opcional)</label>
        <input type="password" id="password" name="password" placeholder="Dejar vacío para no cambiar">

        <div class="actions">
            <button type="submit">Guardar</button>
            <a href="bienvenido.jsp">Cancelar</a>
        </div>
    </form>
</div>

<%
    String err = request.getParameter("error");
    if ("duplicate".equals(err)) {
%>
    <p style="color:#b91c1c;">El nombre de usuario ya existe.</p>
<%
    } else if ("update".equals(err)) {
%>
    <p style="color:#b91c1c;">Error al actualizar. Intenta de nuevo.</p>
<%
    }
%>

</body>
</html>
