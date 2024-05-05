<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Alerts</title>
    <style>
        .alert {
            padding: 20px;
            background-color: #f44336; /* Red */
            color: white;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<%
    try {
    	String userID = (String) session.getAttribute("user");
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
        String query = "SELECT a.auctionID, v.make, v.model " +
                       "FROM auctions a " +
                       "JOIN vehicles v ON a.VIN = v.VIN " +
                       "JOIN interested_items i ON v.make = i.make AND v.model = i.model " +
                       "WHERE i.username = ? AND a.close_time > NOW() " +
                       "ORDER BY a.close_time ASC";

        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setString(1, userID);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String make = rs.getString("make");
            String model = rs.getString("model");
            int auctionID = rs.getInt("auctionID");
%>
            <div class="alert">
                New auction for <%= make %> <%= model %>! Auction ID: <%= auctionID %>
            </div>
<%
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("Error retrieving alerts: " + e.getMessage());
        e.printStackTrace();
    }
%>
</body>
</html>
