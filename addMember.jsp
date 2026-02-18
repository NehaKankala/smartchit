<%@ page import="smartchit.DBConnection" %>
<%@ page import="java.sql.*" %>
<form action="AddMemberServlet" method="post">

Chit ID:
<input type="number" name="chitid" required><br>

Member Name:
<input type="text" name="name" required><br>

Mobile (Password):
<input type="text" name="mobile" required><br>

<button type="submit">Add Member</button>

</form>

