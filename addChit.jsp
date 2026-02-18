<%@ page import="smartchit.DBConnection" %>
<%@ page import="java.sql.*" %>
<form action="AddChitServlet" method="post">

Chit Name:
<input type="text" name="chitname" required><br>

Start Date:
<input type="date" name="startdate" required><br>

<button type="submit">Create</button>

</form>

