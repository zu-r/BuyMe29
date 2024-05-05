<!DOCTYPE html>
<html>
<head>
    <title>Login Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            text-align: center;
        }
        h1 {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: rgb(255, 149, 36);
            margin-bottom: 20px;
        }
        .form-container {
            display: inline-block;
            width: 300px;
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: rgb(255, 149, 36);
            margin-bottom: 20px;
        }
        input[type="text"],
        input[type="password"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            width: calc(100% - 20px);
            padding: 12px;
            border: none;
            background-color: rgb(255, 149, 36);
            color: #fff;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: rgb(255, 119, 0);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>BuyMe</h1>
        <div class="form-container">
            <h2>Log In:</h2>
            <form action="checkLoginDetails.jsp" method="POST">
                <label for="username">Username:</label><br>
                <input type="text" id="username" name="username"/><br>
                <label for="password">Password:</label><br>
                <input type="password" id="password" name="password"/><br>
                <input type="submit" value="Login"/>
            </form>
        </div>
        <div class="form-container">
            <h2>Create Account:</h2>
            <form action="createAccount.jsp" method="POST">
                <label for="newUsername">New Username:</label><br>
                <input type="text" id="newUsername" name="newUsername"/><br>
                <label for="newPassword">New Password:</label><br>
                <input type="password" id="newPassword" name="newPassword"/><br>
                <input type="submit" value="Create Account"/>
            </form>
        </div>
    </div>
</body>
</html>
