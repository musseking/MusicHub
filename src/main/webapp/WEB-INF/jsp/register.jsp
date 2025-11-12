<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Register - MusicHub</title>
<link rel="stylesheet" href="./css/register.css">
</head>
<body>
	<div class="register-container">
		<div class="register-header">
			<h1>MusicHub</h1>
			<p>Join Our Music Community</p>
		</div>

		<div class="feature-list">
			<h4>🎵 Register to Unlock:</h4>
			<ul>
				<li>📥 Download full music tracks</li>
				<li>🎧 Unlimited streaming</li>
				<li>❤️ Create personal playlists</li>
				<li>👤 Follow your favorite artists</li>
				<li>💬 Comment and rate songs</li>
			</ul>
		</div>

		<form action="/register" method="post">
			<div class="form-group">
				<label for="username">👤 Username</label> <input type="text"
					id="username" name="username" placeholder="Choose your username"
					required autofocus>
			</div>

			<div class="form-group">
				<label for="email">📧 Email</label> <input type="email" id="email"
					name="email" placeholder="Enter your email" required>
			</div>

			<div class="form-group">
				<label for="firstName">👤 First Name</label> <input type="text"
					id="firstName" name="firstName" placeholder="Your first name"
					required>
			</div>

			<div class="form-group">
				<label for="lastName">👤 Last Name</label> <input type="text"
					id="lastName" name="lastName" placeholder="Your last name" required>
			</div>

			<div class="form-group">
				<label for="password">🔒 Password</label> <input type="password"
					id="password" name="password" placeholder="Create a password"
					required>
			</div>

			<button type="submit">🎵 Create Account</button>
		</form>

		<a href="<c:url value='/'/>" class="back-link">← Back to MusicHub</a>

		<div class="login-prompt">
			<span class="login-text">Already have an account? </span> <a
				href="<c:url value='/login'/>" class="login-link">Login here</a>
		</div>
	</div>
</body>
</html>