<!DOCTYPE html>
<html>
<head>
    <title>Help Requests</title>
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
        button.red {
		    background-color: #dc3545;
		}
		
		button.red:hover {
		    background-color: #c82333;
		}
    </style>
</head>
<body>
<div class="container">
    <h1>Help Requests</h1>

    <table>
        <thead>
            <tr>
                <th>Username</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Problem</th>
                <th>Resolved</th>
                <th>Time</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <!-- Retrieve and display help requests here -->
            <%@ page import="java.sql.*" %>
            <% 
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");
                    PreparedStatement helpRequests = con.prepareStatement("SELECT * FROM help_requests");
                    ResultSet helpResults = helpRequests.executeQuery();
                    while (helpResults.next()) {
                        String username = helpResults.getString("username");
                        String phone = helpResults.getString("phone");
                        String email = helpResults.getString("email");
                        String problem = helpResults.getString("problem");
                        boolean resolved = helpResults.getBoolean("resolved");
                        Timestamp time = helpResults.getTimestamp("time");
            %>
            <tr>
                <td><%= username %></td>
                <td><%= phone %></td>
                <td><%= email %></td>
                <td><%= problem %></td>
                <td><%= resolved %></td>
                <td><%= time %></td>
                <td>
                    <form action="toggleResolved.jsp" method="post">
                        <input type="hidden" name="username" value="<%= username %>">
                        <input type="hidden" name="resolved" value="<%= resolved %>">
                        <input type="hidden" name="time" value="<%= time %>">
						<button type="submit" class="green">
						    <%= resolved ? "Unresolve" : "Resolve" %>
						</button>

                    </form>
                </td>
            </tr>
            <% 
                    }
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
    <button class="green" onclick="window.location.href='customer_rep.jsp'">Back</button>
</div>
</body>
</html>
