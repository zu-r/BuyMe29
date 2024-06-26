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
        
        .bid-history-container {
        height: 300px;
        overflow-y: auto;
        border: 1px solid #ccc;
        padding: 10px;
    }

    .bid-history-container table {
        width: 100%;
        border-collapse: collapse; /* Ensure table borders collapse properly */
    }

    .bid-history-container th,
    .bid-history-container td {
        border: 1px solid #ccc;
        padding: 8px;
        text-align: left; /* Align text to the left within table cells */
    }
    
    </style>
</head>
<body>
    <header>
        <h1>BuyMe</h1>
        <nav>
            <a href="BuyMe.jsp">Home</a>
            <a href="myBids.jsp">My Bids</a>
            <a href="myAuctions.jsp">My Auctions</a>
            <a href="InterestedAuctions.jsp">Interested Items</a>
            <a href="logout.jsp">Log Out</a>
        </nav>
    </header>
    
    <section id="item-section">
        <%-- Retrieve and display vehicle and auction information --%>
        <% 
        ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
        
        String auctionIDString = request.getParameter("auctionID");
        int auctionID = Integer.parseInt(auctionIDString);

        try {
             auctionID = Integer.parseInt(auctionIDString);
            // Now 'auctionID' holds the integer value of the parameter
            // Use 'auctionID' as needed in your code
        } catch (NumberFormatException e) {
            // Handle the case where the parameter value is not a valid integer
            // This could happen if the parameter is missing or not in a valid integer format
            e.printStackTrace(); // Print or log the error
        }
        
      	String username = (String) session.getAttribute("user");
        //String auctionID = "1";
       	//String username = "admin";
        //String username = "bro";
        
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
		String mileage = vehicleAuctionResult.getString("mileage").equals("-1") ? "N/A" : vehicleAuctionResult.getString("mileage");
		String color = vehicleAuctionResult.getString("color");
		String bodyStyle = vehicleAuctionResult.getString("body_style");
		String powerTrain = vehicleAuctionResult.getString("power_train");
		String condition = vehicleAuctionResult.getString("condition");
		String fuelEfficiency = vehicleAuctionResult.getString("fuel_efficiency").equals("-1") ? "N/A" : vehicleAuctionResult.getString("fuel_efficiency");
		String isSelfDriving = vehicleAuctionResult.getBoolean("is_self_driving") ? "Yes" : "No";
        String hasCarPlay = vehicleAuctionResult.getBoolean("has_car_play") ? "Yes" : "No";
        String isRemoteStart = vehicleAuctionResult.getBoolean("is_remote_start") ? "Yes" : "No";
		//String capacity = vehicleAuctionResult.getString("capacity").equals("-1") ? "N/A" : vehicleAuctionResult.getString("capacity");
		String capacity = vehicleAuctionResult.getString("capacity") == null ? "N/A" : vehicleAuctionResult.getString("capacity").equals("-1") ? "N/A" : vehicleAuctionResult.getString("capacity");
		String engineCC = vehicleAuctionResult.getString("engine_cc") == null ? "N/A" : vehicleAuctionResult.getString("engine_cc").equals("-1") ? "N/A" : vehicleAuctionResult.getString("engine_cc");
		
		// Auction details
		String endTime = vehicleAuctionResult.getString("close_time");
		float price = vehicleAuctionResult.getFloat("initial_price");
		float reserve = vehicleAuctionResult.getFloat("secret_minimum_price");
		float increment = vehicleAuctionResult.getFloat("increment");
		float initialPrice = vehicleAuctionResult.getFloat("initial_price");
		float highestBid = vehicleAuctionResult.getFloat("highest_bid") > initialPrice ? vehicleAuctionResult.getFloat("highest_bid") : initialPrice;
		String highestBidder = vehicleAuctionResult.getString("highest_bidder") == null ? "N/A" : vehicleAuctionResult.getString("highest_bidder");
		String seller = vehicleAuctionResult.getString("seller");
		
		selectDetailsStmt.close();
		vehicleAuctionResult.close();
		
		Statement findUser = con.createStatement();
        String userDetailsQuery = "select * from users where username = '" + username + "'";
        ResultSet user = findUser.executeQuery(userDetailsQuery);
        boolean canBid = true;
        if(user.next()){
        	if(user.getString("account_type").equals("admin") || user.getString("account_type").equals("cust_rep") || username.equals(seller)){
        		canBid = false;
        	}
        }
		
        %>
        
        <% 
        LocalDateTime currentDateTime = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
        LocalDateTime auctionEndTime = LocalDateTime.parse(endTime, formatter);

        if (currentDateTime.isBefore(auctionEndTime)) {
	        %>       
	        <h2> <%= year %> <%= make %> <%= model %></h2>
	        <h3>Current Price: $<%= price > highestBid ? price: highestBid%></h3>
	        <% } else { %>
	        <h2>Auction Closed: <%= year %> <%= make %> <%= model %></h2>
	        <h3>Final Price: $<%= price > highestBid ? price: highestBid%></h3>
	        <% 
	        //auction close logic
	        if(highestBidder.equals("N/A") || highestBid < reserve){
	        	%>
	        	<h3>This vehicle did not sell.</h3>
	        	<%
	        	// auction did not sell, send alert to seller that it did not sell: "Your auction for the [year] [make] [model] (VIN: [VIN]) did not sell."
	        	String didNotSellMessage = "Your auction for the " + year + " " + make + " " + model + " (VIN: " + vin + ") did not sell.";
	        	String checkDupeMessageQuery = "select * from alert_inbox where username = '" + seller + "' and message = '" + didNotSellMessage + "'";
	        	Statement checkDupeMessage = con.createStatement();
	        	ResultSet dupeMessages = checkDupeMessage.executeQuery(checkDupeMessageQuery);
	        	
	        	if(!dupeMessages.next()){
	        		currentDateTime = LocalDateTime.now();
	        		String formattedDate = currentDateTime.format(formatter);
	        		
	        		Statement auctionAlert = con.createStatement();
	                String addBidAlert = "insert into alert_inbox values ('" + seller + "', '" + formattedDate + "', '" + didNotSellMessage + "')";
	                auctionAlert.executeUpdate(addBidAlert);
	                auctionAlert.close();
	        	}
	        	checkDupeMessage.close();
	        	dupeMessages.close();
	        }else{
	        	%>
	        	<h3><%= highestBidder %> has won this auction!</h3>
	        	<%
	        	// auction sold, send alert to highestBidder: "You won the auction for the [year] [make] [model]! (VIN: [VIN])"
	        	String soldMessage = "You won the action for the " + year + " " + make + " " + model + "! (VIN: " + vin + ")";
	        	String checkDupeMessageQuery = "select * from alert_inbox where username = '" + highestBidder + "' and message = '" + soldMessage + "'";
	        	Statement checkDupeMessage = con.createStatement();
	        	ResultSet dupeMessages = checkDupeMessage.executeQuery(checkDupeMessageQuery);
	        	
	        	if(!dupeMessages.next()){
	        		currentDateTime = LocalDateTime.now();
	        		String formattedDate = currentDateTime.format(formatter);
	        		
	        		Statement auctionAlert = con.createStatement();
	                String addBidAlert = "insert into alert_inbox values ('" + highestBidder + "', '" + formattedDate + "', '" + soldMessage + "')";
	                auctionAlert.executeUpdate(addBidAlert);
	                auctionAlert.close();
	        	}
	        	checkDupeMessage.close();
	        	dupeMessages.close();
	        }
        } %>
        
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
            <li>Highest Bidder: <%= highestBidder %></li>
            <li>Highest Bid: <%= highestBid %></li>
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
		                String addToFavoritesQuery = "insert into interested_items values ('" + username + "', '" + vin + "', '" + make + "', '" + model + "')";
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
    currentDateTime = LocalDateTime.now();
    formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
    auctionEndTime = LocalDateTime.parse(endTime, formatter);

    if (currentDateTime.isBefore(auctionEndTime)) {
    	
		if (request.getMethod().equals("POST") && "placeBid".equals(request.getParameter("action"))) {
		    if (!highestBidder.equals("N/A") && highestBidder.equals(username)) {
		        out.println("You are already the highest bidder on this auction.");
		    } else if (!canBid) {
		        out.println("You cannot bid on this auction as an admin, customer representative, or the seller.");
		    } else {
		        float bidAmount = Float.parseFloat(request.getParameter("bidAmount"));
		        if (bidAmount >= highestBid + increment) {
		        	highestBid = bidAmount;
		        	String originalBidder = highestBidder;
		            highestBidder = username;
		            out.println("Bid placed successfully.");
		         	
		            // send alert to highest bidder if not null: insert into alert_inbox new value (highestBidder, 'you have been outbid on the [year] [model] [make]')
		            String formattedDate = currentDateTime.format(formatter);
		            if (!originalBidder.equals("N/A") && !originalBidder.equals(username)) {
		                Statement bidAlert = con.createStatement();
		                String alertMessage = "You have been outbid on the " + year + " "+ make + " " + model + "! (VIN: " + vin + ") (New Price: " + highestBid + ")";
		                String addBidAlert = "insert into alert_inbox values ('" + originalBidder + "', '" + formattedDate + "', '" + alertMessage + "')";
		                bidAlert.executeUpdate(addBidAlert);
		                bidAlert.close();
		            }
		            
		         	// Prepare the SQL query with placeholders
		            String insertQuery = "INSERT INTO bids (username, auctionID, time, amount) VALUES (?, ?, ?, ?)";
		
		            PreparedStatement preparedStatement = con.prepareStatement(insertQuery);
	                // Set the values for the placeholders
	                preparedStatement.setString(1, username);
	                preparedStatement.setInt(2, auctionID);
	                preparedStatement.setString(3, formattedDate);
	                preparedStatement.setFloat(4, bidAmount);
	
	                // Execute the update
	                preparedStatement.executeUpdate();
	                out.println("New bid inserted successfully!");
		          
		            // update auction row: highest_bidder -> username, highest_bid -> new bid
		            Statement update = con.createStatement();
		            String updateAuction = "update auctions set `highest_bid` = " + bidAmount + ", `highest_bidder` = '" + username + "' where auctionID = " + auctionID;
		            update.executeUpdate(updateAuction);
		            update.close();
		            
		            Statement findAutoBids = con.createStatement();
	                String otherAutoBidsQuery = "select * from auto_bids where auctionID = " + auctionID;
	                ResultSet autoBidders = findAutoBids.executeQuery(otherAutoBidsQuery);
	                
	                ArrayList<String> bidderList = new ArrayList<String>();
	                ArrayList<Float> maxList = new ArrayList<Float>();
	               	
	                float highestAutoBid = 0;
	                while(autoBidders.next()){
	                	String bidderName = autoBidders.getString("username");
	                	float maxBid = autoBidders.getFloat("max_amount");
	                	if (maxBid > highestAutoBid){
	                		highestAutoBid = maxBid;
	                	}
	                	
	                	bidderList.add(bidderName);
	                	maxList.add(maxBid);
	                }
	                
	                while(highestBid < highestAutoBid){
	                	int skips = 0;
	                	for(int i = 0; i < bidderList.size(); i++){
	                		if(highestBidder == null || !highestBidder.equals(bidderList.get(i))){
	                			if(maxList.get(i) < highestBid + increment){
	                				skips++;
	                			}else{
	                				currentDateTime = LocalDateTime.now();
		                    	    formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		                    	    String insertQuery2 = "INSERT INTO bids (username, auctionID, time, amount) VALUES (?, ?, ?, ?)";
		                    	    formattedDate = currentDateTime.format(formatter);
		                    	    highestBid += increment;
		                    	    String tempBidder = highestBidder;
		                    	    highestBidder = bidderList.get(i);
		                    	    
		        		            PreparedStatement preparedStatement2 = con.prepareStatement(insertQuery2);
		       		                // Set the values for the placeholders
		       		                preparedStatement2.setString(1, bidderList.get(i));
		       		                preparedStatement2.setInt(2, auctionID);
		       		                preparedStatement2.setString(3, formattedDate);
		       		                preparedStatement2.setFloat(4, highestBid);
		       		
		       		                // Execute the update
		       		                preparedStatement2.executeUpdate();
		        		            
		        		            // send alert to highest bidder if not null: insert into alert_inbox new value (highestBidder, 'you have been outbid on the [year] [model] [make]')
		        		            if (!highestBidder.equals("N/A")) {
		        		                Statement bidAlert = con.createStatement();
		        		                String alertMessage = "You have been outbid on the " + year + " " + make + " " + model + "! (VIN: " + vin + ") (New Price: " + highestBid + ")";
		        		                String addBidAlert = "insert into alert_inbox values ('" + tempBidder  + "', '" + formattedDate + "', '" + alertMessage + "')";
		        		                bidAlert.executeUpdate(addBidAlert);
		        		                bidAlert.close();
		        		            }
		        		            
		        		            // update auction row: highest_bidder -> username, highest_bid -> new bid
		        		            Statement update2 = con.createStatement();
		        		            String updateAuction2 = "update auctions set `highest_bid` = " + highestBid + ", `highest_bidder` = '" + bidderList.get(i) + "' where auctionID = " + auctionID;
		        		            update2.executeUpdate(updateAuction2);
		        		            update2.close();
	                			}
	                    	}
	                	}
	                	
	                	if(bidderList.size() == 1 || skips >= bidderList.size() - 1){
	                		break;
	                	}	
	                }
		            
		            // refresh by redirecting to this page
		            response.sendRedirect("auctionItemPage.jsp?auctionID=" + auctionID);
		        } else {
		            out.println("Bid amount is too low.");
		        }
		    }
		}
    }else out.println("Bidding time has passed");
