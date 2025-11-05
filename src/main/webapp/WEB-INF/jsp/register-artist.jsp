<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Register New Artist - MusicHub</title>
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
	max-width: 500px;
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

input, textarea, select {
	width: 100%;
	padding: 1rem;
	border: none;
	border-radius: 8px;
	background: rgba(255, 255, 255, 0.9);
	font-size: 1rem;
	box-sizing: border-box;
	font-family: Arial, sans-serif;
}

textarea {
	height: 100px;
	resize: vertical;
}

input:focus, textarea:focus, select:focus {
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

.success-message {
	background: rgba(76, 175, 80, 0.2);
	color: #4CAF50;
	padding: 1rem;
	border-radius: 8px;
	margin-bottom: 1rem;
	text-align: center;
	border: 1px solid rgba(76, 175, 80, 0.5);
}

.error-message {
	background: rgba(255, 107, 107, 0.2);
	color: #ff6b6b;
	padding: 1rem;
	border-radius: 8px;
	margin-bottom: 1rem;
	text-align: center;
	border: 1px solid rgba(255, 107, 107, 0.5);
}

.admin-badge {
	background: #ff4757;
	color: white;
	padding: 0.3rem 0.8rem;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: bold;
	display: inline-block;
	margin-left: 0.5rem;
}
</style>
</head>
<body>
	<div class="register-container">
		<div class="register-header">
			<h1>🎧 MusicHub <span class="admin-badge">ADMIN</span></h1>
			<p>Register New Artist Account</p>
		</div>

		<c:if test="${param.success != null}">
			<div class="success-message">
				✅ Artist registered successfully!
			</div>
		</c:if>

		<c:if test="${not empty error}">
			<div class="error-message">
				❌ ${error}
			</div>
		</c:if>

		<form action="/admin/register-artist" method="post">
			<div class="form-group">
				<label for="username">🎤 Artist Username</label> 
				<input type="text" id="username" name="username" 
					placeholder="Enter artist username" value="${username}" required>
			</div>

			<div class="form-group">
				<label for="email">📧 Email</label> 
				<input type="email" id="email" name="email" 
					placeholder="Enter artist email" value="${email}" required>
			</div>

			<div class="form-group">
				<label for="password">🔒 Password</label> 
				<input type="password" id="password" name="password" 
					placeholder="Create a password" required>
			</div>

			<div class="form-group">
				<label for="firstName">👤 First Name</label> 
				<input type="text" id="firstName" name="firstName" 
					placeholder="Artist first name" value="${firstName}" required>
			</div>

			<div class="form-group">
				<label for="lastName">👤 Last Name</label> 
				<input type="text" id="lastName" name="lastName" 
					placeholder="Artist last name" value="${lastName}" required>
			</div>

			<div class="form-group">
				<label for="bio">📝 Artist Bio (Optional)</label> 
				<textarea id="bio" name="bio" 
					placeholder="Brief description about the artist...">${bio}</textarea>
			</div>

			<button type="submit">🎵 Register Artist</button>
		</form>
		
		<a href="/admin/users" class="bottom-link">← Back to All Users</a>
		<a href="<c:url value='/'/>" class="back-link">← Back to Dashboard</a>
	</div>
</body>
</html>