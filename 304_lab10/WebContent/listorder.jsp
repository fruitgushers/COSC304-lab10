<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body>
	<%@ include file="header.jsp" %>
<h1>Order List</h1>


<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{

// Write query to retrieve all order summary records
String sql = "select orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
			 "from ordersummary join customer on ordersummary.customerId = customer.customerId";

// For each order in the ResultSet
PreparedStatement pstmt = con.prepareStatement(sql);
ResultSet rst = pstmt.executeQuery();
	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 
String sql2 = "select productId, quantity, price " +
              "from orderproduct where orderId = ?";
PreparedStatement pstmt2 = con.prepareStatement(sql2);
ResultSet rst2;
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
out.println("<table border='1'><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
while(rst.next()) {
	out.println("<tr><td>"+rst.getInt(1)+"</td><td>"+rst.getDate(2)+"</td><td>"+rst.getString(3)+
		"</td><td>"+rst.getString(4)+" "+rst.getString(5)+"</td><td>"+currFormat.format(rst.getDouble(6))+"</td></tr>");
	pstmt2.setString(1, rst.getString(1));
	rst2 = pstmt2.executeQuery();
	out.println("<td colspan='5'><table style='margin-left:160px' border='1'><tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
	while(rst2.next()) {
		out.println("<tr><td>"+rst2.getInt(1)+"</td><td>"+rst2.getInt(2)+"</td><td>"+currFormat.format(rst2.getDouble(3)));
	}
	out.println("</table></td>");
}
out.println("</table>");

// Close connection
closeConnection();
} catch (SQLException e) {
	out.println(e);
}

%>

</body>
</html>

