<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AgriGO | AI Crop Doctor</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        :root { --leaf: #4A6741; --cream: #FAF9F4; --white: #FFFFFF; }
        body { background-color: var(--cream); font-family: 'Quicksand', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .card { background: var(--white); padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); text-align: center; width: 450px; }
        h1 { color: var(--leaf); margin-bottom: 10px; }
        .upload-area { border: 2px dashed #ccc; padding: 30px; border-radius: 15px; margin: 20px 0; cursor: pointer; transition: 0.3s; }
        .upload-area:hover { border-color: var(--leaf); background: #f0fdf4; }
        .btn-scan { background: var(--leaf); color: white; border: none; padding: 15px 30px; border-radius: 50px; font-weight: 700; cursor: pointer; width: 100%; }
    </style>
</head>


<body>
<%
    String roleCheck = (String) session.getAttribute("userRole");
    if (roleCheck == null || !roleCheck.equalsIgnoreCase("farmer")) {
        response.sendRedirect("login.html?error=unauthorized");
        return;
    }
%>
    <div class="card">
        <h1>Crop Doctor 🌿</h1>
        <p>Upload a photo of your crop's leaves to diagnose diseases and get solutions.</p>
        
        <form action="CropDiagnosisServlet" method="POST" enctype="multipart/form-data">
            <div class="upload-area" onclick="document.getElementById('fileInput').click()">
                <p id="fileName">Click to upload image</p>
                <input type="file" id="fileInput" name="cropImage" accept="image/*" hidden required onchange="displayFileName()">
            </div>
            <button type="submit" class="btn-scan">Get AI Diagnosis</button>
        </form>
        <br>
        <a href="mainmart.jsp" style="color: #666; text-decoration: none; font-size: 0.9rem;">← Back to Market</a>
    </div>

    <script>
        function displayFileName() {
            const input = document.getElementById('fileInput');
            document.getElementById('fileName').innerText = input.files[0].name;
        }
    </script>
</body>
</html>