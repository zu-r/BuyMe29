<%@ page import="java.sql.*" %>
<%
	String userID = (String) session.getAttribute("user");
    int auctionID = Integer.parseInt(request.getParameter("auctionID"));

    if (userID != null && auctionID > 0) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
            String query = "INSERT INTO dismissed_alerts (username, auctionID) VALUES (?, ?)";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, userID);
            stmt.setInt(2, auctionID);
            stmt.executeUpdate();
            stmt.close();
            con.close();
            response.getWriter().print("Alert dismissed successfully");
        } catch (Exception e) {
            response.getWriter().print("Error dismissing alert: " + e.getMessage());
            e.printStackTrace();
        }
    } else {
        response.getWriter().print("Invalid request");
    }
%>
