
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Best Selling Items</title>
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
<div class="container">
    <h1>Best Selling Items</h1>
<table>
    <thead>
        <tr>
            <th>Make</th>
            <th>Model</th>
            <th>Total Earnings</th>
        </tr>
    </thead>
    <tbody>
        <%
            try {
                // Establish database connection
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");

                // Execute SQL query
                PreparedStatement statement = con.prepareStatement("SELECT v.make, v.model, COALESCE(SUM(a.highest_bid), 0) AS total_earnings FROM vehicles v LEFT JOIN auctions a ON a.VIN = v.VIN AND a.close_time < NOW() GROUP BY v.make, v.model ORDER BY total_earnings DESC");
                ResultSet resultSet = statement.executeQuery();

                // Iterate over the result set and generate table rows
                while (resultSet.next()) {
                    String make = resultSet.getString("make");
                    String model = resultSet.getString("model");
                    float totalEarnings = resultSet.getFloat("total_earnings");
        %>
        <tr>
            <td><%= make %></td>
            <td><%= model %></td>
            <td><%= totalEarnings %></td>
        </tr>
        <%
                }
                // Close database connection
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </tbody>
</table>

    <br>
    <a href='logout.jsp'>Log out</a>
    <br><br>
    <button class="green" onclick="window.location.href='sales_report.jsp'">Back to Sales Reports</button>
</div>
</body>
</html>
