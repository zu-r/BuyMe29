<!DOCTYPE html>
<html>
<head>
    <title>Login Form</title>
    <style>
        .form-container {
            margin-bottom: 20px; /* Add space between the forms */
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Log In:</h2>
        <form action="checkLoginDetails.jsp" method="POST">
            Username: <input type="text" name="username"/> <br/>
            Password: <input type="password" name="password"/> <br/>
            <input type="submit" value="Login"/>
        </form>
    </div>
    <div class="form-container" style="margin-top: 20px;"> <!-- Add margin-top to create space -->
        <h2>Create Account:</h2>
        <form action="createAccount.jsp" method="POST">
            New Username: <input type="text" name="new username"/> <br/>
            New Password: <input type="password" name="new password"/> <br/>
            <input type="submit" value="Create Account"/>
        </form>
    </div>
</body>
</html>