import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Scanner;

@SuppressWarnings("serial")
@WebServlet("/CropDiagnosisServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class CropDiagnosisServlet extends HttpServlet {

	// 1. Update the API_URL to use v1 (Stable) and gemini-2.5-flash
	private final String API_KEY = "AIzaSyDXKKAvybE5TpH0KFtphojGJ347o-9psY4";
	// Try this lighter, faster version if Flash is busy:
	// Updated to the stable 2026 Gemini 2.5 endpoint
	private final String API_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash-lite:generateContent?key=" + API_KEY;	
	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Validate the Uploaded Part
            Part filePart = request.getPart("cropImage");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("cropCare.jsp?error=no_file");
                return;
            }

            // 2. Convert Image to Base64 (Cleaned)
            byte[] imageBytes;
            try (InputStream is = filePart.getInputStream()) {
                imageBytes = is.readAllBytes();
            }
            String base64Image = Base64.getEncoder().encodeToString(imageBytes).replaceAll("\\R", "");

            // 3. Construct JSON Payload (Carefully formatted)
            String prompt = "Identify the crop disease. Provide Disease Name, Symptoms, and Treatment (Organic and Chemical).";
            
            String jsonBody = "{"
            	    + "\"contents\": [{"
            	    + "  \"parts\": ["
            	    + "    {\"text\": \"" + prompt + "\"},"
            	    + "    {\"inline_data\": {\"mime_type\": \"image/jpeg\", \"data\": \"" + base64Image + "\"}}"
            	    + "  ]"
            	    + "}]"
            	    + "}";

            // 4. Set up Connection
            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000); // 10 seconds
            conn.setReadTimeout(30000);    // 30 seconds

            // 5. Write JSON Payload
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // 6. Handle Response
            int responseCode = conn.getResponseCode();
            System.out.println("Gemini Response Code: " + responseCode);

            InputStream responseStream = (responseCode >= 200 && responseCode < 300) 
                                         ? conn.getInputStream() 
                                         : conn.getErrorStream();

            String rawResponse = "";
            if (responseStream != null) {
                try (Scanner s = new Scanner(responseStream, StandardCharsets.UTF_8).useDelimiter("\\A")) {
                    rawResponse = s.hasNext() ? s.next() : "";
                }
            }

            if (responseCode == 200) {
                // SUCCESS: Send raw JSON to JSP
                request.setAttribute("rawAiData", rawResponse);
                request.getRequestDispatcher("diagnosisResult.jsp").forward(request, response);
            } else {
                // FAILURE: Log the error and notify user
                System.err.println("API Error: " + rawResponse);
                response.sendRedirect("cropCare.jsp?error=api_error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cropCare.jsp?error=server_error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("cropCare.jsp");
    }
}