<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgriGO | The Heritage Harvest</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&family=Playfair+Display:wght@700;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --leaf: #4A6741; --honey: #E6A13C; --cream: #FAF9F4; --soil: #2D241E; --white: #FFFFFF;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: var(--cream); color: var(--soil); font-family: 'Quicksand', sans-serif; overflow-x: hidden; }

        /* --- NAVBAR --- */
        nav {
            background: var(--white); padding: 12px 6%; display: flex; 
            align-items: center; justify-content: space-between;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 1000;
        }
        .logo-link { display: flex; align-items: center; gap: 12px; text-decoration: none; }
        .logo-img { width: 45px; height: 45px; border-radius: 8px; object-fit: cover; border: 1px solid #eee; }
        .brand-name { font-family: 'Playfair Display', serif; font-size: 1.8rem; font-weight: 900; color: var(--leaf); }

        .search-container { flex: 0.4; }
        .search-container input {
            width: 100%; padding: 12px 25px; border: 1.5px solid #EEE;
            border-radius: 50px; background: #FDFDFD; outline: none;
        }
        #toast {
    visibility: hidden;
    min-width: 250px;
    background-color: var(--leaf);
    color: #fff;
    text-align: center;
    border-radius: 50px;
    padding: 16px;
    position: fixed;
    z-index: 1001;
    left: 50%;
    bottom: 30px;
    transform: translateX(-50%);
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}

#toast.show {
    visibility: visible;
    animation: fadein 0.5s, fadeout 0.5s 2.5s;
}

@keyframes fadein { from {bottom: 0; opacity: 0;} to {bottom: 30px; opacity: 1;} }
@keyframes fadeout { from {bottom: 30px; opacity: 1;} to {bottom: 0; opacity: 0;} }

        .nav-right { display: flex; gap: 20px; align-items: center; }
        .nav-right a { text-decoration: none; color: var(--leaf); font-weight: 700; font-size: 0.85rem; }

        /* --- CATEGORY SECTION --- */
        .category-section { padding: 40px 0 20px 6%; }
        .section-header { 
            display: flex; justify-content: space-between; align-items: center; 
            padding-right: 6%; margin-bottom: 20px;
        }
        .card, .category-section {
    transition: opacity 0.3s ease-in-out;
}
        .section-header h2 { font-family: 'Playfair Display', serif; font-size: 1.8rem; color: var(--leaf); }
        .section-header span { font-size: 0.8rem; font-weight: 700; color: var(--honey); text-transform: uppercase; }

        .scroll-container {
            display: flex; gap: 25px; overflow-x: auto; padding: 10px 20px 30px 0;
            scrollbar-width: none;
        }
        .scroll-container::-webkit-scrollbar { display: none; }

        /* --- CARD --- */
        .card {
            min-width: 280px; background: var(--white); border-radius: 20px;
            overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.02);
            transition: 0.3s; border: 1px solid rgba(0,0,0,0.03);
        }
        .card:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(74,103,65,0.12); }
        .card-img { width: 100%; height: 200px; object-fit: cover; }
        .card-body { padding: 20px; text-align: center; }
        .card-body h3 { font-family: 'Playfair Display', serif; font-size: 1.3rem; margin-bottom: 8px; }
        .price { color: var(--leaf); font-weight: 800; font-size: 1.2rem; margin-bottom: 15px; }
        
        .btn-add {
            width: 100%; padding: 10px; background: var(--leaf); color: white;
            border: none; border-radius: 12px; font-weight: 700; cursor: pointer;
        }
        .btn-add:hover { background: var(--honey); }

        /* --- FOOTER --- */
footer {
    background: var(--soil);
    color: #D1D1D1;
    padding: 60px 6% 30px;
    margin-top: 60px;

    display: flex;
    justify-content: space-around;   /* center columns */
    gap: 80px;                 /* space between them */
    flex-wrap: wrap;           /* responsive */
    text-align: left;
}

.footer-col {
    max-width: 320px;
}

.footer-col h4 {
    color: var(--honey);
    margin-bottom: 12px;
    font-family: 'Playfair Display', serif;
}

.footer-col p {
    font-size: 0.9rem;
    line-height: 1.6;
}

.footer-bottom {
    width: 100%;
    text-align: center;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid rgba(255,255,255,0.1);
    font-size: 0.8rem;
}
    </style>
