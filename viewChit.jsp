<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);
%>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.time.*" %>
<%@ page import="smartchit.DBConnection" %>

<%
int chitId = Integer.parseInt(request.getParameter("chit_id"));
Connection con = DBConnection.getConnection();

/* CHIT INFO */
PreparedStatement ps1 = con.prepareStatement(
"SELECT * FROM chits WHERE chit_id=?");
ps1.setInt(1,chitId);
ResultSet chit = ps1.executeQuery();
chit.next();

int totalMonths = chit.getInt("total_months");
java.sql.Date startDate = chit.getDate("start_date");


/* CURRENT MONTH */
PreparedStatement psMonth = con.prepareStatement(
"SELECT TIMESTAMPDIFF(MONTH,start_date,CURDATE())+1 AS current_month FROM chits WHERE chit_id=?");
psMonth.setInt(1,chitId);
ResultSet monthRs = psMonth.executeQuery();
monthRs.next();
int currentMonth = monthRs.getInt("current_month");

int monthsCompleted = currentMonth - 1;
int monthsLeft = totalMonths - monthsCompleted;

/* MARK COMPLETED */
if(monthsLeft <= 0){
PreparedStatement psUpdate = con.prepareStatement(
"UPDATE chits SET status='Completed' WHERE chit_id=?");
psUpdate.setInt(1,chitId);
psUpdate.executeUpdate();
}

/* MEMBER COUNT */
PreparedStatement psCount = con.prepareStatement(
"SELECT COUNT(*) FROM members WHERE chit_id=?");
psCount.setInt(1,chitId);
ResultSet countRs = psCount.executeQuery();
countRs.next();
int memberCount = countRs.getInt(1);

/* MEMBER LIST */
PreparedStatement psMembers = con.prepareStatement(
"SELECT * FROM members WHERE chit_id=? ORDER BY member_id");
psMembers.setInt(1,chitId);
ResultSet membersList = psMembers.executeQuery();
%>

<h2>Chit: <%=chit.getString("chit_name")%></h2>

<div>
Start: <b><%=startDate%></b> |
Total: <b><%=totalMonths%></b> |
Completed: <b><%=monthsCompleted%></b> |
Left: <b><%=monthsLeft%></b> |
Members: <b><%=memberCount%> / 20</b>
</div>

<hr>
<div style="margin-bottom:15px;">

<hr style="margin:15px 0;">

<h3>Add Member</h3>

<% if(memberCount < 20){ %>
<form action="AddMemberServlet" method="post" style="margin-bottom:20px;">
<input type="hidden" name="chitid" value="<%=chitId%>">

Name:
<input type="text" name="name" required>

Mobile:
<input type="text" name="mobile" required>

<button type="submit">Add Member</button>
</form>
<% } else { %>
<p style="color:red;">Maximum 20 members reached.</p>
<% } %>
</div>

<table border="1" cellpadding="5">

<!-- HEADER ROW 1 -->
<tr>
<th rowspan="2">Member</th>
<th rowspan="2">Mobile</th>
<th rowspan="2">Lifted?</th>
<th rowspan="2">Lift Date</th>

<%
Calendar cal = Calendar.getInstance();
cal.setTime(startDate);

for(int m=1; m<=totalMonths; m++){
String monthName = new SimpleDateFormat("MMM").format(cal.getTime());
%>
<th class="<%=m==currentMonth?"current-month":""%>">
<%=monthName%>
</th>
<%
cal.add(Calendar.MONTH,1);
}
%>

<th rowspan="2">Save</th>
</tr>

<!-- HEADER ROW 2 -->
<tr>
<%
for(int m=1;m<=totalMonths;m++){
%>
<th class="<%=m==currentMonth?"current-month":""%>">M<%=m%></th>
<%
}
%>
</tr>

<%
while(membersList.next()){

int memberId = membersList.getInt("member_id");
boolean chitLifted = membersList.getBoolean("chit_lifted");
java.sql.Date liftDate = membersList.getDate("lift_date");


/* DEFUALTER */
PreparedStatement psDef = con.prepareStatement(
"SELECT COUNT(*) FROM payments WHERE member_id=? AND status='NOT PAID'");
psDef.setInt(1, memberId);
ResultSet rsDef = psDef.executeQuery();
rsDef.next();
int unpaidCount = rsDef.getInt(1);
%>

<form action="UpdateFullMemberServlet" method="post">
<input type="hidden" name="chit_id" value="<%=chitId%>">
<input type="hidden" name="member_id" value="<%=memberId%>">

<tr>

<td>
<%=membersList.getString("name")%>
<% if(unpaidCount>=2){ %>
<span style="color:red; font-weight:bold;">(DEF)</span>
<% } %>

<% if(chitLifted){ %>
<span style="color:blue; font-weight:bold;">(LIFTED)</span>
<% } %>

</td>

<td>
<%=membersList.getString("mobile")%>
<a target="_blank"
href="https://wa.me/91<%=membersList.getString("mobile")%>?text=Please%20pay%20this%20month%20chit">
Send Reminder
</a>

</td>

<td>
<select name="chit_lifted">
<option value="false" <%=!chitLifted?"selected":""%>>No</option>
<option value="true" <%=chitLifted?"selected":""%>>Yes</option>
</select>
</td>

<td>
<input type="date" name="lift_date"
value="<%= liftDate!=null?liftDate:"" %>">
</td>

<%
for(int m=1;m<=totalMonths;m++){

PreparedStatement psPay = con.prepareStatement(
"SELECT status FROM payments WHERE chit_id=? AND member_id=? AND month_number=?");
psPay.setInt(1,chitId);
psPay.setInt(2,memberId);
psPay.setInt(3,m);
ResultSet pay = psPay.executeQuery();

String status="NOT PAID";
if(pay.next()){ status = pay.getString("status"); }

boolean isCurrentMonth = (m==currentMonth);
boolean isAfter15 = LocalDate.now().getDayOfMonth()>15;
boolean markRed = isCurrentMonth && status.equals("NOT PAID") && isAfter15;
%>

<td style="background:<%=status.equals("PAID")?"#c8f7c5":(markRed?"#f8d7da":"")%>">

<select name="month_<%=m%>" <%=m>currentMonth?"disabled":""%>>
<option value="NOT PAID" <%=status.equals("NOT PAID")?"selected":""%>>NP</option>
<option value="PAID" <%=status.equals("PAID")?"selected":""%>>Paid</option>
</select>

</td>

<%
}
%>

<%
PreparedStatement psTotal = con.prepareStatement(
"SELECT SUM(amount_paid) FROM payments WHERE member_id=? AND status='PAID'");
psTotal.setInt(1,memberId);
ResultSet rsTotal = psTotal.executeQuery();
rsTotal.next();
int totalPaid = rsTotal.getInt(1);
%>


<td><button type="submit">Save</button></td>

</tr>
</form>

<%
}
%>

</table>
<a href="adminDashboard.jsp">⬅ Back</a>
<script>
window.onload = function(){
var currentCol = document.querySelector(".current-month");
if(currentCol){
currentCol.scrollIntoView({behavior:"smooth",inline:"center"});
}
}
</script>

