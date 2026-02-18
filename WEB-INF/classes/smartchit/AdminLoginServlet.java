package smartchit;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AdminLoginServlet extends HttpServlet {

protected void doPost(HttpServletRequest req,
                      HttpServletResponse res)
                      throws ServletException, IOException {

String user=req.getParameter("username");
String pass=req.getParameter("password");

try{
Connection con=DBConnection.getConnection();

PreparedStatement ps=con.prepareStatement(
"SELECT * FROM admins WHERE username=? AND password=?");

ps.setString(1,user);
ps.setString(2,pass);

ResultSet rs=ps.executeQuery();

if(rs.next()){
HttpSession session=req.getSession();
session.setAttribute("admin",user);
res.sendRedirect("adminDashboard.jsp");
}else{
res.getWriter().println("Invalid Admin Login");
}
}catch(Exception e){e.printStackTrace();}
}
}

