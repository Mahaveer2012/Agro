import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // TCP/IP connection to local MySQL
         // Change this line in DBConnection.java
            con = DriverManager.getConnection(
            		"jdbc:mysql://127.0.0.1:3306/AGRI?useSSL=false&serverTimezone=UTC", 
            	    "root", 
            	    "Mahav994##"
            ); // your MySQL password here
            
            System.out.println("DB Connected ✅");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}