<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help Request Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 400px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            font-weight: bold;
            margin-bottom: 5px;
        }
        input[type="text"],
        input[type="email"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            resize: none;
        }
        textarea {
            height: 100px;
        }
        input[type="submit"],
        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover,
        button:hover {
            background-color: #0056b3;
        }
        button {
            margin-top: 10px;
            background-color: #dc3545;
        }
        button:hover {
            background-color: #c82333;
        }
    </style>
    
    
</head>
<body>



<div class="container">


    <h2>Help Request Form</h2>

    <form action="" method="post">
        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone" required>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
        
        <label for="problem">Problem:</label>
        <textarea id="problem" name="problem" rows="4" cols="50" required></textarea>
        
        <input type="submit" value="Submit">
    </form>

    <button onclick="window.location.href = 'BuyMe.jsp'">Back</button>
</div>

<%
if (request.getMethod().equalsIgnoreCase("post")) {
    String username = (String) session.getAttribute("user"); // You need to replace this with actual username retrieval logic
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String problem = request.getParameter("problem");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyMe29", "root", "password");

        PreparedStatement insertStmt = con.prepareStatement("INSERT INTO help_requests (username, phone, email, problem, resolved, time) VALUES (?, ?, ?, ?, false, NOW())");
        insertStmt.setString(1, username);
        insertStmt.setString(2, phone);
        insertStmt.setString(3, email);
        insertStmt.setString(4, problem);
        insertStmt.executeUpdate();

        out.println("Help request submitted successfully.");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An error occurred while processing your request. Please try again later.");
    }
}
%>

</body>
</html>