<%@ page import="smartchit.DBConnection" %>
<%@ page import="java.sql.*" %>
<form action="AdminLoginServlet" method="post">
<h2>Admin Login</h2>

Username:
<input type="text" name="username" required><br>

Password:
<input type="password" name="password" required><br>

<button type="submit">Login</button>
</form>