%>

	    </p>
    	<%-- Auto bidding --%>
    	<form action="" method="post">
        	<input type="number" name="autoBidAmount" step="0.01" placeholder="Enter auto bid maximum" required>
        	<input type="hidden" name="action" value="placeAutoBid">
        	<button type="submit">Set Auto Bid</button>
    	</form>
	    <p>
		<% 
		currentDateTime = LocalDateTime.now();
		formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
	    auctionEndTime = LocalDateTime.parse(endTime, formatter);

	    if (currentDateTime.isBefore(auctionEndTime)) {
			if (request.getMethod().equals("POST") && "placeAutoBid".equals(request.getParameter("action"))) {
				float bidAmount = Float.parseFloat(request.getParameter("autoBidAmount"));
				if(!canBid){
					 out.println("You cannot bid on this auction as an admin, customer representative, or the seller.");
				}else if(bidAmount >= highestBid + increment){
					Statement st1 = con.createStatement();
					ResultSet rs1;
					rs1 = st1.executeQuery("select * from auto_bids where username='" + username + "'");
					if (rs1.next()){
						String updateQuery = "update auto_bids set `max_amount` = " + bidAmount + " where username = '" + username + "'";
						Statement st2 = con.createStatement();
						st2.executeUpdate(updateQuery);
						st2.close();
					}else{
						String insertQuery = "INSERT INTO auto_bids (username, auctionID, max_amount) VALUES (?, ?, ?)";
			            PreparedStatement preparedStatement = con.prepareStatement(insertQuery);
		                preparedStatement.setString(1, username);
		                preparedStatement.setInt(2, auctionID);
		                preparedStatement.setString(3, bidAmount + "");
		                preparedStatement.executeUpdate();
		                preparedStatement.close();
					}
					st1.close();
					rs1.close();
	                
	                Statement findAutoBids = con.createStatement();
	                String otherAutoBidsQuery = "select * from auto_bids where auctionID = " + auctionID;
	                ResultSet autoBidders = findAutoBids.executeQuery(otherAutoBidsQuery);
	                
	                ArrayList<String> bidderList = new ArrayList<String>();
	                ArrayList<Float> maxList = new ArrayList<Float>();
	               	
	                float highestAutoBid = 0;
	                while(autoBidders.next()){
	                	String bidderName = autoBidders.getString("username");
	                	float maxBid = autoBidders.getFloat("max_amount");
	                	if (maxBid > highestAutoBid){
	                		highestAutoBid = maxBid;
	                	}
	                	
	                	bidderList.add(bidderName);
	                	maxList.add(maxBid);
	                }
	                
	                while(highestBid < highestAutoBid){
	                	int skips = 0;
	                	for(int i = 0; i < bidderList.size(); i++){
	                		if(highestBidder == null || !highestBidder.equals(bidderList.get(i))){
	                			if(maxList.get(i) < highestBid + increment){
	                				skips++;
	                			}else{
	                				currentDateTime = LocalDateTime.now();
		                    	    formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		                    	    String insertQuery2 = "INSERT INTO bids (username, auctionID, time, amount) VALUES (?, ?, ?, ?)";
		                    	    String formattedDate = currentDateTime.format(formatter);
		                    	    highestBid += increment;
		                    	    String tempBidder = highestBidder;
		                    	    highestBidder = bidderList.get(i);
		                    	    
		        		            PreparedStatement preparedStatement2 = con.prepareStatement(insertQuery2);
		       		                // Set the values for the placeholders
		       		                preparedStatement2.setString(1, bidderList.get(i));
		       		                preparedStatement2.setInt(2, auctionID);
		       		                preparedStatement2.setString(3, formattedDate);
		       		                preparedStatement2.setFloat(4, highestBid);
		       		
		       		                // Execute the update
		       		                preparedStatement2.executeUpdate();
		        		            
		        		            // send alert to highest bidder if not null: insert into alert_inbox new value (highestBidder, 'you have been outbid on the [year] [model] [make]')
		        		            if (!tempBidder.equals("N/A")) {
		        		                Statement bidAlert = con.createStatement();
		        		                String alertMessage = "You have been outbid on the " + year + " " + make + " " + model + "! (VIN: " + vin + ") (New Price: " + highestBid + ")";
		        		                String addBidAlert = "insert into alert_inbox values ('" + tempBidder  + "', '" + formattedDate + "', '" + alertMessage + "')";
		        		                bidAlert.executeUpdate(addBidAlert);
		        		                bidAlert.close();
		        		            }
		        		            
		        		            // update auction row: highest_bidder -> username, highest_bid -> new bid
		        		            Statement update = con.createStatement();
		        		            String updateAuction = "update auctions set `highest_bid` = " + highestBid + ", `highest_bidder` = '" + bidderList.get(i) + "' where auctionID = " + auctionID;
		        		            update.executeUpdate(updateAuction);
		        		            update.close();
	                			}
	                    	}
	                	}
	                	
	                	if(bidderList.size() == 1 || skips >= bidderList.size() - 1){
	                		break;
	                	}	
	                }
	                
		            // refresh by redirecting to this page
			        response.sendRedirect("auctionItemPage.jsp?auctionID=" + auctionID);   
				}else {
		            out.println("Bid amount is too low.");
		        }
			}
	    }else out.println("Bidding time has passed");
		
		%>
    </section>
    
    <section id="bids-section">
    <h2>Bid History</h2>
    <%-- Retrieve and display bids for this auction --%>
    <div class="bid-history-container">
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
    </div>
    
    
