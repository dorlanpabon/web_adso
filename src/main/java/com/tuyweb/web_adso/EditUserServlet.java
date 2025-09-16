package com.tuyweb.web_adso;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
                 PreparedStatement ps = cn.prepareStatement("SELECT id, username FROM usuarios WHERE id = ?")) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.sendRedirect("bienvenido.jsp?error=notfound");
                        return;
                    }
                    request.setAttribute("id", rs.getInt("id"));
                    request.setAttribute("username", rs.getString("username"));
                }
            }
            // Forward a la vista de edición
            request.getRequestDispatcher("edit_user.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("bienvenido.jsp?error=server");
        }
    }
}
