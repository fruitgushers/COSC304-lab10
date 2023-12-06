<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Forgot Password?</title>
</head>
<body>

<h1>Forgot Password?</h1>
Please input the email associated with your account:
<form method="get" action="forgotPassWord.jsp">
    <input type = "text" name = "email" size = "50">
    <input type = "submit" value = "Submit">
</form>

<%
String email = request.getParameter("email");
String newPassword = request.getParameter("newPassword");
String idString = request.getParameter("id");

try ( Connection con = DriverManager.getConnection(url, uid, pw); )
{
    if (newPassword == null) {
    boolean valid = false;
    String sql = "select email, customerId from customer where email = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, email);
    ResultSet rst = pstmt.executeQuery();
    int tempId = 0;
    while (rst.next()) {
        valid = true;
        tempId = rst.getInt(2);
    }
    if (valid) {
        out.println("<h2>Great, your email is valid! You'll get an email with your password reset form shortly.</h2>");
        out.println("(you wont. please just enter your new password below.)");
        out.println("<form method = 'get' action = 'forgotPassWord.jsp'><input type = 'hidden' name = 'id' value = '"+tempId+"'/><input type = 'text' name ='newPassword' size = '50'><input type = 'submit' value = 'Submit'></form>");
    } else {
        if (email != null)
            out.println("<h2>The email you submitted is not present in our database. Please try again.</h2>");
    }
} else {
    int id = Integer.parseInt(idString);
    String sql2 = "update customer set password = ? where customerId = ?";
    PreparedStatement pstmt2 = con.prepareStatement(sql2);
    pstmt2.setString(1, newPassword);
    pstmt2.setInt(2, id);
    pstmt2.executeUpdate();
    out.println("<h2>Your password has been updated! Click the button below to return to login screen.</h2>");
    out.println("<form method = 'get' action = 'login.jsp'><input type = 'submit' value = 'Go back'></form>");
}
    con.close();
} catch (Exception e) {
    out.print(e);
}

%>

</body>
</html>