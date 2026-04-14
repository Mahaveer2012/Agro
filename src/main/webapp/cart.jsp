<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgriGO | Your Harvest Basket</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&family=Playfair+Display:wght@700;900&display=swap" rel="stylesheet">
    <style>
        :root { 
            --leaf: #4A6741; --honey: #E6A13C; --cream: #FAF9F4; --soil: #2D241E; --white: #FFFFFF; --berry: #C0392B;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: var(--cream); color: var(--soil); font-family: 'Quicksand', sans-serif; min-height: 100vh; }
        
        nav { 
            background: var(--white); padding: 15px 6%; display: flex; 
            justify-content: space-between; align-items: center; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.03); 
        }
        .brand { font-family: 'Playfair Display', serif; font-size: 1.6rem; color: var(--leaf); text-decoration: none; font-weight: 900; }
        .back-link { text-decoration: none; color: var(--leaf); font-weight: 700; font-size: 0.9rem; }

        .container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        h1 { font-family: 'Playfair Display', serif; color: var(--leaf); font-size: 2.8rem; margin-bottom: 5px; text-align: center; }
        .subtitle { text-align: center; opacity: 0.6; margin-bottom: 40px; font-style: italic; }

        .cart-card { background: var(--white); border-radius: 30px; padding: 40px; box-shadow: 0 15px 40px rgba(0,0,0,0.04); border: 1px solid #F0EFEA; }
        
        .cart-header { display: grid; grid-template-columns: 2fr 1fr 1fr; padding-bottom: 15px; border-bottom: 2px solid var(--cream); font-weight: 700; color: var(--leaf); font-size: 0.8rem; text-transform: uppercase; }

        .cart-item { display: grid; grid-template-columns: 2fr 1fr 1fr; align-items: center; padding: 25px 0; border-bottom: 1px solid #F9F9F9; }
        .item-info h3 { margin: 0; font-family: 'Playfair Display', serif; color: var(--soil); font-size: 1.3rem; }
        .item-price { color: var(--leaf); font-weight: 800; font-size: 1.1rem; }
        
        .remove-btn { 
            background: #FFF5F5; color: var(--berry); padding: 8px 15px; border-radius: 12px; 
            text-decoration: none; font-size: 0.75rem; font-weight: 700; border: 1px solid transparent; transition: 0.3s;
        }
        .remove-btn:hover { background: var(--berry); color: white; }

        .summary-section { margin-top: 30px; padding-top: 20px; border-top: 2px dashed #EEE; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .total-row { margin-top: 15px; font-size: 1.8rem; font-weight: 800; color: var(--soil); border-top: 1px solid #EEE; padding-top: 15px; }

        .btn-checkout { 
            background: var(--leaf); color: white; padding: 18px 50px; border: none; 
            border-radius: 50px; font-size: 1.2rem; font-weight: 700; cursor: pointer; width: 100%; margin-top: 20px;
        }
        .btn-checkout:hover { background: var(--honey); }
        
        .empty-basket { text-align: center; padding: 60px 0; }
        
        /* FOOTER */
        footer { text-align: center; padding: 40px; color: #999; font-size: 0.8rem; }
    </style>
</head>
<body>

    <nav>
        <a href="mainmart.jsp" class="back-link">← Continue Shopping</a>
        <a href="mainmart.jsp" class="brand">AgriGO</a>
        <div style="width: 130px;"></div>
    </nav>

    <div class="container">
        <h1>Your Harvest 🌾</h1>
        <p class="subtitle">Supporting local farmers, one basket at a time.</p>

        <div class="cart-card">
            <%
                // SAFE CASTING: Step 1 - Get as raw Object
                Object cartObj = session.getAttribute("cart");
                
                // Step 2 - Suppress warning for the specific cast
                @SuppressWarnings("unchecked")
                List<Map<String, String>> cart = (List<Map<String, String>>) cartObj;
                
                double subtotal = 0;

                if (cart == null || cart.isEmpty()) {
            %>
                <div class="empty-basket">
                    <div style="font-size: 4rem; margin-bottom: 20px;">🚜</div>
                    <h3>Your basket is empty.</h3>
                    <p style="margin-bottom: 25px; opacity: 0.6;">The fields are full of fresh crops!</p>
                    <a href="mainmart.jsp" class="btn-checkout" style="text-decoration: none;">Go to Market</a>
                </div>
            <%
                } else {
            %>
                <div class="cart-header">
                    <span>Crop Detail</span>
                    <span>Price</span>
                    <span>Action</span>
                </div>

                <%
                    for (int i = 0; i < cart.size(); i++) {
                        Map<String, String> item = cart.get(i);
                        String name = item.get("name");
                        String priceStr = item.get("price");
                        double price = 0;
                        try {
                            price = Double.parseDouble(priceStr);
                            subtotal += price;
                        } catch (Exception e) { /* Handle unparseable prices */ }
                %>
                    <div class="cart-item">
                        <div class="item-info">
                            <h3><%= name %></h3>
                            <p style="font-size: 0.7rem; color: #999;">Verified Organic • Grade A</p>
                        </div>
                        <div class="item-price">₹<%= priceStr %></div>
                        <div>
                            <a href="RemoveFromCartServlet?index=<%= i %>" class="remove-btn">Remove ✕</a>
                        </div>
                    </div>
                <%
                    }
                %>

                <div class="summary-section">
                    <div class="summary-row">
                        <span>Items Total</span>
                        <span>₹<%= subtotal %></span>
                    </div>
                    <div class="summary-row" style="color: var(--leaf); font-weight: 700;">
                        <span>Eco-Friendly Shipping</span>
                        <span>FREE</span>
                    </div>
                    <div class="summary-row total-row">
                        <span>Grand Total</span>
                        <span>₹<%= subtotal %></span>
                    </div>

                    <button class="btn-checkout" onclick="alert('Order Placed Successfully! Thank you for supporting our farmers.')">
                        Place Order 💳
                    </button>
                </div>
            <%
                }
            %>
        </div>
    </div>

    <footer>
        &copy; 2026 AgriGO Heritage Logistics | Sustainable Agriculture Initiative
    </footer>

</body>
</html>