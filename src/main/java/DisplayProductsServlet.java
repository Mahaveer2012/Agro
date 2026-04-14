

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
@WebServlet("/DisplayProductsServlet")
public class DisplayProductsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        List<Map<String, String>> milletList = new ArrayList<>();
        List<Map<String, String>> fruitList = new ArrayList<>();
        List<Map<String, String>> rootList = new ArrayList<>();
        List<Map<String, String>> pulseList = new ArrayList<>();
        List<Map<String, String>> spiceList = new ArrayList<>();
        List<Map<String, String>> greenList = new ArrayList<>();
        
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
             con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AGRI", "root", "Mahav994##");
            
            ResultSet rs = con.prepareStatement("SELECT * FROM products").executeQuery();

            while (rs.next()) {
                Map<String, String> p = new HashMap<>();
                p.put("name", rs.getString("name"));
                p.put("price", rs.getString("price"));
                p.put("img", rs.getString("image_url"));
                
                String cat = rs.getString("category");

                // Match these exactly to the names in your Add Product Form & JSP
                if ("millet".equals(cat)) milletList.add(p);
                else if ("fruit".equals(cat)) fruitList.add(p);
                else if ("root".equals(cat)) rootList.add(p);
                else if ("pulse".equals(cat)) pulseList.add(p);
                else if ("spice".equals(cat)) spiceList.add(p);
                else if ("green".equals(cat)) greenList.add(p);
            }

            // Set data as attributes for the JSP to read
            request.setAttribute("milletItems", milletList);
            request.setAttribute("fruitItems", fruitList);
            request.setAttribute("rootItems", rootList);
            request.setAttribute("pulseItems", pulseList);
            request.setAttribute("spiceItems", spiceList);
            request.setAttribute("greenItems", greenList);
            
            // Forward the request to the JSP
            request.getRequestDispatcher("mainmart.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // This ensures the driver is "unregistered" correctly
            try { if (con != null) con.close(); } catch (SQLException e) {}
        } }
}