</section>

<div class="auctions-container">
        <% 
            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                String query = "SELECT v.make, v.model, v.year, u.username, a.auctionID, a.close_time, IFNULL(a.highest_bid, a.initial_price) AS display_price " +
                        "FROM vehicles v " +
                        "JOIN auctions a ON v.VIN = a.VIN " +
                        "JOIN users u ON a.seller = u.username " +
                        "WHERE v.type = (" +
                        "    SELECT type " +
                        "    FROM vehicles " +
                        "    JOIN auctions ON vehicles.VIN = auctions.VIN " +
                        "    WHERE auctions.auctionID = ?)" +
                        
                        
                        "AND a.close_time > now() " +
                        "ORDER BY a.close_time DESC "
                        ;

         PreparedStatement preparedStatement = con.prepareStatement(query);
         preparedStatement.setInt(1, auctionID);

         ResultSet resultSet = preparedStatement.executeQuery();
                
                while (resultSet.next()) {
                    make = resultSet.getString("make");
                    model = resultSet.getString("model");
                    year = resultSet.getString("year");
                    username = resultSet.getString("username");
                    auctionID = Integer.parseInt(resultSet.getString("auctionID"));
                    String closeTime = resultSet.getString("close_time");
                    String displayPrice = resultSet.getString("display_price");
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
                resultSet.close();
                preparedStatement.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
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
