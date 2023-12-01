<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	
    try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{
	// TODO: Get order id
	String orderId = request.getParameter("orderId");
	// TODO: Check if valid order id in database
	String sql = "select orderId from ordersummary";
	PreparedStatement pstmt = con.prepareStatement(sql);
	ResultSet rst = pstmt.executeQuery();
	boolean valid = false;
	while (rst.next()) {
		if (rst.getInt(1) == Integer.parseInt(orderId)) {
			valid = true;
			break; }
	}
	if (!valid) {
		out.print("<h1>Error, not a valid orderId</h1>");
	} else {

	// TODO: Start a transaction (turn-off auto-commit)
	con.setAutoCommit(false);
	// TODO: Retrieve all items in order with given id
	String sql2 = "select productId, quantity from orderproduct where orderId = ?";
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
	pstmt2.setInt(1, Integer.parseInt(orderId));
	ResultSet rst2 = pstmt2.executeQuery();
	con.commit();
	// TODO: Create a new shipment record.
	String sql3 = "insert into shipment (warehouseId) values (1)";
	PreparedStatement pstmt3 = con.prepareStatement(sql3);
	pstmt3.executeUpdate();
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	String sql4 = "select productId, quantity from productinventory where warehouseId = 1 and productId = ?";
	PreparedStatement pstmt4 = con.prepareStatement(sql4);
	int[] oldinv = new int[5];
	int[] newinv = new int[5];
	int count = 0;
	while (rst2.next()) {
		pstmt4.setInt(1, rst2.getInt(1));
		ResultSet rst4 = pstmt4.executeQuery();
		while (rst4.next()) {
			if (rst4.getInt(2) < rst2.getInt(2))
				valid = false;
			else {
				oldinv[count] = rst4.getInt(2);
				newinv[count] = rst4.getInt(2) - rst2.getInt(2);
				out.print("<h3>Ordered product: " + rst2.getInt(1) + " Qty: " + rst2.getInt(2) + " Previous inventory: " + rst4.getInt(2) + " New inventory: " + newinv[count]);
			}
		}
		if (!valid)
			break;
		count++;
	}

	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	if (!valid) {
		con.rollback();
		out.print("<h1>Error, not sufficient inventory</h1>");
	}
	else {
		con.commit();
		out.print("<h1>Shipment successfully processed!</h1>");
	}
	
	// TODO: Auto-commit should be turned back on
	con.setAutoCommit(true);
	}
} catch (SQLException e) {
	out.print(e);
}
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
