<!DOCTYPE html>
<html>
<head>
    <title>Manage Customer Representatives</title>
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
        <h1>Manage Customer Representatives</h1>
        <a href='logout.jsp'>Log out</a>
        <br><br>
        <button onclick="window.location.href='delete_representative.jsp'">Delete a Representative</button>
        <button onclick="window.location.href='create_representative.jsp'">Create a Representative</button>
        <button class="green" onclick="window.location.href='admin.jsp'">Back to Admin Homepage</button>
    </div>
</body>
</html>
