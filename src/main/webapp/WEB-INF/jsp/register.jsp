<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Register - MusicHub</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
	min-height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
}

.register-container {
	max-width: 450px;
	width: 90%;
	padding: 2rem;
	background: rgba(255, 255, 255, 0.1);
	border-radius: 15px;
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.2);
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.register-header {
	text-align: center;
	margin-bottom: 2rem;
}

.register-header h1 {
	margin: 0;
	font-size: 2rem;
}

.register-header p {
	color: #ccc;
	margin: 0.5rem 0 0 0;
}

.form-group {
	margin-bottom: 1.5rem;
}

.form-group label {
	display: block;
	color: white;
	margin-bottom: 0.5rem;
	font-weight: bold;
}

input, select {
	width: 100%;
	padding: 1rem;
	border: none;
	border-radius: 8px;
	background: rgba(255, 255, 255, 0.9);
	font-size: 1rem;
	box-sizing: border-box;
}

input:focus, select:focus {
	outline: none;
	background: white;
	box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.3);
}

button {
	width: 100%;
	padding: 1rem;
	background: #4CAF50;
	color: white;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 1rem;
	font-weight: bold;
	transition: background 0.3s;
}

button:hover {
	background: #45a049;
}

.back-link {
	display: block;
	text-align: center;
	color: #ccc;
	margin-top: 1rem;
	text-decoration: none;
	transition: color 0.3s;
}

.back-link:hover {
	color: white;
}

.feature-list {
	margin: 1.5rem 0;
	padding: 1rem;
	background: rgba(255,255,255,0.1);
	border-radius: 8px;
}

.feature-list h4 {
	margin: 0 0 0.5rem 0;
	color: #4CAF50;
}

.feature-list ul {
	margin: 0;
	padding-left: 1.5rem;
}

.feature-list li {
	margin-bottom: 0.5rem;
}

/* NOVO: Stil za login link sa posebnim hover-om */
.login-prompt {
	text-align: center;
	margin-top: 1rem;
	color: #ccc;
}

.login-link {
	color: #4CAF50;
	text-decoration: none;
	transition: color 0.3s;
	font-weight: bold;
}

.login-link:hover {
	color: #45a049;
	text-decoration: underline;
}

.login-text {
	color: #ccc;
}
</style>
</head>
<body>
	<div class="register-container">
		<div class="register-header">
			<h1>🎧 MusicHub</h1>
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
				<label for="email">📧 Email</label> <input type="email"
					id="email" name="email" placeholder="Enter your email"
					required>
			</div>

			<div class="form-group">
				<label for="firstName">👤 First Name</label> <input type="text"
					id="firstName" name="firstName" placeholder="Your first name"
					required>
			</div>

			<div class="form-group">
				<label for="lastName">👤 Last Name</label> <input type="text"
					id="lastName" name="lastName" placeholder="Your last name"
					required>
			</div>

			<div class="form-group">
				<label for="password">🔒 Password</label> <input type="password"
					id="password" name="password" placeholder="Create a password"
					required>
			</div>

			<button type="submit">🎵 Create Account</button>
		</form>

		<a href="<c:url value='/'/>" class="back-link">← Back to MusicHub</a>
		
		<!-- NOVO: Login prompt sa posebnim hover-om -->
		<div class="login-prompt">
			<span class="login-text">Already have an account? </span>
			<a href="<c:url value='/login'/>" class="login-link">Login here</a>
		</div>
	</div>
</body>
</html>