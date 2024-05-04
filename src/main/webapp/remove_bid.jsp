<%@ page import ="java.sql.*" %>
<%
String selectedAucId = request.getParameter("aucId");

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");

if (selectedAucId != null && !selectedAucId.isEmpty()) {
	// Check the number of bids for the selected auction
    PreparedStatement countBidsStatement = con.prepareStatement("SELECT COUNT(*) AS bid_count FROM bids WHERE auctionID = ?");
    countBidsStatement.setString(1, selectedAucId);
    ResultSet countResult = countBidsStatement.executeQuery();
    countResult.next(); // Move cursor to the first row
    int bidCount = countResult.getInt("bid_count");
    
    
    if (bidCount == 0) {
        // No bids found for the auction
        out.println("<script>alert('No bids found for Auction with ID: " + selectedAucId + ".');</script>");
    } else if (bidCount == 1) {
    	// Only one bid found for the auction
        PreparedStatement updateAuctionsStatement = con.prepareStatement("UPDATE auctions SET highest_bid = NULL, highest_bidder = NULL WHERE auctionID = ?");
        updateAuctionsStatement.setString(1, selectedAucId);
        updateAuctionsStatement.executeUpdate();

        // Delete the single bid from the bids table
        PreparedStatement deleteSingleBidStatement = con.prepareStatement("DELETE FROM bids WHERE auctionID = ?");
        deleteSingleBidStatement.setString(1, selectedAucId);
        int rowsDeleted = deleteSingleBidStatement.executeUpdate();

        if (rowsDeleted > 0) {
            out.println("<script>alert('Single bid in Auction with ID: " + selectedAucId + " deleted successfully.');</script>");
        } else {
            out.println("<script>alert('Failed to delete single bid in Auction with ID: " + selectedAucId + ".');</script>");
        }
    } else {
        try {
            // Find the current highest bid amount for the selected auction
            PreparedStatement findHighestBidStatement = con.prepareStatement("SELECT MAX(amount) AS highest_bid FROM bids WHERE auctionID = ?");
            findHighestBidStatement.setString(1, selectedAucId);
            ResultSet highestBidResultSet = findHighestBidStatement.executeQuery();
            
            // Check if there is a highest bid
            if (highestBidResultSet.next()) {
                float highestBidAmount = highestBidResultSet.getFloat("highest_bid");
                //out.println("Highest Bid Amount: " + highestBidAmount);
                
                // Delete the highest bid from the bids table
                PreparedStatement deleteHighestBidStatement = con.prepareStatement("DELETE FROM bids WHERE auctionID = ? AND amount = ?");
                deleteHighestBidStatement.setString(1, selectedAucId);
                deleteHighestBidStatement.setFloat(2, highestBidAmount);
                deleteHighestBidStatement.executeUpdate();
                
                PreparedStatement findNewHighestBidStatement = con.prepareStatement("SELECT MAX(amount) AS new_highest_bid FROM bids WHERE auctionID = ?");
                findNewHighestBidStatement.setString(1, selectedAucId);
                ResultSet newHighestBidResultSet = findNewHighestBidStatement.executeQuery();
                
                if (newHighestBidResultSet.next()){
                	float newHighestBidAmount = newHighestBidResultSet.getFloat("new_highest_bid");
                
                
	                // Find the new highest bid amount and bidder
	                PreparedStatement findNewHighestBidderStatement = con.prepareStatement("SELECT username FROM bids WHERE amount = ? AND auctionID = ?");
	                findNewHighestBidderStatement.setFloat(1, newHighestBidAmount);
	                findNewHighestBidderStatement.setString(2, selectedAucId);
	                ResultSet newHighestBidderResultSet = findNewHighestBidderStatement.executeQuery();
	                
	                String newHighestBidder = null;
	                if (newHighestBidderResultSet.next()) {
	                    newHighestBidder = newHighestBidderResultSet.getString("username");
	                }
	                
	                //out.println("New Highest Bidder: " + newHighestBidder);
	                
	                // Update the auctions table with the new highest bid amount and bidder
	                PreparedStatement updateAuctionsStatement = con.prepareStatement("UPDATE auctions SET highest_bid = ?, highest_bidder = ? WHERE auctionID = ?");
	                updateAuctionsStatement.setFloat(1, newHighestBidAmount);
	                updateAuctionsStatement.setString(2, newHighestBidder);
	                updateAuctionsStatement.setString(3, selectedAucId);
	                updateAuctionsStatement.executeUpdate();
	                
	                //out.println("New Highest Bid: " + newHighestBidAmount);
	                
	                out.println("<script>alert('Top bid in Auction with ID: " + selectedAucId + " deleted successfully.');</script>");
                }
            } else {
                // No highest bid found
                out.println("<script>alert('No highest bid found for Auction with ID: " + selectedAucId + ".');</script>");
            }
        } catch (SQLException e) {
            out.println("<script>alert('Failed to delete top bid in Auction with ID: " + selectedAucId + ".');</script>");
            e.printStackTrace();
        }

    }
}

Statement st1 = con.createStatement();
ResultSet rs1 = st1.executeQuery("SELECT auctionID FROM auctions");

%>
<!DOCTYPE html>
<html>
<head>
    <title>Delete a User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h1 {
            color: #007bff;
        }
        select {
            width: 100%;
            padding: 10px;
            margin-top: 20px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            padding: 10px 20px;
            border: none;
            background-color: #dc3545;
            color: #fff;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #c82333;
        }
        a {
            text-decoration: none;
            color: #007bff;
            display: block;
            margin-top: 20px;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Delete Top Bid From Auction</h1>
        <a href='logout.jsp'>Log out</a>
        <a href='customer_rep.jsp'>Back</a>&nbsp;
        <form action="remove_bid.jsp" method="post">
        	<label for="aucId">AuctionID:</label>
            <select name="aucId">
                <% while (rs1.next()) { %>
                    <option value="<%= rs1.getString("auctionID") %>"><%= rs1.getString("auctionID") %></option>
                <% } %>
            </select>
            <button type="submit">Delete Top Bid from Auction</button>
        </form>
    </div>
</body>
</html>