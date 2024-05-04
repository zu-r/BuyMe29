<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Interested Auctions</title>
        <style>
        /* Reset some default styles */
        body, h1, h2, h3, p, ul, li {
            margin: 0;
            padding: 0;
        }
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            background-color: #f8f9fa; /* Set a light background color for the body */
            padding: 20px; /* Add some padding to the body */
        }
        header {
            text-align: center;
            margin-bottom: 20px;
        }
        nav {
            background-color: #333;
            color: #fff;
            padding: 10px 0;
            text-align: center;
            margin-bottom: 20px;
        }
        nav a {
            text-decoration: none;
            color: #fff;
            padding: 10px 20px;
        }
        nav a:hover {
            background-color: #555;
        }
        .search-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .search-form {
            display: inline-block;
            margin-bottom: 20px;
        }
        .search-input {
            width: 200px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 0;
            outline: none;
        }
        .auctions-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .auction-box {
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            width: 100%;
            background-color: #f9f9f9;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .auction-box p {
            margin-bottom: 10px;
        }
        .auction-box button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .auction-box button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <header>
        <h1>Interested Auctions</h1>
        <p>Shopping for vehicles made easy!</p>
    </header>
</head>
<body>
<form action="InterestedAuctions.jsp" method="get">
    Make: <input type="text" name="make" value="<%= request.getParameter("make") != null ? request.getParameter("make") : "" %>" />
    Model: <input type="text" name="model" value="<%= request.getParameter("model") != null ? request.getParameter("model") : "" %>" />
    Year: <input type="number" name="year" value="<%= request.getParameter("year") != null ? request.getParameter("year") : "" %>" />
    <input type="submit" value="Search" />
</form>
<%
    String make = request.getParameter("make");
    String model = request.getParameter("model");
    String year = request.getParameter("year");
    List<Map<String, Object>> auctions = new ArrayList<>();
    try {
    	Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "Sansar12345$");
        String query = "SELECT * FROM auctions WHERE 1=1";
        if (make != null && !make.isEmpty()) {
            query += " AND make LIKE ?";
        }
        if (model != null && !model.isEmpty()) {
            query += " AND model LIKE ?";
        }
        if (year != null && !year.isEmpty()) {
            query += " AND year = ?";
        }
        PreparedStatement ps = conn.prepareStatement(query);
        int index = 1;
        if (make != null && !make.isEmpty()) {
            ps.setString(index++, "%" + make + "%");
        }
        if (model != null && !model.isEmpty()) {
            ps.setString(index++, "%" + model + "%");
        }
        if (year != null && !year.isEmpty()) {
            ps.setInt(index, Integer.parseInt(year));
        }
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> auction = new HashMap<>();
            auction.put("auctionId", rs.getInt("auctionID"));
            auction.put("make", rs.getString("make"));
            auction.put("model", rs.getString("model"));
            auction.put("year", rs.getInt("year"));
            auction.put("currentBid", rs.getDouble("currentBid"));
            auction.put("end", rs.getTimestamp("auction_end").toString());
            auctions.add(auction);
        }
        rs.close();
        ps.close();
        conn.close();
    } catch (SQLException e) {
        out.println("Database connection problem: " + e.getMessage());
        e.printStackTrace();
    }
%>
<table border="1">
    <tr>
        <th>Make</th>
        <th>Model</th>
        <th>Year</th>
        <th>Current Bid</th>
        <th>End Time</th>
    </tr>
    <% for (Map<String, Object> auction : auctions) { %>
    <tr>
        <td><a href="auctionPage.jsp?auctionId=<%=auction.get("auctionId")%>"><%=auction.get("make")%></a></td>
        <td><%=auction.get("model")%></td>
        <td><%=auction.get("year")%></td>
        <td><%=auction.get("currentBid")%></td>
        <td><%=auction.get("end")%></td>
    </tr>
    <% } %>
</table>
</body>
</html>

