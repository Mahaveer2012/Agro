# Use Tomcat 10 with Java 25 (Temurin JDK)
FROM tomcat:10.1-jdk25-temurin

# 1. Clean up default Tomcat apps for security and speed
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Deploy your app
# Since you exported your WAR file as ROOT.war from Eclipse:
COPY ROOT.war /usr/local/tomcat/webapps-javaee/ROOT.war

# 3. Expose the standard port
EXPOSE 8080

# 4. Start Tomcat
CMD ["catalina.sh", "run"]