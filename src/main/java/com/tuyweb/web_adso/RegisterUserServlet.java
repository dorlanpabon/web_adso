package com.tuyweb.web_adso;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/RegisterUserServlet")
public class RegisterUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 1) Generar hash seguro (incluye salt)
        String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // 2) Guardar en BD
        String url = "jdbc:mysql://localhost:3306/web_adso?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection cn = DriverManager.getConnection(url, dbUser, dbPass);
                 PreparedStatement ps = cn.prepareStatement(
                         "INSERT INTO usuarios (username, password) VALUES (?, ?)")) {

                ps.setString(1, username);
                ps.setString(2, hash);
                ps.executeUpdate();
            }

            response.sendRedirect("bienvenido.jsp");

        } catch (SQLIntegrityConstraintViolationException dup) {
            response.sendRedirect("bienvenido.jsp?error=duplicate");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("bienvenido.jsp?error=register");
        }
    }
}
