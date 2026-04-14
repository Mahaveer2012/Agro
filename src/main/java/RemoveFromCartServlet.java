 // Change this to your actual package name

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@SuppressWarnings("serial")
@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    @SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String indexStr = request.getParameter("index");
        HttpSession session = request.getSession();
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");

        if (cart != null && indexStr != null) {
            try {
                int index = Integer.parseInt(indexStr);
                if (index >= 0 && index < cart.size()) {
                    cart.remove(index);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // After removing, send the user back to the cart page
        response.sendRedirect("cart.jsp");
    }
}