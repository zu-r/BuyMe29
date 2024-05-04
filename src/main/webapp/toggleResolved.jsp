<%@ page import="java.sql.*" %>
<%@ page import="java.io.*, java.util.*" %>

<%
    // Get parameters from the request
    String username = request.getParameter("username");
    boolean resolved = Boolean.parseBoolean(request.getParameter("resolved"));
    String time = request.getParameter("time");

    // Update the resolved status in the database
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
        
        // Toggle the resolved status
        resolved = !resolved;
        
        // Update the database
        PreparedStatement updateStatement = con.prepareStatement("UPDATE help_requests SET resolved = ? WHERE username = ? and time = ?");
        updateStatement.setBoolean(1, resolved);
        updateStatement.setString(2, username);
        updateStatement.setString(3, time);
        updateStatement.executeUpdate();
        
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- Redirect back to the current page to refresh -->
<%
    String redirectURL = request.getHeader("Referer");
    response.sendRedirect(redirectURL);
%>
