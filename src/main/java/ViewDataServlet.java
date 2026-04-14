import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/viewData")
public class ViewDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. SECURITY FIX: Check if the user is actually Mahaveer
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        // Replace with your actual admin email
        if (userEmail == null || !"mahaveergugliya9@gmail.com".equals(userEmail)) {
            response.sendRedirect("login.html?error=unauthorized");
            return;
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>AgriGO | Admin Panel</title>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', sans-serif; background: #f0fdf4; padding: 40px; }");
        out.println(".container { max-width: 900px; margin: auto; background: white; padding: 25px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #2e7d32; text-align: center; }");
        out.println("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
        out.println("th { background: #2e7d32; color: white; padding: 12px; text-align: left; }");
        out.println("td { padding: 12px; border-bottom: 1px solid #ddd; }");
        out.println(".role-tag { padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; text-transform: uppercase; }");
        out.println(".farmer { background: #dcfce7; color: #166534; }");
        out.println(".customer { background: #dbeafe; color: #1e40af; }");
        out.println(".back-link { display: block; margin-top: 20px; text-align: center; text-decoration: none; color: #2e7d32; font-weight: bold; }");
        out.println("</style></head><body>");

        out.println("<div class='container'>");
        out.println("<h1>AgriGO | Master User Directory</h1>");
        out.println("<table><tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th></tr>");

        // 2. USE TRY-WITH-RESOURCES: This automatically closes connections even if an error occurs
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AGRI", "root", "Mahav994##");
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT id, name, email, role FROM users")) {

                while(rs.next()) {
                    String role = rs.getString("role").toLowerCase(); // Normalize case for CSS
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("name") + "</td>");
                    out.println("<td>" + rs.getString("email") + "</td>");
                    out.println("<td><span class='role-tag " + role + "'>" + role + "</span></td>");
                    out.println("</tr>");
                }
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='4' style='color:red;'>Database Connectivity Error: " + e.getMessage() + "</td></tr>");
        }

        out.println("</table>");
        out.println("<a href='mainmart.jsp' class='back-link'>← Return to Dashboard</a>");
        out.println("</div></body></html>");
    }
}