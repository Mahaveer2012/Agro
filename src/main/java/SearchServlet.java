

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String queryTerm = request.getParameter("query");
        List<Map<String, String>> searchResults = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AGRI", "root", "Mahav994##");
            
            // The SQL 'LIKE' operator finds matches anywhere in the string
            String sql = "SELECT * FROM products WHERE name LIKE ? OR category LIKE ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, "%" + queryTerm + "%");
            pst.setString(2, "%" + queryTerm + "%");
            
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Map<String, String> p = new HashMap<>();
                p.put("id", rs.getString("id"));
                p.put("name", rs.getString("name"));
                p.put("price", rs.getString("price"));
                p.put("img", rs.getString("image_url"));
                searchResults.add(p);
            }

            // We send the search results to the same JSP
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("isSearch", true); // Tell the JSP we are in 'search mode'
            
            request.getRequestDispatcher("mainmart.jsp").forward(request, response);
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}