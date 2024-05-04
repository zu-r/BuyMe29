<!DOCTYPE html>
<html>
<head>
    <title>Welcome Customer Representative</title>
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
        a {
            text-decoration: none;
            color: #007bff;
        }
        a:hover {
            text-decoration: underline;
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
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome, Customer Representative</h1>
        <a href='logout.jsp'>Log out</a>
        <br><br>
        <button onclick="window.location.href='update_user_password.jsp'">Update User Password</button>
        <button onclick="window.location.href='delete_user.jsp'">Delete User</button>
        <button onclick="window.location.href='remove_bid.jsp'">Remove Bid</button>
        <button onclick="window.location.href='remove_auction.jsp'">Remove Auction</button>
        <button onclick="window.location.href='reply_customer.jsp'">View Customer Questions</button>
    </div>
</body>
</html>
