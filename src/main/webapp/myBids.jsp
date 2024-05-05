<%@ page import="java.sql.*" %>
<%
String selectedUserId = request.getParameter("userSelect");

// Establish database connection
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");

// Fetch past bids based on the selected user's ID or the current user's ID if no selection is made
String userID = (selectedUserId != null && !selectedUserId.isEmpty()) ? selectedUserId : (String) session.getAttribute("user");
PreparedStatement pastBids = con.prepareStatement("SELECT v.make, v.model, v.year, b.amount, b.time, a.highest_bid FROM bids b, vehicles v, auctions a WHERE b.auctionID = a.auctionID AND a.VIN = v.VIN AND a.close_time < NOW() AND b.username = ?");
pastBids.setString(1, userID);
ResultSet pastResults = pastBids.executeQuery();

// Fetch ongoing bids based on the selected user's ID or the current user's ID if no selection is made
PreparedStatement ongoingBids = con.prepareStatement("SELECT v.make, v.model, v.year, b.amount, b.time, a.highest_bid FROM bids b, vehicles v, auctions a WHERE b.auctionID = a.auctionID AND a.VIN = v.VIN AND a.close_time > NOW() AND b.username = ?");
ongoingBids.setString(1, userID);
ResultSet ongoingResults = ongoingBids.executeQuery();
%>
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

    <!-- Dropdown for selecting users -->
    <form action="myBids.jsp" method="get">
        <select name="userSelect">
            <option value="<%= (String) session.getAttribute("user") %>">My Bids</option>
            <% 
                try {
                    // Fetch all users
                    PreparedStatement getUsers = con.prepareStatement("SELECT username FROM users WHERE account_type = 'user' AND username <> ?");
                    getUsers.setString(1, (String) session.getAttribute("user"));
                    ResultSet users = getUsers.executeQuery();
                    while(users.next()) {
                        userID = users.getString("username");
            %>
            <option value="<%= userID %>" <%= (selectedUserId != null && selectedUserId.equals(userID)) ? "selected" : "" %>><%= userID %></option>
            <%
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <button type="submit">Search</button>
    </form>

    <!-- Past Bids Table -->
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
            <% while (pastResults.next()) { %>
                <tr>
                    <td><%= pastResults.getString("make") %></td>
                    <td><%= pastResults.getString("model") %></td>
                    <td><%= pastResults.getInt("year") %></td>
                    <td><%= pastResults.getFloat("amount") %></td>
                    <td><%= pastResults.getTimestamp("time") %></td>
                    <td><%= pastResults.getFloat("highest_bid") %></td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <!-- Ongoing Bids Table -->
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
            <% while (ongoingResults.next()) { %>
                <tr>
                    <td><%= ongoingResults.getString("make") %></td>
                    <td><%= ongoingResults.getString("model") %></td>
                    <td><%= ongoingResults.getInt("year") %></td>
                    <td><%= ongoingResults.getFloat("amount") %></td>
                    <td><%= ongoingResults.getTimestamp("time") %></td>
                    <td><%= ongoingResults.getFloat("highest_bid") %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
    <br>
    <a href='logout.jsp'>Log out</a>
    <br><br>
    <button class="green" onclick="window.location.href='BuyMe.jsp'">Back</button>
</div>
</body>
</html>
