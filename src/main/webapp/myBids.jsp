<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Bids</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        button {
            display: block;
            width: 100%;
            margin-bottom: 10px;
            padding: 12px;
            border: none;
            background-color: #007bff;
            color: #fff;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button.green {
            background-color: #28a745;
        }
        button.green:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>My Bids</h1>

    <h2>Past Bids</h2>
    <table>
        <thead>
        <tr>
            <th>Make</th>
            <th>Model</th>
            <th>Year</th>
            <th>My Bid</th>
            <th>Bid Time</th>
            <th>Highest Bid</th>
        </tr>
        </thead>
        <tbody>
            <%
                try {
                	String userID = (String) session.getAttribute("user");
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");
                    PreparedStatement pastBids = con.prepareStatement("SELECT v.make, v.model, v.year, b.amount, b.time, a.highest_bid FROM bids b, vehicles v, auctions a WHERE b.auctionID = a.auctionID AND a.VIN = v.VIN AND a.close_time < NOW() AND b.username = '"+ userID+"'");
                    ResultSet pastResults = pastBids.executeQuery();
                    while (pastResults.next()) {
                        String make = pastResults.getString("make");
                        String model = pastResults.getString("model");
                        int year = pastResults.getInt("year");
                        float myBid = pastResults.getFloat("amount");
                        Timestamp bidTime = pastResults.getTimestamp("time");
                        float highestBid = pastResults.getFloat("highest_bid");
            %>
            <tr>
                <td><%= make %></td>
                <td><%= model %></td>
                <td><%= year %></td>
                <td><%= myBid %></td>
                <td><%= bidTime %></td>
                <td><%= highestBid %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </tbody>
    </table>

    <h2>Ongoing Bids</h2>
    <table>
        <thead>
        <tr>
            <th>Make</th>
            <th>Model</th>
            <th>Year</th>
            <th>My Bid</th>
            <th>Bid Time</th>
            <th>Highest Bid</th>
        </tr>
        </thead>
        <tbody>
            <%
                try {
                	String userID = (String) session.getAttribute("user");
                	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");
                    PreparedStatement ongoingBids = con.prepareStatement("SELECT v.make, v.model, v.year, b.amount, b.time, a.highest_bid FROM bids b, vehicles v, auctions a WHERE b.auctionID = a.auctionID AND a.VIN = v.VIN AND a.close_time > NOW() AND b.username = '"+ userID+"'");
                    ResultSet ongoingResults = ongoingBids.executeQuery();
                    while (ongoingResults.next()) {
                        String make = ongoingResults.getString("make");
                        String model = ongoingResults.getString("model");
                        int year = ongoingResults.getInt("year");
                        float myBid = ongoingResults.getFloat("amount");
                        Timestamp bidTime = ongoingResults.getTimestamp("time");
                        float highestBid = ongoingResults.getFloat("highest_bid");
            %>
            <tr>
                <td><%= make %></td>
                <td><%= model %></td>
                <td><%= year %></td>
                <td><%= myBid %></td>
                <td><%= bidTime %></td>
                <td><%= highestBid %></td>
            </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </tbody>
    </table>
    <br>
    <a href='logout.jsp'>Log out</a>
    <br><br>
    <button class="green" onclick="window.location.href='BuyMe.jsp'">Back</button>
</div>
</body>
</html>
