<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class Invitation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }

        a {
            color: #fff;
        }

        .container {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .app-links {
            margin-top: 20px;
            text-align: center;
        }

        .app-link {
            display: inline-block;
            margin: 10px;
            padding: 10px;
            border-radius: 5px;
            background-color: #fff;
            color: white;
            text-decoration: none;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>You're Invited!</h1>
        <p>Hello!</p>
        <p>You have been invited to join a class. Please use the following class code to join:</p>
        <strong>{{ $classCode }}</strong>
        <p>We look forward to having you with us!</p>
        <div class="app-links">
            <p>Download our app Studify to enhance your learning experience:</p>
            <a href="https://play.google.com/store/apps/details?id=com.studify" class="app-link">Google Play</a>
            <a href="https://apps.apple.com/app/studify" class="app-link apple">App Store</a>
        </div>
    </div>
</body>

</html>