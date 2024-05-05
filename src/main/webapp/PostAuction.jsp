<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Post New Auction</title>
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
        h1, h2 {
            text-align: center;
            color: #333;
        }
        form {
            width: 100%;
            margin-top: 20px;
        }
        label {
            display: block;
            margin: 15px 0 5px;
        }
        input, select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            margin-bottom: 20px;
        }
        button {
            width: 100%;
            padding: 10px;
            border: none;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Post New Auction</h1>
    <form action="PostAuction.jsp" method="post">
        <!-- Vehicle Details -->
        <h2>Vehicle Details</h2>
        <label for="VIN">VIN:</label>
        <input type="text" id="VIN" name="VIN" required>
        
        <label for="make">Make:</label>
        <input type="text" id="make" name="make" required>
        
        <label for="model">Model:</label>
        <input type="text" id="model" name="model">
        
        <label for="year">Year:</label>
        <input type="number" id="year" name="year" required>
        
        <!-- Additional vehicle fields as per schema -->
        <label for="mileage">Mileage:</label>
        <input type="number" id="mileage" name="mileage">
        
        <label for="color">Color:</label>
        <input type="text" id="color" name="color">
        
        <label for="body_style">Body Style:</label>
        <input type="text" id="body_style" name="body_style">
        
        <label for="power_train">Power Train:</label>
        <input type="text" id="power_train" name="power_train">
        
        <label for="condition">Condition:</label>
        <input type="text" id="condition" name="condition">
        
        <label for="fuel_efficiency">Fuel Efficiency:</label>
        <input type="number" step="0.01" id="fuel_efficiency" name="fuel_efficiency">
        
        <label for="type">Type:</label>
        <select id="type" name="type" required>
            <option value="car">Car</option>
            <option value="truck">Truck</option>
            <option value="motorcycle">Motorcycle</option>
        </select>
        
        <label for="is_self_driving">Is Self Driving:</label>
        <select id="is_self_driving" name="is_self_driving">
            <option value="true">Yes</option>
            <option value="false" selected>No</option>
        </select>
        
        <label for="has_car_play">Has Car Play:</label>
        <select id="has_car_play" name="has_car_play">
            <option value="true">Yes</option>
            <option value="false" selected>No</option>
        </select>
        
        <label for="is_remote_start">Is Remote Start:</label>
        <select id="is_remote_start" name="is_remote_start">
            <option value="true">Yes</option>
            <option value="false" selected>No</option>
        </select>
        
        <label for="capacity">Capacity:</label>
        <input type="number" id="capacity" name="capacity">
        
        <label for="engine_cc">Engine CC:</label>
        <input type="number" id="engine_cc" name="engine_cc">
        
        <!-- Auction Details -->
        <h2>Auction Details</h2>
        <label for="initial_price">Initial Price:</label>
        <input type="number" step="0.01" id="initial_price" name="initial_price" required>
        
        <label for="secret_minimum_price">Secret Minimum Price:</label>
        <input type="number" step="0.01" id="secret_minimum_price" name="secret_minimum_price" required>
        
        <label for="increment">Bid Increment:</label>
        <input type="number" step="0.01" id="increment" name="increment" required>
        
        <label for="close_time">Close Time (yyyy-mm-ddTHH:mm):</label>
        <input type="datetime-local" id="close_time" name="close_time" required>
        
        <button type="submit">Submit Auction</button>
    </form>
    <% 
        String VIN = request.getParameter("VIN");
        String make = request.getParameter("make");
        String model = request.getParameter("model");
        String year = request.getParameter("year");
        // Additional vehicle parameters
        String mileage = request.getParameter("mileage") != null ? String.valueOf(request.getParameter("mileage")) : "-1";
        String color = request.getParameter("color");
        String body_style = request.getParameter("body_style");
        String power_train = request.getParameter("power_train");
        String condition = request.getParameter("condition");
        String fuel_efficiency = request.getParameter("fuel_efficiency") != null ? String.valueOf(request.getParameter("fuel_efficiency")) : "-1";
        String type = request.getParameter("type");
        String is_self_driving = request.getParameter("is_self_driving");
        String has_car_play = request.getParameter("has_car_play");
        String is_remote_start = request.getParameter("is_remote_start");
        String capacity = request.getParameter("capacity") != null ? String.valueOf(request.getParameter("capacity")) : "-1";
        String engine_cc = request.getParameter("engine_cc") != null ? String.valueOf(request.getParameter("engine_cc")) : "-1";
        
        String initialPrice = request.getParameter("initial_price");
        String secretMinimumPrice = request.getParameter("secret_minimum_price");
        String increment = request.getParameter("increment");
        String closeTime = request.getParameter("close_time");
        String userID = (String) session.getAttribute("user");
        
        

        if (VIN != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                
                String queryForAuctionID = "SELECT MAX(auctionID) AS max FROM auctions";
                PreparedStatement psAuctionID = con.prepareStatement(queryForAuctionID);
                ResultSet rsAuctionID = psAuctionID.executeQuery();
                int auctionID = 1; // Default starting ID
                if (rsAuctionID.next()) {
                    auctionID = rsAuctionID.getInt("max") + 1; // Increment to get the next ID
                }

                // Insert Vehicle
  				PreparedStatement psVehicle = con.prepareStatement("INSERT INTO vehicles (VIN, make, model, year, mileage, color, body_style, power_train, `condition`, fuel_efficiency, type, is_self_driving, has_car_play, is_remote_start, capacity, engine_cc) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				psVehicle.setString(1, VIN);
				psVehicle.setString(2, make);
				psVehicle.setString(3, model);
				psVehicle.setInt(4, Integer.parseInt(year));
				psVehicle.setInt(5, Integer.parseInt(mileage));
				psVehicle.setString(6, color);
				psVehicle.setString(7, body_style);
				psVehicle.setString(8, power_train);
				psVehicle.setString(9, condition);
				psVehicle.setFloat(10, Float.parseFloat(fuel_efficiency));
				psVehicle.setString(11, type);
				psVehicle.setBoolean(12, Boolean.parseBoolean(is_self_driving));
				psVehicle.setBoolean(13, Boolean.parseBoolean(has_car_play));
				psVehicle.setBoolean(14, Boolean.parseBoolean(is_remote_start));
				psVehicle.setInt(15, Integer.parseInt(capacity));
				psVehicle.setInt(16, Integer.parseInt(engine_cc));
				psVehicle.executeUpdate();


                // Insert Auction
				PreparedStatement psAuction = con.prepareStatement("INSERT INTO auctions (auctionID, VIN, initial_price, secret_minimum_price, increment, close_time, seller, highest_bid, highest_bidder) VALUES (?, ?, ?, ?, ?, ?, ?, NULL, NULL)");
				psAuction.setInt(1, auctionID);
				psAuction.setString(2, VIN);
				psAuction.setFloat(3, Float.parseFloat(initialPrice));
				psAuction.setFloat(4, Float.parseFloat(secretMinimumPrice));
				psAuction.setFloat(5, Float.parseFloat(increment));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
				psAuction.setTimestamp(6, new Timestamp(sdf.parse(closeTime).getTime()));
				psAuction.setString(7, userID);
				psAuction.executeUpdate();

                con.close();
                out.println("<p>Auction and vehicle registered successfully!</p>");
            } catch (Exception e) {
                out.println("<p>Error processing request: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        }
    %>
</div>

    <a href='logout.jsp'>Log out</a>
    <br><br>
    <button class="green" onclick="window.location.href='BuyMe.jsp'">Back</button>
</body>
</html>