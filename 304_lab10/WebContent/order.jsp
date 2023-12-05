<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ include file="jdbc.jsp" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 




// Get customer id
String custId = request.getParameter("customerId");
String password = request.getParameter("password");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");	

// Make connection
try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{
	int count = 0;
	String sql2 = "Select customerId, password from customer";
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
	ResultSet rst2 = pstmt2.executeQuery();
	boolean inDatabase = false;
	boolean valid = true;		
	boolean passwordValid = false;
	for (int i = 0; i < custId.length(); i++)
			if (!Character.isDigit(custId.charAt(i))) {
				valid = false;
				out.println("<H1>Your customer ID is invalid!</H1>");
				break;
			}
 if (valid) {
	while (rst2.next()) {
		
		
		if (rst2.getInt(1) == Integer.parseInt(custId)) {
			inDatabase = true;
			if (rst2.getString(2).equals(password))
				passwordValid = true;
			break;
		}
		
	}


	if (inDatabase == false) {
		out.println("<H1>Your customer ID is not in the database!</H1>");
		valid = false; }
	if (passwordValid == false) {
		out.println("<H1>Your password is incorrect</H1>");
	}

	for (int i = 0; i < custId.length(); i++) {
		if (!Character.isDigit(custId.charAt(i))) {
			out.println("<H1>Your customer ID is invalid!</H1>");
			valid = false; }
	}
	// Determine if valid customer id was entered
	// Determine if there are products in the shopping cart
	// If either are not true, display an error message
	
	if (productList == null) {
		out.println("<H1>Your shopping cart is empty!</H1>");
		valid = false; }
	}
if (valid && passwordValid) {
	count++;
// Save order information to database



	
	// Use retrieval of auto-generated keys.
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	double total = 0;
	


	
	String sql = "insert into ordersummary (orderDate, customerId) values (?, ?)";
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	java.sql.Date date = new java.sql.Date(System.currentTimeMillis());			
	pstmt.setDate(1, date);
	pstmt.setString(2, custId);
	pstmt.executeUpdate();

	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	

// Insert each item into OrderProduct table using OrderId from previous INSERT
String sql3 = "insert into orderproduct values (?, ?, ?, ?)";
PreparedStatement pstmt3 = con.prepareStatement(sql3);
pstmt3.setInt(1, orderId);
while (iterator.hasNext()) {
	
	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
	ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
	Object price = product.get(2);
	Object itemqty = product.get(3);
	String productId = (String) product.get(0);
	double pr = 0;
	int qty = 0;
	pr = Double.parseDouble(price.toString());
	qty = Integer.parseInt(itemqty.toString());
	total = total +pr*qty;

	
	pstmt3.setString(2, productId);
	pstmt3.setInt(3, qty);
	pstmt3.setDouble(4, pr);
	pstmt3.executeUpdate();
}


// Update total amount for order record
String sql4 = "update ordersummary set totalAmount = ? where orderId = ?";
PreparedStatement pstmt4 = con.prepareStatement(sql4);
pstmt4.setDouble(1, total);
pstmt4.setInt(2, orderId);


// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
out.println("<H1>Your Order Summary</H1>");
out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
out.print("<th>Price</th><th>Subtotal</th></tr>");
String sql5 = "select orderproduct.productId, productName, quantity, price from orderproduct join product on orderproduct.productId = product.productId where orderId = ?";
PreparedStatement pstmt5 = con.prepareStatement(sql5);
pstmt5.setInt(1, orderId);
ResultSet rst3 = pstmt5.executeQuery();
while (rst3.next()) {
	out.print("<tr><td>"+rst3.getInt(1)+"</td><td>"+rst3.getString(2)+"</td><td>"+rst3.getInt(3)+"</td><td>"+currFormat.format(rst3.getDouble(4))+"</td><td>"+currFormat.format(rst3.getInt(3)*rst3.getDouble(4))+"</td></tr>");
}
out.print("</table><table style='margin-left:180px'><tr><th>Order Total</th><td>"+currFormat.format(total)+"</td></tr></table>");
out.println("<H1>Order completed. Will be shipped soon!</H1>");
out.println("<H1>Your order reference number is: " + count + "</H1>");

String sql6 = "select firstName, lastName from customer where customerId = ?";
PreparedStatement pstmt6 = con.prepareStatement(sql6);
pstmt6.setInt(1, Integer.parseInt(custId));
ResultSet rst6 = pstmt6.executeQuery();
rst6.next();

out.println("<H1>Shipping to customer: " + custId + " Name: " + rst6.getString(1) + " " + rst6.getString(2));


}
// Clear cart if order placed successfully
} catch (SQLException e) {
	out.println(e);
}
%>
</BODY>
</HTML>

