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
    </style>
</head>
<body>
    <header>
        <h1>Welcome to BuyMe</h1>
        <p>Your Online Marketplace</p>
    </header>

    <nav id="main-nav">
        <a href="#">Home</a>
        <a href="#">My Bids</a>
        <a href="#">My Auctions</a>
        <a href="#">Interested Items</a>
        <a href="#">My Account</a>
        <a href="#">Log Out</a>
    </nav>

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
                    "SELECT v.make, v.model, u.username " +
                    "FROM vehicles v " +
                    "JOIN auctions a ON v.VIN = a.VIN " +
                    "JOIN users u ON a.username = u.username " +
                    "WHERE v.type = 'car' " +
                    "ORDER BY a.close_time DESC " +
                    "LIMIT 6"
                );
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String make = rs.getString("make");
                    String model = rs.getString("model");
                    String username = rs.getString("username");
        %>
                    <div class="auction-box">
                        <p>Make: <%= make %></p>
                        <p>Model: <%= model %></p>
                        <p>Posted By: <%= username %></p>
                        <button onclick="viewAuction('<%= make %>', '<%= model %>', '<%= username %>')">View</button>
                    </div>
        <%
                }
                rs.close();
                stmt.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </div>

    <script>
        function viewAuction(make, model, username) {
            // Implement logic to navigate to the specific auction page based on the parameters
            // For example:
            window.location.href = 'viewAuction.jsp?make=' + make + '&model=' + model + '&username=' + username;
        }
    </script>
</body>
</html>
