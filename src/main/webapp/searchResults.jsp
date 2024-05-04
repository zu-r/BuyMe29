<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            background-color: #f8f9fa;
            padding: 20px;
        }
        /* Styles for containers, boxes, buttons, and navigation */
        .auctions-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
        }
        .auction-box {
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            width: 45%;
            background-color: #ffffff;
            margin-bottom: 20px;
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
        header {
            text-align: center;
            margin-bottom: 20px;
        }
        .filter-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .filter-container form {
            display: inline-block;
        }
    </style>
</head>
<body>

<header>
    <h1>Search Results</h1>
</header>

<nav>
    <a href="BuyMe.jsp">Home</a>
    <a href="myBids.jsp">My Bids</a>
    <a href="myAuctions.jsp">My Auctions</a>
    <a href="InterestedAuctions.jsp">Interested Items</a>
    <a href="logout.jsp">Log Out</a>
</nav>

<div class="filter-container">
    <!-- Filter form with inputs -->
    <form action="searchResults.jsp" method="GET">
        <label>Make:</label>
        <select name="make">
            <option value="">Any</option>
            <%-- Populate dropdown with available makes --%>
            <% 
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT DISTINCT make FROM vehicles");
                    while (rs.next()) {
            %>
                <option value="<%= rs.getString("make") %>"><%= rs.getString("make") %></option>
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
        </select>
        
        <label>Model:</label>
        <select name="model">
            <option value="">Any</option>
            <%-- Populate dropdown with available models --%>
            <% 
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT DISTINCT model FROM vehicles");
                    while (rs.next()) {
            %>
                <option value="<%= rs.getString("model") %>"><%= rs.getString("model") %></option>
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
        </select>
        
        <label>Year:</label>
        <input type="text" name="year">
        
        <label>Price Sort:</label>
        <select name="sort">
            <option value="asc">Ascending</option>
            <option value="desc">Descending</option>
        </select>
        
        <input type="submit" value="Apply Filters">
    </form>
</div>

<div class="auctions-container">
    <% 
        // Retrieve parameters from the URL
        String make = request.getParameter("make");
        String model = request.getParameter("model");
        String year = request.getParameter("year");
        String sort = request.getParameter("sort");

        // Define default sorting order (ascending)
        String sortOrder = "ASC";
        if (sort != null && sort.equalsIgnoreCase("desc")) {
            sortOrder = "DESC";
        }

       
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
            PreparedStatement stmt = con.prepareStatement(
                "SELECT v.make, v.model, u.username, a.auctionID, a.close_time, IFNULL(a.highest_bid, a.initial_price) AS display_price " +
                "FROM vehicles v " +
                "JOIN auctions a ON v.VIN = a.VIN " +
                "JOIN users u ON a.seller = u.username " +
                "WHERE (v.make = ? OR ? IS NULL OR ? = '') " +
                "  AND (v.model = ? OR ? IS NULL OR ? = '') " +
                "  AND (v.year = ? OR ? IS NULL OR ? = '') " +
                "ORDER BY display_price " + sortOrder
            );
            stmt.setString(1, make);
            stmt.setString(2, make);
            stmt.setString(3, make);
            stmt.setString(4, model);
            stmt.setString(5, model);
            stmt.setString(6, model);
            stmt.setString(7, year);
            stmt.setString(8, year);
            stmt.setString(9, year);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String resultMake = rs.getString("make");
                String resultModel = rs.getString("model");
                String username = rs.getString("username");
                String auctionID = rs.getString("auctionID");
                String closeTime = rs.getString("close_time");
                String displayPrice = rs.getString("display_price"); // Use display_price instead of highest_bid

                // Use displayPrice for rendering in the JSP
        %>
                <div class="auction-box">
                    <p>Make: <%= resultMake %></p>
                    <p>Model: <%= resultModel %></p>
                    <p>Posted By: <%= username %></p>
                    <p>Price: <%= displayPrice %></p>
                    <p>Ends: <%= closeTime %></p>
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
