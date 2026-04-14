import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@SuppressWarnings("serial")
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("uRole"); // From the radio buttons

        Connection con = null;
        try {
            con = DBConnection.getConnection(); 
            
            // Query the unified 'users' table
            String sql = "SELECT * FROM users WHERE email=? AND password=? AND role=?";            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, selectedRole);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // LOGIN SUCCESS
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userRole", rs.getString("role")); // "farmer" or "customer"

                System.out.println("Login Success: " + email + " as " + selectedRole);
                response.sendRedirect("mainmart.jsp");
            } else {
                // LOGIN FAIL
                response.sendRedirect("login.html?error=invalid_credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database Error: " + e.getMessage());
        } finally {
            try { if(con != null) con.close(); } catch(SQLException e) { e.printStackTrace(); }
        }
    }
}