# AgriGo - Farm-to-Table Web Platform 🚜

A Java Full Stack application that connects farmers directly with customers to sell fresh produce.

## 🛠️ Tech Stack
* **Java Servlets** (Backend Logic)
* **JSP** (Dynamic Frontend)
* **MySQL** (Database Management)
* **Apache Tomcat 11** (Web Server)
* **CSS3** (Custom Modern UI)

## 🌟 Key Features
* **Role-Based Login:** Toggle between Farmer and Customer roles.
* **Admin Dashboard:** Secure access to user data via `/viewData` (Session-restricted).
* **Responsive Design:** Clean, modern interface using CSS Flexbox.

## 🚀 Setup Instructions
1. Clone the repository.
2. Import the `AGRI.sql` file into your MySQL Workbench.
3. Update `DB_PASSWORD` in `ViewDataServlet.java` to match your local setup.
4. Run on Server (Apache Tomcat 11.0.15).