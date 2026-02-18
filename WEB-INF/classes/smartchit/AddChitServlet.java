package smartchit;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AddChitServlet extends HttpServlet{

protected void doPost(HttpServletRequest req,
HttpServletResponse res)throws ServletException,IOException{

String name=req.getParameter("chitname");
String date=req.getParameter("startdate");

try{
Connection con=DBConnection.getConnection();

PreparedStatement ps=con.prepareStatement(
"INSERT INTO chits(chit_name,start_date) VALUES(?,?)");

ps.setString(1,name);
ps.setString(2,date);

ps.executeUpdate();

res.sendRedirect("adminDashboard.jsp");

}catch(Exception e){e.printStackTrace();}
}
}