</head>
<script>
function addToCart(name, price) {
    // 1. Prepare the data
    const params = new URLSearchParams();
    params.append('prodName', name);
    params.append('prodPrice', price);

    // 2. Send to the Java Servlet
    fetch('AddToCartServlet', { 
        method: 'POST', 
        body: params 
    })
    .then(response => {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.json();
    })
    .then(data => {
        // 3. Update the Navbar counter instantly
        const counter = document.getElementById('cart-count');
        if(counter) counter.innerText = data.cartSize;
        
        // 4. Show the Sweet Green Toast Notification
        const toast = document.getElementById("toast");
        if(toast) {
            toast.innerText = name + " added to basket! 🌿";
            toast.className = "show";
            // Hide it after 3 seconds
            setTimeout(function(){ toast.className = toast.className.replace("show", ""); }, 3000);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert("Field update failed. Is the AddToCartServlet running?");
    });
}
function filterCrops() {
    const input = document.getElementById('cropSearch').value.toLowerCase();
    const sections = document.getElementsByClassName('category-section');
    const noMatch = document.getElementById('no-match');
    let totalVisible = 0;

    for (let section of sections) {
        let sectionHasMatch = false;
        // Search only within THIS specific section
        const sectionCards = section.querySelectorAll('.card');

        sectionCards.forEach(card => {
            const name = card.querySelector('h3').innerText.toLowerCase();
            if (name.includes(input)) {
                card.style.display = ""; 
                sectionHasMatch = true;
                totalVisible++;
            } else {
                card.style.display = "none";
            }
        });

        // Hide section header if no items match
        section.style.display = sectionHasMatch ? "" : "none";
    }

    // Toggle No Match message
    noMatch.style.display = (totalVisible === 0 && input !== "") ? "block" : "none";
}
.admin-btn {
    background-color: #dc3545; /* Red for Admin/Danger */
    color: white;
    padding: 10px 15px;
    border-radius: 5px;
    text-decoration: none;
    font-weight: bold;
    display: inline-block;
    margin: 10px;
    border: 2px solid #b02a37;
}

.admin-btn:hover {
    background-color: #bb2d3b;
}

</script>
<body>
<div id="toast">Item added to your basket! 🌿</div>

    <nav>
        <a href="index.html" class="logo-link">
            <img src="logo.jpeg" alt="Logo" class="logo-img">
            <span class="brand-name">AgriGO</span>
        </a>
       <div class="search-container">
    <input type="text" id="cropSearch" onkeyup="filterCrops()" placeholder="🔍 Search Millets, Fruits, or Spices...">
</div>
       <div class="nav-right">
    <span style="font-size: 0.7rem; color: gray;">Role: <%= session.getAttribute("userRole") %></span>

    <% 
    // 1. Get the role using the correct key from LoginServlet
    String role = (String) session.getAttribute("userRole"); 

    // 2. Only show these tools if the person is a Farmer
    if (role != null && role.equalsIgnoreCase("farmer")  ) { 
%>
    <div class="farmer-controls" style="display: flex; gap: 12px; align-items: center;">
        
        <a href="cropCare.jsp" class="doctor-btn" 
           style="background: #2D6A4F; color: white; padding: 10px 20px; border-radius: 50px; text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 10px rgba(45, 106, 79, 0.2);">
           🩺 AI DOCTOR
        </a>

        <a href="addproduct.jsp" class="sell-btn" 
           style="background: #E6A13C; color: white; padding: 10px 20px; border-radius: 50px; text-decoration: none; font-weight: 700; box-shadow: 0 4px 10px rgba(230, 161, 60, 0.2);">
           🚜 SELL HARVEST
        </a>

    </div>
<% 
    } 
%>

    <a href="cart.jsp">🛒 CART (<span id="cart-count">0</span>)</a>
    
    
<%
    // 1. Get the session (don't create a new one)
    HttpSession sess = request.getSession(false);
    String loggedInEmail = (sess != null) ? (String) sess.getAttribute("userEmail") : null;

    // 2. Debugging: This will print to your Eclipse console
    System.out.println("MainMart Session Email: " + loggedInEmail);

    // 3. Check if it matches YOUR email exactly
    if (loggedInEmail != null && loggedInEmail.equalsIgnoreCase("mahaveergugliya9@gmail.com")) {
%>
    <div style="margin: 20px; text-align: center;">
        <a href="viewData" style="background: #2e7d32; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">
            📊 Open Admin Database
        </a>
    </div>
<%
    }
%>
</div>
    </nav>

    <%! 
        // Explicitly returns a List of Objects to avoid casting issues in the helper
        List getDisplayList(Object attr, String[][] dummies) {
            List list = (attr != null) ? new ArrayList((List)attr) : new ArrayList();
            for (String[] d : dummies) {
                if (list.size() >= 6) break;
                Map m = new HashMap();
                m.put("name", d[0]); m.put("price", d[1]); m.put("img", d[2]);
                list.add(m);
            }
            return list;
        }
    %>
<div id="no-match" style="display:none; text-align:center; padding:80px 20px; color:var(--leaf);">
    <h1 style="font-size: 4rem; margin-bottom: 20px;">🚜</h1>
    <h2 style="font-family: 'Playfair Display', serif;">No harvest found for that search...</h2>
    <p style="opacity: 0.6;">Try searching for "Millet", "Mango", or "Saffron"</p>
</div>
<div style="background:yellow; padding:10; font-size:10px;">
   
</div>
    <section class="category-section">
        <div class="section-header"><h2>🌾 Ancient Millets</h2><span>Energy from Grains</span></div>
        <div class="scroll-container">
            <% 
                String[][] mDummies = {
                    {"Finger Millet", "60", "https://media.gettyimages.com/id/1202283460/photo/close-up-of-finger-millet-eleusine-coracana-in-a-ceramic-bowl.jpg?s=612x612&w=gi&k=20&c=UasM0hxuj7kVSjxX_pA8SJJBOSIXQHPOCE5BFwnRDhQ="},
                    {"Pearl Millet", "55", "data:image/jpeg;base64,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"},
                    {"Jowar Grains", "65", "data:image/jpeg;base64,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"},
                    {"Foxtail Millet", "90", "https://organicmandya.com/cdn/shop/files/Foxtail_Millet_Navane.jpg?v=1757079600"},
                    {"Little Millet", "105", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ70-b6qFnsrp2tJ5a5dteP_oGrrxWPR3JMQ&s"},
                    {"Barnyard Millet", "110", "https://www.jiomart.com/images/product/original/rvnnvno7tg/farmbean-barnyard-millet-natural-grains-1-5kg-500g-x-3-packs-khira-swank-kuthiraivally-udalu-kodisama-siridhanya-native-low-gi-millet-rice-high-protein-100-more-fibre-than-rice-product-images-orvnnvno7tg-p595190226-0-202211140707.jpg?im=Resize=(420,420)"}
                };
            List mFinal = getDisplayList(application.getAttribute("milletItems"), mDummies);               for(Object item : mFinal) {
                    Map p = (Map) item;
            %>
                <div class="card"><img src="<%=p.get("img")%>" class="card-img"><div class="card-body"><h3><%=p.get("name")%></h3><p class="price">₹<%=p.get("price")%></p><button class="btn-add" onclick="addToCart('<%=p.get("name")%>', '<%=p.get("price")%>')">
    Add to Cart
</button></div></div>
            <% } %>
        </div>
    </section>

    <section class="category-section">
        <div class="section-header"><h2>🍃 Leafy Greens</h2><span>Plucked this Morning</span></div>
        <div class="scroll-container">
            <% 
                String[][] lDummies = {
                    {"Baby Spinach", "30", "https://images.unsplash.com/photo-1580910365203-91ea9115a319?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c3BpbmFjaHxlbnwwfHwwfHx8MA%3D%3D"},
                    {"Fresh Cilantro", "15", "https://img.freepik.com/free-psd/fresh-cilantro-celery-vibrant-culinary-duo_632498-26400.jpg?semt=ais_rp_50_assets&w=740&q=80"},
                    {"Curly Kale", "85", "https://www.jiomart.com/images/product/original/590003594/curly-kale-100-g-product-images-o590003594-p590362811-0-202501061730.jpg?im=Resize=(420,420)"},
                    {"Methi Leaves", "20", "https://www.shutterstock.com/shutterstock/videos/3959173861/thumb/1.jpg?ip=x480"},
                    {"Mint Leaves", "12", "https://www.shutterstock.com/shutterstock/videos/26911327/thumb/1.jpg?ip=x480"},
                    {"Red Amaranth", "25", "https://media.istockphoto.com/id/1168537773/photo/amaranthus-cruentus-amaranth-flowers.jpg?s=612x612&w=0&k=20&c=4g8X-4pbWjo2SQ2e-b2B8c8jCBmxd1c42AgoIs6FgsE="}
                };
            List lFinal = getDisplayList(application.getAttribute("leafItems"), lDummies);
                for(Object item : lFinal) {
                    Map p = (Map) item;
            %>
                <div class="card"><img src="<%=p.get("img")%>" class="card-img"><div class="card-body"><h3><%=p.get("name")%></h3><p class="price">₹<%=p.get("price")%></p><button class="btn-add" onclick="addToCart('<%=p.get("name")%>', '<%=p.get("price")%>')">
    Add to Cart</button></div></div>
            <% } %>
        </div>
    </section>

    <section class="category-section">
        <div class="section-header"><h2>🍎 Sweet Orchard</h2><span>Nature's Candy</span></div>
        <div class="scroll-container">
            <% 
                String[][] fDummies = {
                    {"Alphonso Mango", "1200", "https://images.unsplash.com/photo-1553279768-865429fa0078?w=400"},
                    {"Fuji Apple", "180", "https://media.istockphoto.com/id/2021650011/photo/japanese-fuji-apples-on-cutting-board.jpg?s=612x612&w=0&k=20&c=GVE3j-jU8E1jqTsokKJX5Mt4XNKQlkvgRrbU2ZSNYV0="},
                    {"Green Grapes", "90", "https://www.shutterstock.com/shutterstock/videos/1109857705/thumb/1.jpg?ip=x480"},
                    {"Dragon Fruit", "150", "https://img.freepik.com/free-photo/composition-delicious-exotic-dragon-fruit_23-2149090920.jpg?semt=ais_hybrid&w=740&q=80"},
                    {"Pomegranate", "140", "https://img.freepik.com/free-photo/fresh-pomegranate-wooden-table_176474-134.jpg?semt=ais_hybrid&w=740&q=80"},
                    {"Kiwi Fruit", "200", "https://static.vecteezy.com/system/resources/previews/030/677/357/non_2x/product-shots-of-kiwi-high-quality-4k-ultra-hd-h-free-photo.jpg"}
                };
            List fFinal = getDisplayList(application.getAttribute("fruitItems"), fDummies);
                for(Object item : fFinal) {
                    Map p = (Map) item;
            %>
                <div class="card"><img src="<%=p.get("img")%>" class="card-img"><div class="card-body"><h3><%=p.get("name")%></h3><p class="price">₹<%=p.get("price")%></p><button class="btn-add" onclick="addToCart('<%=p.get("name")%>', '<%=p.get("price")%>')">
    Add to Cart
</button></div></div>
            <% } %>
        </div>
    </section>

    <section class="category-section">
        <div class="section-header"><h2>🥔 Earthy Roots</h2><span>Deep from the Soil</span></div>
        <div class="scroll-container">
            <% 
                String[][] rDummies = {
                    {"Red Onions", "45", "https://img.freepik.com/free-photo/close-up-view-basket-red-onions_141793-5351.jpg?semt=ais_hybrid&w=740&q=80"},
                    {"Baby Potatoes", "35", "https://images.unsplash.com/photo-1518977676601-b53f82aba655?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cG90YXRvfGVufDB8fDB8fHww"},
                    {"Fresh Ginger", "140", "https://img.freepik.com/free-photo/honey-lemon-ginger-juice-food-beverage-products-from-ginger-extract-food-nutrition-concept_1150-26377.jpg?semt=ais_hybrid&w=740&q=80"},
                    {"Purple Carrot", "70", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTmrURFGud2qWO8baKcQgNpZMoYcGbR9ccdg&s"},
                    {"Sweet Potato", "50", "https://media.istockphoto.com/id/1163065638/photo/harvesting-sweet-potatoes.jpg?s=612x612&w=0&k=20&c=p2RLbXoBqZQxGHmBKGUP0IP775YiBOsBYo4uC4CHNU4="},
                    {"Beetroot", "40", "https://media.istockphoto.com/id/508511603/photo/beetroot-juice.jpg?s=612x612&w=0&k=20&c=IBMN_yhQPCO3gY6gumNIXFVBx3Yoq8_1I8UXinEI_QI="}
                };
            List rFinal = getDisplayList(application.getAttribute("rootItems"), rDummies);
                for(Object item : rFinal) {
                    Map p = (Map) item;
            %>
                <div class="card"><img src="<%=p.get("img")%>" class="card-img"><div class="card-body"><h3><%=p.get("name")%></h3><p class="price">₹<%=p.get("price")%></p><button class="btn-add" onclick="addToCart('<%=p.get("name")%>', '<%=p.get("price")%>')">
    Add to Cart
</button></div></div>
            <% } %>
        </div>
    </section>

    <section class="category-section">
        <div class="section-header"><h2>🍲 Protein Pulses</h2><span>Rich Lentils</span></div>
        <div class="scroll-container">
            <% 
                String[][] pDummies = {
                    {"Toor Dal", "160", "https://www.jiomart.com/images/product/original/rv7ckczas9/goodness-grocery-premium-quality-organic-unpolished-toor-dal-arhar-dal-tur-dal-2kg-product-images-orv7ckczas9-p595641409-0-202306131111.jpg?im=Resize=(1000,1000)"},
                    {"Moong Beans", "120", "https://t4.ftcdn.net/jpg/07/41/94/71/360_F_741947187_zR0Vi5qGgcLioq9Oh5Qorc9EIRRiTnYu.jpg"},
                    {"Black Urad", "145", "https://m.media-amazon.com/images/I/81Lh9cOLSUL.jpg"},
                    {"Chickpeas", "110", "https://www.shutterstock.com/shutterstock/videos/3920806059/thumb/1.jpg?ip=x480"},
                    {"Red Lentils", "115", "https://www.shutterstock.com/shutterstock/videos/3579461409/thumb/1.jpg?ip=x480"},
                    {"Rajma Beans", "130", "https://img.freepik.com/free-photo/red-kidney-beans-black-small-bowl-place-dark-floor_1150-35289.jpg"}
                };
            List pFinal = getDisplayList(application.getAttribute("pulseItems"), pDummies);
                for(Object item : pFinal) {
                    Map p = (Map) item;
            %>
                <div class="card"><img src="<%=p.get("img")%>" class="card-img"><div class="card-body"><h3><%=p.get("name")%></h3><p class="price">₹<%=p.get("price")%></p><button class="btn-add" onclick="addToCart('<%=p.get("name")%>', '<%=p.get("price")%>')">
    Add to Cart
</button></div></div>
            <% } %>
        </div>
    </section>

    <section class="category-section">
        <div class="section-header"><h2>✨ Pure Spices</h2><span>The Soul of Flavour</span></div>
        <div class="scroll-container">
            <% 
                String[][] sDummies = {
                    {"Kashmiri Saffron", "12000", "https://www.shutterstock.com/image-photo/heap-organic-dried-saffron-thread-600w-2341402899.jpg"},
                    {"Whole Turmeric", "160", "https://www.shutterstock.com/shutterstock/videos/3814660681/thumb/1.jpg?ip=x480"},
                    {"Black Pepper", "750", "https://media.istockphoto.com/id/469858939/photo/black-pepper.jpg?s=612x612&w=0&k=20&c=GwF_EvFrYNtwTdY5DN9gRS1eJnRf949jUQeqgqoLExE="},
                    {"Cinnamon Sticks", "450", "https://plus.unsplash.com/premium_photo-1726072356922-7d9d4eafcf71?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y2lubmFtb258ZW58MHx8MHx8fDA%3D"},
                    {"Cardamom Pods", "2800", "https://img.freepik.com/free-psd/fresh-green-cardamom-pods-wooden-bowl_84443-66311.jpg?semt=ais_hybrid&w=740&q=80"},
                    {"Red Chilli", "280", "https://img.freepik.com/free-photo/bowl-full-hot-peppers_1127-112.jpg"}
                };
            List sFinal = getDisplayList(application.getAttribute("spiceItems"), sDummies);
                for(Object item : sFinal) {
                    Map p = (Map) item;
            %>
                <div class="card"><img src="<%=p.get("img")%>" class="card-img"><div class="card-body"><h3><%=p.get("name")%></h3><p class="price">₹<%=p.get("price")%></p><button class="btn-add" onclick="addToCart('<%=p.get("name")%>', '<%=p.get("price")%>')">
    Add to Cart
</button></div></div>
            <% } %>
        </div>
    </section>

   <footer>
    <div class="footer-col">
        <h4>AgriGO Heritage</h4>
        <p>
            Direct from the soil of the farmers to your home. 
            We ensure purity, sustainability, and fair trade 
            for every grain harvested.
        </p>
    </div>

    <div class="footer-col">
        <h4>Support</h4>
        <p>📍 Krishi Bhawan, Main Road</p>
        <p>📞 +91 9988776655</p>
        <p>✉️ help@agrigo.com</p>
    </div>

    <div class="footer-bottom">
        © 2026 AgriGO Logistics | Empowering Farmers
    </div>
</footer>
</body>
</html>