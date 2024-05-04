<%@ page import ="java.sql.*" %>
<%
String userid = request.getParameter("username");
String pwd = request.getParameter("new-password");

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");

if (userid.equals("") || pwd.equals("")) { // empty username/password
    out.println("Empty username and/or password. <a href='update_user_password.jsp'>Try again</a>");
} else {
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM users WHERE username='" + userid + "' AND account_type='user'");
    if (rs.next()) { // username exists
        Statement st2 = con.createStatement();
        String updateQuery = "UPDATE users SET password = '" + pwd + "' WHERE username = '" + userid + "'";
        st2.executeUpdate(updateQuery);
        out.println("Password updated successfully for user: " + userid);
        out.println("<a href='customer_rep.jsp'>Customer Representative Home</a>");
    } else {
        out.println("User does not exist. <a href='update_user_password.jsp'>Try again</a>");
    }
}
%>
