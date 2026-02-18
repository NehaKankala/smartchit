<%@ page import="smartchit.DBConnection" %>
<%@ page import="java.sql.*" %>
<form action="PaymentServlet" method="post">

Member ID:
<input type="number" name="memberid" required><br>

Month Number:
<input type="number" name="month" required><br>

Is Lifted (true/false):
<input type="text" name="lifted"><br>

<button type="submit">Mark Payment</button>

</form>

