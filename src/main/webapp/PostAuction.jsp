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
            max-width: 600px;
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
        <label for="VIN">VIN:</label>
        <input type="text" id="VIN" name="VIN" required>

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
        String initialPrice = request.getParameter("initial_price");
        String secretMinimumPrice = request.getParameter("secret_minimum_price");
        String increment = request.getParameter("increment");
        String closeTime = request.getParameter("close_time");
        String userID = (String) session.getAttribute("user");

        if (VIN != null && initialPrice != null && secretMinimumPrice != null && increment != null && closeTime != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM auctions");
                rs.next();
                int auctionID = rs.getInt("count") + 1; // Assuming starting index 1
                PreparedStatement ps = con.prepareStatement("INSERT INTO auctions (auctionID, close_time, initial_price, secret_minimum_price, increment, highest_bid, highest_bidder, VIN, seller) VALUES (auctionID, closeTime, initial_price, secret_minimum_price, increment, NULL, NULL, VIN, seller)");
                ps.setString(1, VIN);
                ps.setFloat(2, Float.parseFloat(initialPrice));
                ps.setFloat(3, Float.parseFloat(secretMinimumPrice));
                ps.setFloat(4, Float.parseFloat(increment));
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                ps.setTimestamp(5, new Timestamp(sdf.parse(closeTime).getTime()));
                ps.setString(6, userID);
                ps.executeUpdate();
                con.close();
                out.println("<p>Auction posted successfully!</p>");
            } catch (Exception e) {
                out.println("<p>Error posting auction: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        }
    %>
</div>
</body>
</html>
