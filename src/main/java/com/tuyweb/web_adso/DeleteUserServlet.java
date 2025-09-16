package com.tuyweb.web_adso;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("bienvenido.jsp?error=missingId");
            return;
        }

        int id = Integer.parseInt(idStr);

        String url = "jdbc:mysql://localhost:3306/web_adso?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection cn = DriverManager.getConnection(url, dbUser, dbPass);
                 PreparedStatement ps = cn.prepareStatement("DELETE FROM usuarios WHERE id = ?")) {

                ps.setInt(1, id);
                ps.executeUpdate();
            }

            response.sendRedirect("bienvenido.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("bienvenido.jsp?error=delete");
        }
    }
}
