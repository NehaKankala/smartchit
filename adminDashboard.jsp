<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="smartchit.DBConnection" %>

<style>

body{
    font-family: Arial, sans-serif;
    background:#f4f6f8;
    margin:20px;
}

.header{
    text-align:center;
    margin-bottom:20px;
}

.header h1{
    margin:0;
    color:#2c3e50;
}

.header h3{
    margin:5px 0;
    color:#555;
    font-weight:normal;
}

.top-bar{
    margin-bottom:20px;
}

button{
    padding:8px 14px;
    background:#2c7be5;
    color:white;
    border:none;
    border-radius:4px;
    cursor:pointer;
}

button:hover{
    background:#1a5fd0;
}

table{
    width:100%;
    border-collapse:collapse;
    background:white;
}

th, td{
    padding:10px;
    border:1px solid #ddd;
    text-align:center;
}

th{
    background:#2c3e50;
    color:white;
}

.status-active{
    color:green;
    font-weight:bold;
}

.status-completed{
    color:red;
    font-weight:bold;
}

.summary-box{
    display:flex;
    gap:20px;
    margin-bottom:20px;
}

.card{
    flex:1;
    background:white;
    padding:15px;
    border-radius:6px;
    box-shadow:0 2px 6px rgba(0,0,0,0.1);
    text-align:center;
}

.card h3{
    margin:0;
    font-size:22px;
    color:#2c3e50;
}

.card p{
    margin:5px 0 0 0;
    color:#666;
}

</style>

<div class="header">
    <h1>Sri Raja Rajeshwara Chitti</h1>
    <h3>Kankala Ravinder & Sarala</h3>
</div>

<div class="top-bar">
    <a href="addChit.jsp">
        <button>Create New Chit</button>
    </a>
</div>

<%
Connection con = DBConnection.getConnection();

/* TOTAL CHITS */
Statement st1 = con.createStatement();
ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) FROM chits");
rs1.next();
int totalChits = rs1.getInt(1);

/* ACTIVE CHITS */
ResultSet rs2 = st1.executeQuery("SELECT COUNT(*) FROM chits WHERE status='Active'");
rs2.next();
int activeChits = rs2.getInt(1);

/* COMPLETED CHITS */
ResultSet rs3 = st1.executeQuery("SELECT COUNT(*) FROM chits WHERE status='Completed'");
rs3.next();
int completedChits = rs3.getInt(1);
%>

<div class="summary-box">

<div class="card">
<h3><%=totalChits%></h3>
<p>Total Chits</p>
</div>

<div class="card">
<h3><%=activeChits%></h3>
<p>Active Chits</p>
</div>

<div class="card">
<h3><%=completedChits%></h3>
<p>Completed Chits</p>
</div>

</div>

<table>
<tr>
<th>Chit Name</th>
<th>Start Date</th>
<th>Total Months</th>
<th>Status</th>
<th>Members</th>
<th>Action</th>
</tr>

<%
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM chits ORDER BY chit_id DESC");

while(rs.next()){

int chitId = rs.getInt("chit_id");

/* MEMBER COUNT */
PreparedStatement psCount = con.prepareStatement(
"SELECT COUNT(*) FROM members WHERE chit_id=?");
psCount.setInt(1,chitId);
ResultSet rc = psCount.executeQuery();
rc.next();
int memberCount = rc.getInt(1);
%>

<tr>
<td><%=rs.getString("chit_name")%></td>
<td><%=rs.getDate("start_date")%></td>
<td><%=rs.getInt("total_months")%></td>

<td>
<%
if("Completed".equals(rs.getString("status"))){
%>
<span class="status-completed">Completed</span>
<%
}else{
%>
<span class="status-active">Active</span>
<%
}
%>
</td>

<td><%=memberCount%> / 20</td>

<td>
<a href="viewChit.jsp?chit_id=<%=chitId%>">
<button>Open</button>
</a>
</td>

</tr>

<%
}
%>

</table>

