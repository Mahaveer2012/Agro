<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgriGO | Sell Your Harvest</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&family=Playfair+Display:wght@700;900&display=swap" rel="stylesheet">
    <style>
        :root { 
            --leaf: #4A6741; --honey: #E6A13C; --cream: #FAF9F4; --soil: #2D241E; --white: #FFFFFF; 
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: var(--cream); color: var(--soil); font-family: 'Quicksand', sans-serif; line-height: 1.6; }

        nav { 
            background: var(--white); padding: 15px 6%; display: flex; 
            justify-content: space-between; align-items: center; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.03); 
        }
        .brand { font-family: 'Playfair Display', serif; font-size: 1.5rem; color: var(--leaf); text-decoration: none; font-weight: 900; }

        .container { max-width: 600px; margin: 50px auto; padding: 0 20px; }
        
        .form-card { 
            background: var(--white); padding: 40px; border-radius: 30px; 
            box-shadow: 0 15px 40px rgba(0,0,0,0.04); border: 1px solid #F0EFEA; 
        }

        h1 { font-family: 'Playfair Display', serif; color: var(--leaf); margin-bottom: 10px; font-size: 2.2rem; text-align: center; }
        p.subtitle { text-align: center; color: #777; margin-bottom: 30px; font-size: 0.9rem; }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 700; color: var(--leaf); margin-bottom: 8px; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; }
        
        input, select, textarea {
            width: 100%; padding: 14px 20px; border: 1.5px solid #EEE; 
            border-radius: 12px; font-family: 'Quicksand', sans-serif; outline: none; transition: 0.3s;
        }
        input:focus, select:focus { border-color: var(--leaf); box-shadow: 0 0 0 4px rgba(74, 103, 65, 0.05); }

        .image-preview { 
            width: 100%; height: 180px; background: #F9F9F9; border-radius: 12px; 
            margin-top: 10px; display: flex; align-items: center; justify-content: center;
            border: 2px dashed #EEE; overflow: hidden;
        }
        .image-preview img { width: 100%; height: 100%; object-fit: cover; display: none; }

        .btn-submit {
            width: 100%; background: var(--leaf); color: white; padding: 16px; 
            border: none; border-radius: 50px; font-size: 1.1rem; font-weight: 700; 
            cursor: pointer; transition: 0.3s; margin-top: 10px;
        }
        .btn-submit:hover { background: var(--honey); transform: translateY(-2px); box-shadow: 0 10px 20px rgba(230, 161, 60, 0.2); }

        .back-link { display: block; text-align: center; margin-top: 20px; color: #999; text-decoration: none; font-size: 0.85rem; }
    </style>
</head>
<body>

<%
String role = (String) session.getAttribute("userRole");
if (!"farmer".equals(role)) {
    response.sendRedirect("mainmart.jsp?error=unauthorized");
    return;
}
%>

<nav>
    <a href="mainmart.jsp" class="brand">AgriGO</a>
    <a href="mainmart.jsp" style="text-decoration: none; color: var(--leaf); font-weight: 700;">Back to Market</a>
</nav>

<div class="container">
    <div class="form-card">
        <h1>List Your Harvest 🌾</h1>
        <p class="subtitle">Join our heritage network of local farmers.</p>

        <form action="AddProductServlet" method="POST">

            <div class="form-group">
                <label>Crop Name</label>
                <input type="text" name="pName" placeholder="e.g. Organic Alphonso Mango" required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="pCategory" required>
                    <option value="millet">Ancient Millets</option>
                    <option value="leaf">Leafy Greens</option>
                    <option value="fruit">Sweet Orchard</option>
                    <option value="root">Earthy Roots</option>
                    <option value="pulse">Protein Pulses</option>
                    <option value="spice">Pure Spices</option>
                </select>
            </div>

            <div class="form-group">
                <label>Price (per kg/unit)</label>
                <input type="number" name="pPrice" placeholder="₹ Enter Amount" required>
            </div>

            <div class="form-group">
                <label>Image URL</label>
                <input type="url" id="imgUrl" name="pImg" placeholder="https://image-link.com/photo.jpg" oninput="previewImage()">
                <div class="image-preview" id="previewContainer">
                    <span id="previewText" style="color: #CCC;">Image Preview</span>
                    <img id="imgElement" src="" alt="Crop Preview">
                </div>
            </div>

            <button type="submit" class="btn-submit">List My Product</button>
        </form>

        <a href="mainmart.jsp" class="back-link">Wait, I'm not ready yet</a>
    </div>
</div>

<script>
function previewImage() {
    const url = document.getElementById('imgUrl').value;
    const img = document.getElementById('imgElement');
    const text = document.getElementById('previewText');

    if (url) {
        img.src = url;
        img.style.display = 'block';
        text.style.display = 'none';
    } else {
        img.style.display = 'none';
        text.style.display = 'block';
    }
}
</script>

</body>
</html>