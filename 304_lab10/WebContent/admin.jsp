<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>



<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%

// TODO: Write SQL query that prints out total order amount by day
try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{
out.print("<h2>Administrator Sales Report by Day</h2>");
String sql = "select sum(totalAmount) as total, convert(date, orderDate) from ordersummary group by convert(date, orderDate)";
PreparedStatement pstmt = con.prepareStatement(sql);
ResultSet rst = pstmt.executeQuery();
out.print("<table border = '1'><tr><th>Order Date</th><th>Total Order Amount</th></tr>");

while (rst.next()) {
    out.print("<tr><td>"+rst.getString(2)+"</td><td>"+rst.getDouble(1)+"</td></tr>");
}
out.print("</table>");

out.print("<h2>All customers</h2>");
String sql2 = "select firstName, lastName, customerId from customer";
PreparedStatement pstmt2 = con.prepareStatement(sql2);
ResultSet rst2 = pstmt2.executeQuery();
out.print("<table border = '1'><tr><th>Name</th><th>Customer ID</th></tr>");
while (rst2.next()) {
    out.print("<tr><td>"+rst2.getString(1)+ " " + rst2.getString(2)+"</td><td>"+rst2.getInt(3)+"</td></tr>");

}
out.print("</table>");
con.close();
} catch (SQLException e) {
    out.print(e);
}

%>

</body>
</html>

