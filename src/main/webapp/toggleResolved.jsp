<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.Math" %>
<%
String username = request.getParameter("username");
boolean resolved = Boolean.parseBoolean(request.getParameter("resolved"));
Timestamp time = Timestamp.valueOf(request.getParameter("time"));
String problem = request.getParameter("problem");
String message;

// Update the resolved status
try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");

    PreparedStatement updateResolved = con.prepareStatement("UPDATE help_requests SET resolved = ? WHERE username = ? AND time = ?");
    updateResolved.setBoolean(1, !resolved);
    updateResolved.setString(2, username);
    updateResolved.setTimestamp(3, time);
    int rowsUpdated = updateResolved.executeUpdate();

    if (rowsUpdated > 0) {
    	if (resolved) {
    	    // If the request was resolved, set the message as unresolved
    	    message = "Your help request \"" + problem.substring(0, Math.min(problem.length(), 50)) + "...\" has been marked as unresolved.";
    	} else {
    	    // If the request was unresolved, set the message as resolved
    	    message = "Your help request \"" + problem.substring(0, Math.min(problem.length(), 50)) + "...\" has been marked as resolved.";
    	}

        
        // Insert message into alert_inbox table
        PreparedStatement insertAlert = con.prepareStatement("INSERT INTO alert_inbox (username, time, message) VALUES (?, ?, ?)");
        insertAlert.setString(1, username);
        insertAlert.setTimestamp(2, time);
        insertAlert.setString(3, message);
        insertAlert.executeUpdate();
        
        response.sendRedirect("reply_customer.jsp");
    } else {
        out.println("Failed to update resolved status.");
    }

    con.close();
} catch (Exception e) {
    out.println(e);
}
%>
