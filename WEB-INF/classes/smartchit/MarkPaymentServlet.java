package smartchit;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.time.LocalDate;

public class MarkPaymentServlet extends HttpServlet {

protected void doPost(HttpServletRequest req,
HttpServletResponse res) throws ServletException, IOException {

int chitId = Integer.parseInt(req.getParameter("chit_id"));
int memberId = Integer.parseInt(req.getParameter("member_id"));
int month = Integer.parseInt(req.getParameter("month"));
boolean lifted = Boolean.parseBoolean(req.getParameter("lifted"));

int amount = 5000;
if(lifted){
amount = 6000;
}

try{
Connection con = DBConnection.getConnection();

/* Prevent multiple lifts */
PreparedStatement checkLift = con.prepareStatement(
"SELECT * FROM payments WHERE chit_id=? AND month_number=? AND is_lifted=true");

checkLift.setInt(1, chitId);
checkLift.setInt(2, month);

ResultSet liftRs = checkLift.executeQuery();

if(lifted && liftRs.next()){
res.getWriter().println("Already one member lifted this month!");
return;
}

/* Insert Payment */
PreparedStatement ps = con.prepareStatement(
"INSERT INTO payments(chit_id,member_id,month_number,amount_paid,is_lifted,payment_date) VALUES(?,?,?,?,?,?)");

ps.setInt(1,chitId);
ps.setInt(2,memberId);
ps.setInt(3,month);
ps.setInt(4,amount);
ps.setBoolean(5,lifted);
ps.setDate(6,Date.valueOf(LocalDate.now()));

ps.executeUpdate();

res.sendRedirect("viewChit.jsp?chit_id="+chitId);

}catch(Exception e){
e.printStackTrace();
}
}
}

