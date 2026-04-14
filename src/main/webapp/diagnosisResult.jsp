<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>AgriGO | Diagnosis Report</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        body { background: #f4f7f6; font-family: 'Quicksand', sans-serif; padding: 50px; }
        .report-box { background: white; max-width: 800px; margin: auto; padding: 40px; border-radius: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        h2 { color: #2D6A4F; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .ai-text { line-height: 1.8; color: #444; white-space: pre-wrap; margin-top: 20px; }
        .btn-back { display: inline-block; margin-top: 30px; background: #2D6A4F; color: white; padding: 12px 25px; border-radius: 10px; text-decoration: none; }
    </style>
</head>
<body>
    <div class="report-box">
        <h2>Health Diagnosis Report</h2>
        <div id="result" class="ai-text">Analyzing report...</div>
        <a href="cropCare.jsp" class="btn-back">Scan Another Crop</a>
    </div>
	<div id="diagnosis-text" style="white-space: pre-wrap; font-family: sans-serif;">
    Processing results...
</div>
   <script>
    try {
        // Parse the raw JSON string passed from Servlet
        const responseData = <%= request.getAttribute("rawAiData") %>;
        
        // Extract the text part (Gemini's standard JSON path)
        const text = responseData.candidates[0].content.parts[0].text;
        
        document.getElementById('diagnosis-text').innerText = text;
    } catch (e) {
        document.getElementById('diagnosis-text').innerText = "Error: Could not parse diagnosis. Please try again with a clearer photo.";
        console.error("JSON Error:", e);
    }
</script>
</body>
</html>