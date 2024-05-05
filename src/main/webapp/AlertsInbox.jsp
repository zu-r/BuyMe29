<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Alerts</title>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
    }
    th, td {
        padding: 8px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    th {
        background-color: #f2f2f2;
    }
    .back-button {
        background-color: #007bff;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 20px;
    }
    .back-button:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>

<h2>User Alerts</h2>

<table>
    <thead>
        <tr>
            <th>Message</th>
            <th>Time</th>
        </tr>
    </thead>
    <tbody>
        <% 
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");

                PreparedStatement stmt = con.prepareStatement("SELECT * FROM alert_inbox WHERE username = ? order by time desc");
                stmt.setString(1, (String) session.getAttribute("user"));
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String message = rs.getString("message");
                    Timestamp time = rs.getTimestamp("time");
        %>
                    <tr>
                        <td><%= message %></td>
                        <td><%= time %></td>
                    </tr>
        <%
                }
                rs.close();
                stmt.close();
                con.close();
            } catch (Exception e) {
                out.println("Error retrieving alerts: " + e.getMessage());
                e.printStackTrace();
            }
        %>
    </tbody>
</table>

<button class="back-button" onclick="goBack()">Back</button>

<script>
    function goBack() {
        window.history.back();
    }
</script>

</body>
</html>
