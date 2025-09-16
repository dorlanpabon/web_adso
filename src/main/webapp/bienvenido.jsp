<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Bienvenido</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Tailwind (CDN). Puedes usar este (v3) o el que ya tenías (v4 browser). Elige UNO -->
    <!-- Opción A: Tailwind v3 Play CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Opción B: Tailwind v4 browser (si prefieres seguir con esta) -->
    <!-- <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script> -->
</head>
<body class="min-h-screen bg-gray-50 text-gray-900">
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!-- Contenedor principal -->
<div class="max-w-5xl mx-auto p-6">
    <!-- Header -->
    <header class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-semibold">
                Bienvenido, <span class="text-indigo-600"><%= session.getAttribute("username") %></span> 🎉
            </h1>
            <p class="text-sm text-gray-500 mt-1">Panel de administración de usuarios</p>
        </div>
        <a class="inline-flex items-center gap-2 rounded-xl bg-rose-600 text-white px-4 py-2 text-sm font-medium shadow hover:bg-rose-700 active:bg-rose-800 transition"
           href="logout.jsp">
            Cerrar sesión
        </a>
    </header>

    <!-- Mensajes de estado -->
    <%
        String err = request.getParameter("error");
        if ("duplicate".equals(err)) {
    %>
        <div class="mb-4 rounded-xl border border-amber-300 bg-amber-50 px-4 py-3 text-amber-800">
            ⚠️ El nombre de usuario ya existe.
        </div>
    <%
        } else if ("register".equals(err)) {
    %>
        <div class="mb-4 rounded-xl border border-red-300 bg-red-50 px-4 py-3 text-red-800">
            ⚠️ Error al registrar usuario. Intenta de nuevo.
        </div>
    <%
        } else if ("delete".equals(err)) {
    %>
        <div class="mb-4 rounded-xl border border-red-300 bg-red-50 px-4 py-3 text-red-800">
            ⚠️ Error al eliminar usuario.
        </div>
    <%
        } else if ("notfound".equals(err)) {
    %>
        <div class="mb-4 rounded-xl border border-amber-300 bg-amber-50 px-4 py-3 text-amber-800">
            ⚠️ Usuario no encontrado.
        </div>
    <%
        } else if ("server".equals(err)) {
    %>
        <div class="mb-4 rounded-xl border border-red-300 bg-red-50 px-4 py-3 text-red-800">
            ⚠️ Error del servidor. Intenta nuevamente.
        </div>
    <%
        }
    %>

    <!-- Tabla de usuarios -->
    <section class="bg-white border border-gray-200 rounded-2xl shadow-sm overflow-hidden mb-8">
        <div class="px-5 py-4 border-b border-gray-100 flex items-center justify-between">
            <h2 class="text-lg font-semibold">Lista de usuarios registrados</h2>
            <span class="text-xs text-gray-500">Administración</span>
        </div>

        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200 text-sm">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-5 py-3 text-left font-medium text-gray-600">ID</th>
                        <th class="px-5 py-3 text-left font-medium text-gray-600">Usuario</th>
                        <th class="px-5 py-3 text-left font-medium text-gray-600">Contraseña</th> <%-- ⚠️ quita esta columna si usas hashes --%>
                        <th class="px-5 py-3 text-left font-medium text-gray-600">Acciones</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 bg-white">
                <%
                    String url = "jdbc:mysql://localhost:3306/web_adso?useSSL=false&serverTimezone=UTC";
                    String dbUser = "root";
                    String dbPass = "";

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        try (Connection cn = DriverManager.getConnection(url, dbUser, dbPass);
                             Statement st = cn.createStatement();
                             ResultSet rs = st.executeQuery("SELECT id, username, password FROM usuarios")) {

                            while (rs.next()) {
                                int id = rs.getInt("id");
                %>
                    <tr class="hover:bg-gray-50">
                        <td class="px-5 py-3"><%= id %></td>
                        <td class="px-5 py-3 font-medium"><%= rs.getString("username") %></td>
                        <td class="px-5 py-3">
                            <code class="text-xs text-gray-500 break-all"><%= rs.getString("password") %></code>
                        </td>
                        <td class="px-5 py-3">
                            <div class="flex items-center gap-2">
                                <form action="EditUserServlet" method="get">
                                    <input type="hidden" name="id" value="<%= id %>">
                                    <button type="submit"
                                            class="inline-flex items-center rounded-lg bg-indigo-600 text-white px-3 py-1.5 text-xs font-medium shadow hover:bg-indigo-700 active:bg-indigo-800 transition">
                                        Editar
                                    </button>
                                </form>

                                <form action="DeleteUserServlet" method="post"
                                      onsubmit="return confirm('¿Seguro que deseas eliminar este usuario?');">
                                    <input type="hidden" name="id" value="<%= id %>">
                                    <button type="submit"
                                            class="inline-flex items-center rounded-lg bg-rose-600 text-white px-3 py-1.5 text-xs font-medium shadow hover:bg-rose-700 active:bg-rose-800 transition">
                                        Eliminar
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                %>
                    <tr>
                        <td colspan="4" class="px-5 py-4 text-red-700 bg-red-50">
                            Error: <%= e.getMessage() %>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </section>

    <!-- Registro de nuevo usuario -->
    <section class="bg-white border border-gray-200 rounded-2xl shadow-sm p-6">
        <h2 class="text-lg font-semibold mb-4">Registrar nuevo usuario</h2>

        <form action="RegisterUserServlet" method="post" class="grid gap-4 max-w-md">
            <div>
                <label for="newUsername" class="block text-sm font-medium text-gray-700 mb-1">Usuario</label>
                <input id="newUsername" name="username" type="text" required
                       class="w-full rounded-xl border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-3 py-2">
            </div>

            <div>
                <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-1">Contraseña</label>
                <input id="newPassword" name="password" type="password" required
                       class="w-full rounded-xl border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 px-3 py-2">
                <p class="text-xs text-gray-500 mt-1">Se almacenará de forma segura con BCrypt.</p>
            </div>

            <div class="flex items-center gap-3">
                <button type="submit"
                        class="inline-flex items-center rounded-xl bg-green-600 text-white px-4 py-2 text-sm font-medium shadow hover:bg-green-700 active:bg-green-800 transition">
                    Registrar
                </button>
                <a href="bienvenido.jsp"
                   class="text-sm text-gray-500 hover:text-gray-700">Actualizar lista</a>
            </div>
        </form>
    </section>

    <footer class="text-xs text-gray-400 mt-8">
        <p>© <script>document.write(new Date().getFullYear())</script> Tu App</p>
    </footer>
</div>

</body>
</html>
