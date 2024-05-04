<%@ page import ="java.sql.*" %>
<%
String selectedRepId = request.getParameter("repId");

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29","root", "password");

if (selectedRepId != null && !selectedRepId.isEmpty()) {
    // Delete the selected representative from the database
    PreparedStatement deleteStatement = con.prepareStatement("DELETE FROM users WHERE username = ?");
    deleteStatement.setString(1, selectedRepId);
    int rowsAffected = deleteStatement.executeUpdate();
    if (rowsAffected > 0) {
        out.println("<script>alert('User with ID: " + selectedRepId + " deleted successfully.');</script>");
    } else {
        out.println("<script>alert('Failed to delete User with ID: " + selectedRepId + ".');</script>");
    }
}

Statement st1 = con.createStatement();
ResultSet rs1 = st1.executeQuery("SELECT username FROM users WHERE account_type = 'user'");

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
        <h1>Delete a User</h1>
        <a href='logout.jsp'>Log out</a>
        <a href='customer_rep.jsp'>Back</a>
        <form action="delete_user.jsp" method="post">
            <select name="repId">
                <% while (rs1.next()) { %>
                    <option value="<%= rs1.getString("username") %>"><%= rs1.getString("username") %></option>
                <% } %>
            </select>
            <button type="submit">Delete User</button>
        </form>
    </div>
</body>
</html>