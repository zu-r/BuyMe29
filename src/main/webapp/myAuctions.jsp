<%@ page import="java.sql.*" %>
<%
String selectedUserId = request.getParameter("userSelect");

// Establish database connection
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");

// Fetch auctions based on the selected user's ID or the current user's ID if no selection is made
String userID = (selectedUserId != null && !selectedUserId.isEmpty()) ? selectedUserId : (String) session.getAttribute("user");
PreparedStatement pastAuctions = con.prepareStatement("SELECT v.make, v.model, v.year, a.highest_bid, a.close_time FROM auctions a, vehicles v WHERE a.VIN = v.VIN AND a.close_time < NOW() AND a.seller = ?");
pastAuctions.setString(1, userID);
ResultSet pastResults = pastAuctions.executeQuery();

// Fetch ongoing auctions based on the selected user's ID or the current user's ID if no selection is made
PreparedStatement ongoingAuctions = con.prepareStatement("SELECT v.make, v.model, v.year, a.highest_bid, a.close_time FROM auctions a, vehicles v WHERE a.VIN = v.VIN AND a.close_time > NOW() AND a.seller = ?");
ongoingAuctions.setString(1, userID);
ResultSet ongoingResults = ongoingAuctions.executeQuery();
%><%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Auctions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            width: 800px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        button {
            padding: 12px;
            border: none;
            background-color: #007bff;
            color: #fff;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 10px;
        }
        button.green {
            background-color: #28a745;
        }
        button:hover {
            background-color: #0056b3;
        }
        select, button[type="submit"] {
            padding: 10px;
            font-size: 16px;
            border-radius: 4px;
            margin-right: 10px;
        }
        .add-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .logout {
            margin-top: 20px;
            text-align: center;
        }
        .back-button {
            display: block;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>My Auctions</h1>
    
    <!-- Add new auction button and user selection -->
    <div class="add-section">
        <button class="add-button green" onclick="window.location.href='PostAuction.jsp'">+ Add New Auction</button>
        <form action="myAuctions.jsp" method="get">
            <select name="userSelect">
                <option value="<%= (String) session.getAttribute("user") %>">My Auctions</option>
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
    </div>

    <!-- Completed Auctions Table -->
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
            <% while (pastResults.next()) { %>
                <tr>
                    <td><%= pastResults.getString("make") %></td>
                    <td><%= pastResults.getString("model") %></td>
                    <td><%= pastResults.getInt("year") %></td>
                    <td>$<%= pastResults.getFloat("highest_bid") %></td>
                    <td><%= pastResults.getTimestamp("close_time") %></td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <!-- Ongoing Auctions Table -->
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
            <% while (ongoingResults.next()) { %>
                <tr>
                    <td><%= ongoingResults.getString("make") %></td>
                    <td><%= ongoingResults.getString("model") %></td>
                    <td><%= ongoingResults.getInt("year") %></td>
                    <td>$<%= ongoingResults.getFloat("highest_bid") %></td>
                    <td><%= ongoingResults.getTimestamp("close_time") %></td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <!-- Logout and Back buttons -->
    <div class="logout">
        <a href='logout.jsp'>Log out</a>
    </div>
    <div class="back-button">
        <button class="green" onclick="window.location.href='BuyMe.jsp'">Back</button>
    </div>
</div>
</body>
</html>
