<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BuyMe - Your Online Marketplace</title>
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
        
        
        .alert {
            padding: 15px;
            background-color: #007bff; /* Bootstrap primary blue */
            color: white;
            margin-bottom: 20px;
            border-radius: 4px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            position: relative;
            transition: all 0.3s ease-in-out;
        }

        .alert button {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background-color: #ff4757; /* Bright red */
            color: white;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            outline: none;
            transition: background-color 0.3s ease-in-out;
        }

        .alert button:hover {
            background-color: #e84118; /* Darker red */
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome to BuyMe</h1>
        <p>Your Online Marketplace</p>
    </header>


   <nav id="main-nav">
		<a href="BuyMe.jsp">Home</a> 
		<a href="myBids.jsp">My Bids</a> 
		<a href="myAuctions.jsp">My Auctions</a> 
		<a href="InterestedAuctions.jsp">Interested Items</a> 
		<a href="help.jsp">Help</a>
		<a href="logout.jsp">Log Out</a>
	</nav>
	    <script>
        function dismissAlert(auctionID) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "DismissAlert.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    document.getElementById('alert-' + auctionID).style.display = 'none';
                }
            };
            xhr.send("auctionID=" + auctionID);
        }
    </script>
</head>
<body>
    <%-- Include Alerts Here --%>
    <%
            try {
            	String userID = (String) session.getAttribute("user");

                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                String query = "SELECT a.auctionID, v.make, v.model FROM auctions a " +
                               "JOIN vehicles v ON a.VIN = v.VIN " +
                               "JOIN interested_items i ON v.make = i.make AND v.model = i.model " +
                               "LEFT JOIN dismissed_alerts d ON a.auctionID = d.auctionID AND d.username = ? " +
                               "WHERE i.username = ? AND a.close_time > NOW() AND d.auctionID IS NULL " +
                               "ORDER BY a.close_time ASC " +
                               "LIMIT 1";

                PreparedStatement stmt = con.prepareStatement(query);
                stmt.setString(1, userID);
                stmt.setString(2, userID);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int auctionID = rs.getInt("auctionID");
                    String make = rs.getString("make");
                    String model = rs.getString("model");
    %>
                    <div id="alert-<%= auctionID %>" class="alert">
                        New auction for <%= make %> <%= model %>! Auction ID: <%= auctionID %>
                        <button onclick="dismissAlert(<%= auctionID %>)">Dismiss</button>
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

    <div class="search-container">
        <h2>Get them before they are gone!</h2>
        <form class="search-form" action="searchResults.jsp" method="GET">
            <select name="make" id="make">
                <option value="">Select Make</option>
                <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT DISTINCT make FROM vehicles ORDER BY make");

                        while (rs.next()) {
                            String make = rs.getString("make");
                %>
                            <option value="<%= make %>"><%= make %></option>
                <%
                        }
                        rs.close();
                        stmt.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>

            <select name="model" id="model">
                <option value="">Select Model</option>
                <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT DISTINCT model FROM vehicles ORDER BY model");

                        while (rs.next()) {
                            String model = rs.getString("model");
                %>
                            <option value="<%= model %>"><%= model %></option>
                <%
                        }
                        rs.close();
                        stmt.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>

            <input type="submit" value="Search">
        </form>
    </div>

<div class="auctions-container">
    <% 
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
            PreparedStatement stmt = con.prepareStatement(
                "SELECT v.make, v.model, v.year, u.username, a.auctionID, a.close_time, IFNULL(a.highest_bid, a.initial_price) AS display_price " +
                "FROM vehicles v " +
                "JOIN auctions a ON v.VIN = a.VIN " +
                "JOIN users u ON a.seller = u.username " +
                "WHERE v.type = ? AND a.close_time > NOW() " + // Change the type condition as needed
                "ORDER BY a.close_time DESC " +
                "LIMIT 6"
            );
            stmt.setString(1, "car"); // Set the vehicle type dynamically based on your requirement

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String make = rs.getString("make");
                String model = rs.getString("model");
                String year = rs.getString("year");
                String username = rs.getString("username");
                String auctionID = rs.getString("auctionID");
                String closeTime = rs.getString("close_time");
                String displayPrice = rs.getString("display_price");

                // Render the auction box with additional details
        %>
                <div class="auction-box">
                    <p>Make: <%= make %></p>
                    <p>Model: <%= model %></p>
                    <p>Year: <%= year %></p>
                    <p>Posted By: <%= username %></p>
                    <p>Ends: <%= closeTime %></p>
                    <p>Price: <%= displayPrice %></p>
                    <button onclick="viewAuction('<%= auctionID %>')">View</button>
                </div>
        <%
            }
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            out.println("An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    %>
</div>

<script>
    // JavaScript function to redirect to auction details page
    function viewAuction(auctionID) {
        window.location.href = 'auctionItemPage.jsp?auctionID=' + auctionID;
    }
</script>
</body>
</html>
