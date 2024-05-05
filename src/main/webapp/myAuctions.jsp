<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Auctions</title>
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
        button, .add-button {
            display: block;
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
        button.green, .add-button.green {
            background-color: #28a745;
        }
        button.green:hover, .add-button.green:hover {
            background-color: #218838;
        }
        .add-button {
            position: fixed;
            top: 20px;
            right: 20px;
            width: auto;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>My Auctions</h1>

    <!-- Add Auction Button -->
    <button class="add-button green" onclick="window.location.href='PostAuction.jsp'">+ Add New Auction</button>

    <h2>Completed Auctions</h2>
    <table>
        <thead>
        <tr>
            <th>Make</th>
            <th>Model</th>
            <th>Year</th>
            <th>Highest Bid</th>
            <th>Close Time</th>
        </tr>
        </thead>
        <tbody>
            <%
                try {
                	String userID = (String) session.getAttribute("user");
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");
                    PreparedStatement pastAuctions = con.prepareStatement("SELECT v.make, v.model, v.year, a.highest_bid, a.close_time FROM auctions a, vehicles v WHERE a.VIN = v.VIN AND a.close_time < NOW() AND a.seller = '"+ userID+"'");
                    ResultSet pastResults = pastAuctions.executeQuery();
                    while (pastResults.next()) {
                        String make = pastResults.getString("make");
                        String model = pastResults.getString("model");
                        int year = pastResults.getInt("year");
                        float highestBid = pastResults.getFloat("highest_bid");
                        Timestamp closeTime = pastResults.getTimestamp("close_time");
            %>
            <tr>
                <td><%= make %></td>
                <td><%= model %></td>
                <td><%= year %></td>
                <td><%= highestBid %></td>
                <td><%= closeTime %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </tbody>
    </table>

    <h2>Ongoing Auctions</h2>
    <table>
        <thead>
        <tr>
            <th>Make</th>
            <th>Model</th>
            <th>Year</th>
            <th>Highest Bid</th>
            <th>Close Time</th>
        </tr>
        </thead>
        <tbody>
            <%
                try {
                	String userID = (String) session.getAttribute("user");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                    PreparedStatement ongoingAuctions = con.prepareStatement("SELECT v.make, v.model, v.year, a.highest_bid, a.close_time FROM auctions a, vehicles v WHERE a.VIN = v.VIN AND a.close_time > NOW() AND a.seller = '"+ userID+"'");
                    ResultSet ongoingResults = ongoingAuctions.executeQuery();
                    while (ongoingResults.next()) {
                        String make = ongoingResults.getString("make");
                        String model = ongoingResults.getString("model");
                        int year = ongoingResults.getInt("year");
                        float highestBid = ongoingResults.getFloat("highest_bid");
                        Timestamp closeTime = ongoingResults.getTimestamp("close_time");
            %>
            <tr>
                <td><%= make %></td
                <td><%= model %></td>
                <td><%= year %></td>
                <td><%= highestBid %></td>
                <td><%= closeTime %></td>
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
