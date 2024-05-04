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
            background-color: #f8f9fa; /* Set a light background color for the body */
            padding: 20px; /* Add some padding to the body */
        }
        .title {
            text-align: center;
            margin-bottom: 20px;
        }
        .auctions-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
        }
        .auction-box {
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            width: 45%; /* Adjust the width of the auction box */
            background-color: #ffffff; /* White background for the auction box */
            margin-bottom: 20px; /* Added margin for spacing */
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
        
    </style>
</head>
<body>



<nav id="main-nav">
        <a href="#">Home</a>
        <a href="#">My Bids</a>
        <a href="#">My Auctions</a>
        <a href="#">Interested Items</a>
        <a href="#">My Account</a>
        <a href="#">Log Out</a>
    </nav>
    
    
    

    <div class="auctions-container">
        <% 
            // Retrieve parameters from the URL
            String make = request.getParameter("make");
            String model = request.getParameter("model");

            if (make != null && model != null) {
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");

                    // Use PreparedStatement with parameterized query
                    PreparedStatement stmt = con.prepareStatement(
                        "SELECT v.make, v.model, u.username, a.auctionID " +
                        "FROM vehicles v " +
                        "JOIN auctions a ON v.VIN = a.VIN " +
                        "JOIN users u ON a.seller = u.username " +
                        "WHERE v.make = ? AND v.model = ? " +
                        "ORDER BY a.close_time DESC"
                    );
                    stmt.setString(1, make);
                    stmt.setString(2, model);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        String resultMake = rs.getString("make");
                        String resultModel = rs.getString("model");
                        String username = rs.getString("username");
                        String auctionID = rs.getString("auctionID");
                        %>
                        <div class="auction-box">
                            <p>Make: <%= make %></p>
                            <p>Model: <%= model %></p>
                            <p>Posted By: <%= username %></p>
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
            } else {
                out.println("Invalid parameters. Please provide make and model.");
            }
        %>
    </div>

    <script>
	    function viewAuction(auctionID) {
	        window.location.href = 'auctionItemPage.jsp?auctionID=' + auctionID;
	    }
    </script>
</body>
</html>
