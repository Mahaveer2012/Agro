// Change this to your actual package name

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@SuppressWarnings("serial")
@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    @SuppressWarnings({ "unchecked" })
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String name = request.getParameter("prodName");
        String price = request.getParameter("prodPrice");

        HttpSession session = request.getSession();
        
        // Get the current cart from session, or create a new one if it doesn't exist
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // Create a map for the new item
        Map<String, String> item = new HashMap<>();
        item.put("name", name);
        item.put("price", price);
        cart.add(item);

        // Save the updated cart back to the session
        session.setAttribute("cart", cart);

        // Send a JSON response back to the JavaScript
        response.setContentType("application/json");
        response.getWriter().write("{\"cartSize\": " + cart.size() + "}");
    }
}