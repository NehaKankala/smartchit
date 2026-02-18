package smartchit;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AddMemberServlet extends HttpServlet {

protected void doPost(HttpServletRequest req,
HttpServletResponse res) throws ServletException, IOException {

int chitId = Integer.parseInt(req.getParameter("chitid"));
String name = req.getParameter("name");
String mobile = req.getParameter("mobile");

try{
Connection con = DBConnection.getConnection();

/* Check max 20 members */
PreparedStatement countPs = con.prepareStatement(
"SELECT COUNT(*) FROM members WHERE chit_id=?");

countPs.setInt(1, chitId);
ResultSet rs = countPs.executeQuery();
rs.next();

if(rs.getInt(1) >= 20){
res.getWriter().println("Maximum 20 members allowed!");
return;
}

/* Insert member */
PreparedStatement ps = con.prepareStatement(
"INSERT INTO members(chit_id,name,mobile) VALUES(?,?,?)");

ps.setInt(1,chitId);
ps.setString(2,name);
ps.setString(3,mobile);

ps.executeUpdate();

res.sendRedirect("viewChit.jsp?chit_id="+chitId);

}catch(Exception e){
e.printStackTrace();
}
}
}

