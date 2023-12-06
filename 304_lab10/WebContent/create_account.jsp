<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>account</title>
</head>
<body>

<h3 align="left">Enter your first name</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="firstName" size="40">

<h3 align="left">Enter your last name</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="lastName" size="40">

<h3 align="left">Enter your email</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="email" size="50">

<h3 align="left">Enter your phone number</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="phonenum" size="20">

<h3 align="left">Enter your address</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="address" size="50">

<h3 align="left">Enter the city</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="city" size="40">

<h3 align="left">Enter your state</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="state" size="20">

<h3 align="left">Enter your poatal code</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="postalCode" size="20">

<h3 align="left">Enter the country</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="country" size="40">

<h3 align="left">Enter your user ID</h3>
<form method="get" action="create_account.jsp">
<input type="text" name="userid" size="20">

<h3 align="left;;">Enter your password</h3>
<form method="get" action="create_account.jsp">
<input type="password" name="password" size="30">

<br>
<br>
<input type="submit" value="Submit">
<input type="reset" value="Reset"> 

<%
String FirstName = request.getParameter("firstName");
String LastName = request.getParameter("lastName");
String Email = request.getParameter("email");
String Phonenum = request.getParameter("phonenum");
String Address = request.getParameter("address");
String City = request.getParameter("city");
String State = request.getParameter("state");
String PostalCode = request.getParameter("postalCode");
String Country = request.getParameter("country");
String Userid = request.getParameter("userid");
String Password = request.getParameter("password");

//String userName = (String) session.getAttribute("authenticatedUser");
try ( Connection con = DriverManager.getConnection(url, uid, pw); ){
	String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1,FirstName );
	pstmt.setString(2,LastName );
	pstmt.setString(3,Email );
	pstmt.setString(4,Phonenum );
	pstmt.setString(5,Address );
	pstmt.setString(6,City );
	pstmt.setString(7,State );
	pstmt.setString(8,PostalCode );
	pstmt.setString(9,Country );
	pstmt.setString(10,Userid );
	pstmt.setString(11,Password );
	pstmt.executeUpdate();
	boolean valid = false;
	
} catch (SQLException e) {
	out.print(e);
}
if(FirstName!= null){
	response.sendRedirect("login.jsp");	
}
%>

</body>
</html>
