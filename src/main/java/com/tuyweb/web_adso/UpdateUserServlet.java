package com.tuyweb.web_adso;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String username = request.getParameter("username");
        String newPassword = request.getParameter("password");

        if (idStr == null || username == null || username.isBlank()) {
            response.sendRedirect("bienvenido.jsp?error=update");
            return;
        }

        int id = Integer.parseInt(idStr);

        String url = "jdbc:mysql://localhost:3306/web_adso?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Si hay nueva contraseña => hasheamos y actualizamos ambas columnas
            if (newPassword != null && !newPassword.isBlank()) {
                String hash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
                try (Connection cn = DriverManager.getConnection(url, dbUser, dbPass);
                     PreparedStatement ps = cn.prepareStatement(
                        "UPDATE usuarios SET username = ?, password = ? WHERE id = ?")) {
                    ps.setString(1, username);
                    ps.setString(2, hash);
                    ps.setInt(3, id);
                    ps.executeUpdate();
                }
            } else {
                // Solo cambiar username
                try (Connection cn = DriverManager.getConnection(url, dbUser, dbPass);
                     PreparedStatement ps = cn.prepareStatement(
                        "UPDATE usuarios SET username = ? WHERE id = ?")) {
                    ps.setString(1, username);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                }
            }

            response.sendRedirect("bienvenido.jsp");

        } catch (SQLIntegrityConstraintViolationException dup) {
            // Username UNIQUE duplicado
            response.sendRedirect("EditUserServlet?id=" + id + "&error=duplicate");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("EditUserServlet?id=" + id + "&error=update");
        }
    }
}
