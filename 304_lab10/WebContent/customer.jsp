<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{
out.print("<h2>Customer Profile</h2>");
String sql = "select * from customer where userid = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, userName);
ResultSet rst = pstmt.executeQuery();
while (rst.next()) {
	out.print("<table border = '1'><tr><th>Id</th><td>"+rst.getInt(1)+"</td></tr>");
	out.print("<tr><th>First Name</th><td>"+rst.getString(2)+"</td></tr>");
	out.print("<tr><th>Last Name</th><td>"+rst.getString(3)+"</td></tr>");
	out.print("<tr><th>Email</th><td>"+rst.getString(4)+"</td></tr>");
	out.print("<tr><th>Phone</th><td>"+rst.getString(5)+"</td></tr>");
	out.print("<tr><th>Address</th><td>"+rst.getString(6)+"</td></tr>");
	out.print("<tr><th>City</th><td>"+rst.getString(7)+"</td></tr>");
	out.print("<tr><th>State</th><td>"+rst.getString(8)+"</td></tr>");
	out.print("<tr><th>Postal Code</th><td>"+rst.getString(9)+"</td></tr>");
	out.print("<tr><th>Country</th><td>"+rst.getString(10)+"</td></tr>");
	out.print("<tr><th>User id</th><td>"+rst.getString(11)+"</td></tr>");
}
out.print("</table>");
// Make sure to close connection
con.close();
} catch (SQLException e) {
	out.print(e);
}
%>

</body>
</html>

