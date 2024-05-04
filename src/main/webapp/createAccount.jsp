<%@ page import ="java.sql.*" %>
<%
String userid = request.getParameter("new username");
String pwd = request.getParameter("new password");



Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "Sansar12345$");





Statement st1 = con.createStatement();

ResultSet rs1;
rs1 = st1.executeQuery("select * from users where username='" + userid + "'");


if (userid.equals("") || pwd.equals("")){ // empty username/password
	
	out.println("Empty username and/or password. <a href='login.jsp'>try again</a>");
			
} else if (rs1.next()){ // username exists{
		
	out.println("Username exists. <a href='login.jsp'>try again</a>");
	
} else {
	
	Statement st2 = con.createStatement();
	
	String str3 = "INSERT INTO users VALUES('" + userid + "','" + pwd + "','user')";
	
	st2.executeUpdate(str3);
	
	out.println("Account created: " + userid);
	out.println("<a href='login.jsp'>Log in</a>");
}


%>
