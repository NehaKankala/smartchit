package smartchit;
import java.sql.*;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
            "jdbc:mysql://127.0.0.1:3306/smartchit?useSSL=false&serverTimezone=UTC",
            "root",
            "neha2004"
        );
    }
}

