<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp" id = "form">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
<br><label for="category">Search by category</label>
<select name="category" id="category" form="form">
						<option value="0">No Category</option>
						<option value="1">Milk</option>
						<option value="2">Dark</option>
						<option value="3">White</option>
						<option value="4">Nuts</option>
						<option value="5">Semisweet</option>
						<option value="6">Drink</option>
						<option value="7">Unsweetened</option>
						<option value="8">Cocoa Powder</option>
					  </select>
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
String category =  request.getParameter("category");
int categoryId = 0;
if (category == null)
	category = "0";
categoryId = Integer.parseInt(category); 
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{
// Print out the ResultSet

String sql = "select productName, productPrice, productId from product where productName like ?";
if (categoryId != 0)
	sql += " and categoryId = ?";

PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, "%" + name + "%");
if (categoryId != 0)
	pstmt.setInt(2, categoryId);
ResultSet rst = pstmt.executeQuery();
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

out.println("<table><tr><td></td><th>Product Name</th><th>Price</th></tr>");

while (rst.next()) {
String e = rst.getString(1);

out.println("<tr><td><a href='addcart.jsp?id="+rst.getInt(3)+"&name="+e+"&price="+rst.getDouble(2)+"'>Add to Cart</a></td>" +
           "<td><a href='product.jsp?id="+rst.getInt(3)+"'><font color='#FFA000'>"+rst.getString(1)+"</font></a></td><td>"+currFormat.format(rst.getDouble(2))+"</td></tr>");
}
out.println("</table>");
// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection
closeConnection();
// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00

} catch (SQLException e) {
	out.print(e);
}
%>

</body>
</html>