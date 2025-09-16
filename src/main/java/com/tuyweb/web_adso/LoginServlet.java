package com.tuyweb.web_adso;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        String url = "jdbc:mysql://localhost:3306/web_adso?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "";

        boolean ok = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection cn = DriverManager.getConnection(url, dbUser, dbPass);
                 PreparedStatement ps = cn.prepareStatement(
                         "SELECT password FROM usuarios WHERE username = ?")) {

                ps.setString(1, user);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String hash = rs.getString("password");
                        // Compara el texto ingresado vs hash almacenado
                        ok = (pass != null) && BCrypt.checkpw(pass, hash);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=server");
            return;
        }

        if (ok) {
            HttpSession session = request.getSession();
            session.setAttribute("username", user);
            response.sendRedirect("bienvenido.jsp");
        } else {
            response.sendRedirect("index.jsp?error=1&username=" +
                    java.net.URLEncoder.encode(user == null ? "" : user,
                            java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
