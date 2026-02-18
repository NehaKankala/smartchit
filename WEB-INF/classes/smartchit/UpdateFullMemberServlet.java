package smartchit;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.time.LocalDate;

public class UpdateFullMemberServlet extends HttpServlet {

protected void doPost(HttpServletRequest req,
HttpServletResponse res) throws ServletException, IOException {

int chitId = Integer.parseInt(req.getParameter("chit_id"));
int memberId = Integer.parseInt(req.getParameter("member_id"));

boolean chitLifted = Boolean.parseBoolean(req.getParameter("chit_lifted"));
String liftDateStr = req.getParameter("lift_date");

java.sql.Date liftDate = null;
if(liftDateStr!=null && !liftDateStr.isEmpty()){
liftDate = java.sql.Date.valueOf(liftDateStr);
}

try{
Connection con = DBConnection.getConnection();

/* UPDATE LIFT INFO */
PreparedStatement psLift = con.prepareStatement(
"UPDATE members SET chit_lifted=?, lift_date=? WHERE member_id=?");

psLift.setBoolean(1,chitLifted);
psLift.setDate(2,liftDate);
psLift.setInt(3,memberId);
psLift.executeUpdate();

/* GET TOTAL MONTHS + START DATE */
PreparedStatement psChit = con.prepareStatement(
"SELECT total_months, start_date FROM chits WHERE chit_id=?");

psChit.setInt(1,chitId);
ResultSet rsChit = psChit.executeQuery();
rsChit.next();

int totalMonths = rsChit.getInt("total_months");
java.sql.Date startDate = rsChit.getDate("start_date");

/* CALCULATE LIFT MONTH NUMBER */
int liftMonth = 0;

if(chitLifted && liftDate != null){

PreparedStatement psLiftMonth = con.prepareStatement(
"SELECT TIMESTAMPDIFF(MONTH, ?, ?) + 1 AS lift_month");

psLiftMonth.setDate(1, startDate);
psLiftMonth.setDate(2, liftDate);

ResultSet rsLift = psLiftMonth.executeQuery();
if(rsLift.next()){
liftMonth = rsLift.getInt("lift_month");
}
}

/* UPDATE EACH MONTH */
for(int m=1;m<=totalMonths;m++){

String status = req.getParameter("month_"+m);

if(status == null){
    // get existing status from DB
    PreparedStatement psExisting = con.prepareStatement(
        "SELECT status FROM payments WHERE chit_id=? AND member_id=? AND month_number=?"
    );
    psExisting.setInt(1, chitId);
    psExisting.setInt(2, memberId);
    psExisting.setInt(3, m);
    ResultSet rsExisting = psExisting.executeQuery();

    if(rsExisting.next()){
        status = rsExisting.getString("status");
    } else {
        status = "NOT PAID";
    }
}


if(status == null) continue;

int amount = 0;

if("PAID".equals(status)){
    if(chitLifted && m > liftMonth){
        amount = 6000;
    } else {
        amount = 5000;
    }
}


PreparedStatement ps = con.prepareStatement(
"INSERT INTO payments(chit_id,member_id,month_number,status,amount_paid,payment_date) "
+ "VALUES(?,?,?,?,?,?) "
+ "ON DUPLICATE KEY UPDATE status=?, amount_paid=?, payment_date=?");

ps.setInt(1,chitId);
ps.setInt(2,memberId);
ps.setInt(3,m);
ps.setString(4,status);
ps.setInt(5,amount);
ps.setDate(6,java.sql.Date.valueOf(LocalDate.now()));

ps.setString(7,status);
ps.setInt(8,amount);
ps.setDate(9,java.sql.Date.valueOf(LocalDate.now()));

ps.executeUpdate();
}

res.sendRedirect("viewChit.jsp?chit_id="+chitId);

}catch(Exception e){
e.printStackTrace();
}
}
}

