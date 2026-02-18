FROM tomcat:9.0-jdk17

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your project into ROOT
COPY . /usr/local/tomcat/webapps/ROOT

# Install wget
RUN apt-get update && apt-get install -y wget

# Download MySQL Connector JAR directly (recommended way)
RUN wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.6.0/mysql-connector-j-9.6.0.jar \
    -O /usr/local/tomcat/lib/mysql-connector-j.jar

EXPOSE 8080

CMD ["catalina.sh", "run"]

