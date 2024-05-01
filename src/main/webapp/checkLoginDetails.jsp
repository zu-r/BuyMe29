<%@ page import ="java.sql.*" %>
<%
String userid = request.getParameter("username");
String pwd = request.getParameter("password");

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");

Statement st = con.createStatement();

ResultSet rs;
rs = st.executeQuery("select * from users where username='" + userid + "' and password='" + pwd + "'");

Statement st1 = con.createStatement();

ResultSet rs1;
rs1 = st1.executeQuery("select * from users where username='" + userid + "'");

if (rs1.next()){ // username exists
	if (rs.next()) {
		if (userid.equals("admin")){
			response.sendRedirect("admin.jsp");
		}else if (rs1.getString("account_type").equals("customer_rep")) {
			session.setAttribute("user", userid); // the username will be stored in the session
            out.println("Welcome Representative " + userid);
            out.println("<a href='logout.jsp'>Log out</a>");
            response.sendRedirect("customer_rep.jsp");
		}else {
			session.setAttribute("user", userid); // the username will be stored in the session
			out.println("welcome " + userid);
			out.println("<a href='logout.jsp'>Log out</a>");
			response.sendRedirect("success.jsp");
		}
	} else {
		out.println("Invalid password <a href='login.jsp'>try again</a>");
	}
} else {
	out.println("User does not exist <a href='login.jsp'>try again</a>");
}


%>
