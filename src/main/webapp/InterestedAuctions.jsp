<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Interested Auctions</title>
    <style>
    
    
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
	/* Centers the text inside the header, including your paragraph */
}

p {
	margin: 20px 0;
	/* Adds vertical spacing around the paragraph for better visual separation */
}

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

h1 {
	text-align: center;
	color: #333;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

th, td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

th {
	background-color: #f2f2f2;
}

button {
	display: block;
	width: 100%;
	margin-bottom: 10px;
	padding: 12px;
	border: none;
	background-color: #007bff;
	color: #fff;
	font-size: 16px;
	border-radius: 4px;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

button.green {
	background-color: #28a745;
}

button.green:hover {
	background-color: #218838;
}
</style>
</head>
<body>

	<header>
		<h1>Interested Auctions</h1>
		<p>Shopping for vehicles made easy!</p>
	</header>
</head>
<body>
  <nav id="main-nav">
		<a href="BuyMe.jsp">Home</a> 
		<a href="myBids.jsp">My Bids</a> 
		<a href="myAuctions.jsp">My Auctions</a> 
		<a href="InterestedAuctions.jsp">Interested Items</a> 
		<a href="help.jsp">Help</a>
		<a href="logout.jsp">Log Out</a>
	</nav>

	<table>
		<thead>
			<tr>
				<th>Make</th>
				<th>Model</th>
				<th>Year</th>
				<th>Close Time</th>
			</tr>
		</thead>
		<tbody>
			<%
	
	     	String userID = (String) session.getAttribute("user");
	 		Class.forName("com.mysql.jdbc.Driver");
	        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
	        String query = "Select v.year, v.make, v.model, v.VIN, a.auctionID, a.close_time From auctions a join vehicles v on a.VIN = v.VIN Where v.make in (select make from interested_items where username = '" + userID + "') and v.model in (select model from interested_items where username = '" + userID + "')";
	        PreparedStatement ps = con.prepareStatement(query);
	        ResultSet rs = ps.executeQuery();
	        
	        while(rs.next()){
	        	String make = rs.getString("make");
                String model = rs.getString("model");
                int year = rs.getInt("year");
                Timestamp closeTime = rs.getTimestamp("close_time");	
	     	
			%>
				<tr>
					<td><%= make %></td>
					<td><%= model %></td>
					<td><%= year %></td>
					<td><%= closeTime %></td>
				</tr>
			<%
				}
	        
	            
	            rs.close();
		        ps.close();
		        con.close();

            %>
		</tbody>
	</table>

    <a href='logout.jsp'>Log out</a>
    <br><br>
    <button class="green" onclick="window.location.href='BuyMe.jsp'">Back</button>
</body>
</html>





