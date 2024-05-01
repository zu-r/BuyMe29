<!DOCTYPE html>
<html>
<head>
    <title>Create a New Customer Representative</title>
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
        }
        h2 {
            text-align: center;
            color: #333;
        }
        a {
            text-decoration: none;
            color: #007bff;
            margin-bottom: 10px;
            display: block;
            text-align: center;
        }
        a:hover {
            text-decoration: underline;
        }
        form {
            margin-top: 20px;
            text-align: center;
        }
        label {
            display: inline-block;
            text-align: left;
            width: 30%;
            margin-right: 10px;
        }
        input[type="text"],
        input[type="password"],
        input[type="submit"] {
            width: 65%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            width: 100%;
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href='logout.jsp'>Log out</a>
        <a href='manage_customer_reps.jsp'>Back</a>
        <h2>Create Customer Representative Account:</h2>
        <div class="form-container">
            <form action="createRepAccount.jsp" method="POST">
                <label for="new-username">New Username:</label>
                <input type="text" id="new-username" name="new-username"/><br>
                <label for="new-password">New Password:</label>
                <input type="password" id="new-password" name="new-password"/><br>
                <input type="submit" value="Create Account"/>
            </form>
        </div>
    </div>
</body>
</html>
