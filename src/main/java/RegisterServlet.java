import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

// Ensure this matches your project's DB utility package if you have one
// import com.agri.utils.DBConnection; 

@SuppressWarnings("serial")
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get parameters (Ensure these names match your signUp.html 'name' attributes)
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("uRole"); // Using uRole to match common login naming

        // Debugging
        System.out.println("Registration Attempt ✅ Role: " + role + ", Email: " + email);

        if (role == null || role.isEmpty()) {
            response.getWriter().println("Invalid role selection ❌");
            return;
        }

        Connection con = null;
        try {
            // 2. Establish Connection (Assuming you have a DBConnection class)
            // If not, replace DBConnection.getConn() with your driver manager logic
            con = DBConnection.getConnection(); 

            // 3. Unified Insert Query (The "Best Way" we discussed)
            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role); 
            
            ps.executeUpdate();
            
            // 4. Success Redirect
            response.sendRedirect("login.html?success=true");

        } catch (SQLIntegrityConstraintViolationException e) {
            // Duplicate Email handling
            response.sendRedirect("signUp.html?error=already_exists");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Server Error: " + e.getMessage());
        } finally {
            // Always close connections
            try { if(con != null) con.close(); } catch(SQLException e) { e.printStackTrace(); }
        }
    } // This closes doPost correctly

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("Please submit the form via POST method.");
    }
} // This closes the Class correctly