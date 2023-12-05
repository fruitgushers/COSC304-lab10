<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Rays Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{
String productId = request.getParameter("id");
String sql = "select productPrice, productName, productDesc from product where productId = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, productId);
ResultSet rst = pstmt.executeQuery();
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
String name = "";
Double price = 0.0;
String desc = "";
while (rst.next()) {
    name = rst.getString(2);
    price = rst.getDouble(1);
    desc = rst.getString(3);
    out.print("<h2>" + name + "</h2>");
    out.print("<table><tr>");
    out.print("<th>Id</th><td>"+productId+"</td></tr><tr><th>Price</th><td>"+currFormat.format(price)+"</td></tr><tr><th>Description</th><td>"+desc+"</td></tr>");
}

// TODO: If there is a productImageURL, display using IMG tag
if (Integer.parseInt(productId) < 30) 
    out.print("<img src='img/Capture"+productId+".PNG'>");

out.print("</table>");	
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
out.print("<h3><a href='addcart.jsp?id="+productId+"&name="+name+"&price="+price+"'>Add to Cart</a></h3>");
out.print("<h3><a href='listprod.jsp'>Continue Shopping</a>");
con.close();
} catch (SQLException e) {
    out.println(e);
}
%>

</body>
</html>

