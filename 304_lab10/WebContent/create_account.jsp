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
<title>account</title>
</head>
<body>
        
<%@ include file="jdbc.jsp" %>

<form method="get" action="listprod.jsp">
<input type="text" name="firstName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> 

<%
String Firstname = request.getParameter("firstName");
//String userName = (String) session.getAttribute("authenticatedUser");
try ( Connection con = DriverManager.getConnection(url, uid, pw); ){
	String sql = "INSERT INTO customer "+
	"(firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) "+
	"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
	PreparedStatement pstmt = con.prepareStatement(sql);
	String first_name = request.getParameter("id");
	pstmt.setString(1, userName.substring)
	ResultSet rst = pstmt.executeUpdate();
	boolean valid = false;
	
} catch (SQLException e) {
	out.print(e);
}

%>
<
