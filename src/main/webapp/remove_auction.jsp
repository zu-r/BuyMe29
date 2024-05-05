<%@ page import ="java.sql.*" %>
<%
String selectedAucId = request.getParameter("aucId");

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");

if (selectedAucId != null && !selectedAucId.isEmpty()) {
    // Delete the selected representative from the database
    PreparedStatement deleteStatement = con.prepareStatement("DELETE FROM auctions WHERE auctionID = ?");
    deleteStatement.setString(1, selectedAucId);
    int rowsAffected = deleteStatement.executeUpdate();
    if (rowsAffected > 0) {
        out.println("<script>alert('Auction with ID: " + selectedAucId + " deleted successfully.');</script>");
    } else {
        out.println("<script>alert('Failed to delete Auction with ID: " + selectedAucId + ".');</script>");
    }
}

Statement st1 = con.createStatement();
ResultSet rs1 = st1.executeQuery("SELECT auctionID FROM auctions order by auctionID");

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
        <h1>Delete an Auction</h1>
        <a href='logout.jsp'>Log out</a>
        <a href='customer_rep.jsp'>Back</a>&nbsp;
        <form action="remove_auction.jsp" method="post">
        	<label for="aucId">AuctionID:</label>
            <select name="aucId">
                <% while (rs1.next()) { %>
                    <option value="<%= rs1.getString("auctionID") %>"><%= rs1.getString("auctionID") %></option>
                <% } %>
            </select>
            <button type="submit">Delete Auction</button>
        </form>
    </div>
</body>
</html>