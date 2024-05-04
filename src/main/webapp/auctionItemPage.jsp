<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime,java.time.format.DateTimeFormatter"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction Details</title>
</head>
<body>
    <header>
        <h1>BuyMe</h1>
        <nav>
            <a href="BuyMe.jsp">Home</a>
            <a href="my_bids.jsp">My Bids</a>
            <a href="my_auctions.jsp">My Auctions</a>
            <a href="interested_items.jsp">Interested Items</a>
            <a href="my_account.jsp">My Account</a>
            <a href="logout.jsp">Log Out</a>
        </nav>
    </header>
    
    <section id="item-section">
        <%-- Retrieve and display vehicle and auction information --%>
        <% 
        ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
        
        //String auctionID = (String) session.getAttribute("auctionID");
      	//String username = (String) session.getAttribute("user");
        String auctionID = "1";
       	//String username = "admin";
        String username = "user2";
        
        Statement findUser = con.createStatement();
        String userDetailsQuery = "select * from users where username = '" + username + "'";
        ResultSet user = findUser.executeQuery(userDetailsQuery);
        boolean canBid = true;
        if(user.next()){
        	if(user.getString("account_type").equals("admin") || user.getString("account_type").equals("cust_rep")){
        		canBid = false;
        	}
        }
        
		Statement selectDetailsStmt = con.createStatement();
		String vehicleAndAuctionDetails = "select * from vehicles join auctions on vehicles.VIN = auctions.VIN where vehicles.VIN = ( select VIN from auctions where auctionID = " + auctionID + ")";
		ResultSet vehicleAuctionResult = selectDetailsStmt.executeQuery(vehicleAndAuctionDetails);
		if(!vehicleAuctionResult.next()){
			response.sendRedirect("auctionNotFound.jsp");
		}
		
		// Vehicle details
		String vin = vehicleAuctionResult.getString("VIN");
		String year = vehicleAuctionResult.getString("year");
		String make = vehicleAuctionResult.getString("make");
		String model = vehicleAuctionResult.getString("model");
		String mileage = vehicleAuctionResult.getString("mileage");
		String color = vehicleAuctionResult.getString("color");
		String bodyStyle = vehicleAuctionResult.getString("body_style");
		String powerTrain = vehicleAuctionResult.getString("power_train");
		String condition = vehicleAuctionResult.getString("condition");
		String fuelEfficiency = vehicleAuctionResult.getString("fuel_efficiency");
		String isSelfDriving = vehicleAuctionResult.getString("fuel_efficiency") == "1" ? "Yes" : "No";
		String hasCarPlay = vehicleAuctionResult.getString("has_car_play") == "1" ? "Yes" : "No";
		String isRemoteStart = vehicleAuctionResult.getString("is_remote_start") == "1" ? "Yes" : "No";
		String capacity = vehicleAuctionResult.getString("capacity") == null ? "N/A" : vehicleAuctionResult.getString("capacity");
		String engineCC = vehicleAuctionResult.getString("engine_cc") == null ? "N/A" : vehicleAuctionResult.getString("engine_cc");
		
		// Auction details
		String endTime = vehicleAuctionResult.getString("close_time");
		float price = vehicleAuctionResult.getFloat("initial_price");
		float reserve = vehicleAuctionResult.getFloat("secret_minimum_price");
		float increment = vehicleAuctionResult.getFloat("increment");
		float highestBid = vehicleAuctionResult.getFloat("highest_bid");
		String highestBidder = vehicleAuctionResult.getString("highest_bidder");
		
		selectDetailsStmt.close();
		vehicleAuctionResult.close();
		
        %>
        <h2><%= year %> <%= make %> <%= model %></h2>
        <h3>Current Price: $<%= price > highestBid ? price: highestBid%></h3>
        <h4>Closing Date/Time: <%= endTime %></h4>
        <%-- Display detailed vehicle information --%>
        <ul>
            <li>VIN: <%= vin %></li>
            <li>Mileage: <%= mileage %> Miles</li>
            <li>Color: <%= color %></li>
            <li>Body Style: <%= bodyStyle %></li>
            <li>Powertrain: <%= powerTrain %></li>
            <li>Condition: <%= condition %></li>
            <li>Fuel Efficiency: <%= fuelEfficiency %></li>
            <li>Is Self Driving: <%= isSelfDriving %></li>
            <li>Has Car Play: <%= hasCarPlay %></li>
            <li>Has Remote Start: <%= isRemoteStart %></li>
            <li>Capacity: <%= capacity %></li>
            <li>Engine CC: <%= engineCC %></li>
            <%-- <li>Highest Bidder: <%= highestBidder %></li>
            <li>Highest Bid: <%= highestBid %></li> --%>
        </ul>
        
        <%-- Button to add listing to favorites --%>
		<p>
		    <form action="" method="post">
		    	<input type="hidden" name="action" value="addToFavorites">
		        <button type="submit">Add to Favorites</button>
		    </form>
		    <p>
		        <% 
		        if (request.getMethod().equals("POST") && "addToFavorites".equals(request.getParameter("action"))) {
		            Statement checkIfFavoritedStmt = con.createStatement();
		            String checkIfFavoritedQuery = "select * from interested_items where username = '" + username + "' and VIN = '" + vin + "'";
		            ResultSet favoritedResults = checkIfFavoritedStmt.executeQuery(checkIfFavoritedQuery);
		            if (!favoritedResults.next()) {
		                Statement addToFavoritesStmt = con.createStatement();
		                String addToFavoritesQuery = "insert into interested_items values ('" + username + "', '" + vin + "')";
		                addToFavoritesStmt.executeUpdate(addToFavoritesQuery);
		                out.println("Added to your interested items.");
		            } else {
		                out.println("Already in your interested items.");
		            }
		            checkIfFavoritedStmt.close();
		            favoritedResults.close();
		        }
		        %>
		    </p>
		</p>
        
        
    </section>
    
    <section id="place-bids-section"> 
    	<h2>Bid On This Auction</h2>
    	<h4>Increment: $<%= increment + "" %></h4>
    	
    	<%-- Manual bidding --%>
    	<form action="" method="post">
        	<input type="number" name="bidAmount" step="0.01" placeholder="Enter bid amount" required>
        	<input type="hidden" name="action" value="placeBid">
        	<button type="submit">Place Bid</button>
    	</form>
	    <p>
		<% 
	    
		if (request.getMethod().equals("POST") && "placeBid".equals(request.getParameter("action"))) {		   	
			if(highestBidder.equals(username)){
		   		out.println("You are already the highest bidder on this auction.");
			}else if(!canBid){
				out.println("You cannot bid on this auction as an admin or customer representative.");
		   	}else{
		   		float bidAmount = Float.parseFloat(request.getParameter("bidAmount"));
			   	if (bidAmount >= highestBid + increment) {
			   		out.println("Bid placed successfully.");
			   		
			   		// insert new value into bids table with username, datetime, and new amount
			       	LocalDateTime currentDateTime = LocalDateTime.now();
			   		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			   		String formattedDate = currentDateTime.format(formatter);
			   		
			   		Statement newBid = con.createStatement();
			   		String addNewBid = "insert into bids values ('" + username + "', " + auctionID + ", '" + formattedDate + "', " + bidAmount + ")";
			   		newBid.executeUpdate(addNewBid);
			   		newBid.close();
			       	
			       	// send alert to highest bidder if not null: insert into alert_inbox new value (highestBidder, 'you have been outbid on the [year] [model] [make]')
			       	if(highestBidder != null){
			       		Statement bidAlert = con.createStatement();
				       	String alertMessage = "You have been outbid on the " + year + " " + model + " " + make + "! (VIN: " + vin + ")";
				       	String addBidAlert = "insert into alert_inbox values ('" + highestBidder + "', '" + formattedDate + "', '" + alertMessage + "')";
				       	bidAlert.executeUpdate(addBidAlert);
				       	bidAlert.close();
			       	}
			       	
			       	// update auction row: highest_bidder -> username, highest_bid -> new bid
			       	Statement update = con.createStatement();
			       	String updateAuction = "update auctions set `highest_bid` = " + bidAmount + ", `highest_bidder` = '" + username + "' where auctionID = " + auctionID;
			       	update.executeUpdate(updateAuction);
			       	update.close();
			       	
			       	// refresh by redirecting to this page
			   		response.sendRedirect("auctionItemPage.jsp");
			   	} else {
					out.println("Bid amount is too low.");
			   	}
		   	}
		}

        %>
	    </p>
    	<%-- Auto bidding --%>
    </section>
    
    <section id="bids-section">
        <h2>Bid History</h2>
        <%-- Retrieve and display bids for this auction --%>
        <table>
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Time</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
                <%-- Retrieve and display bids --%>
                <% 
                Statement retrieveBids = con.createStatement();
        		String retrieveBidsQuery = "select * from bids where auctionID = " + auctionID + " order by amount desc";
        		ResultSet bids = retrieveBids.executeQuery(retrieveBidsQuery);
                
        		while(bids.next()){
        			String bidUsername = bids.getString("username");
        			Timestamp time = bids.getTimestamp("time");
        			float amount = bids.getFloat("amount");
                %>
                <tr>
                    <td><%= bidUsername %></td>
                    <td><%= time %></td>
                    <td>$<%= amount %></td>
                </tr>
                <% 
        		}
                retrieveBids.close();
                bids.close();
                %>
            </tbody>
        </table>
    </section>
</body>
</html>
