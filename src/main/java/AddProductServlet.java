import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.*;

@SuppressWarnings("serial")
@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Extract data from the Add Product form
        String name = request.getParameter("pName");
        String category = request.getParameter("pCategory");
        String price = request.getParameter("pPrice");
        String img = request.getParameter("pImg");

        try (Connection con = DBConnection.getConnection()) {

            // 2. Insert into Database
            String sql = "INSERT INTO products (name, category, price, image_url) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, price);
            ps.setString(4, img);

            int result = ps.executeUpdate();

            if (result > 0) {

                // 3. ALSO store in application scope (for mainmart.jsp)
                ServletContext application = getServletContext();

                String key = category + "Items";

                List<Map<String, String>> list =
                        (List<Map<String, String>>) application.getAttribute(key);

                if (list == null) {
                    list = new ArrayList<>();
                }

                Map<String, String> product = new HashMap<>();
                product.put("name", name);
                product.put("price", price);
                product.put("img", img);

                list.add(product);

                application.setAttribute(key, list);

                // 4. Redirect back to market
                response.sendRedirect("mainmart.jsp?msg=added");

            } else {
                response.sendRedirect("addproduct.jsp?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addproduct.jsp?error=db_error");
        }
    }
}