<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Login - MusicHub</title>
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

.login-container {
	max-width: 400px;
	width: 90%;
	padding: 2rem;
	background: rgba(255, 255, 255, 0.1);
	border-radius: 15px;
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.2);
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.login-header {
	text-align: center;
	margin-bottom: 2rem;
}

.login-header h1 {
	margin: 0;
	font-size: 2rem;
}

.login-header p {
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

input {
	width: 100%;
	padding: 1rem;
	border: none;
	border-radius: 8px;
	background: rgba(255, 255, 255, 0.9);
	font-size: 1rem;
	box-sizing: border-box;
}

input:focus {
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

.error-message {
	background: rgba(255, 107, 107, 0.2);
	color: #ff6b6b;
	padding: 1rem;
	border-radius: 8px;
	margin-bottom: 1rem;
	text-align: center;
	border: 1px solid rgba(255, 107, 107, 0.5);
}
</style>
</head>
<body>
	<div class="login-container">
		<div class="login-header">
			<h1>🎧 MusicHub</h1>
			<p>DJ Portal Access</p>
		</div>

		<c:if test="${param.error != null}">
			<c:choose>
				<c:when test="${not empty sessionScope.LOGIN_ERROR_MESSAGE}">
					<div class="error-message">${sessionScope.LOGIN_ERROR_MESSAGE}</div>
					<c:remove var="LOGIN_ERROR_MESSAGE" scope="session"/>
				</c:when>
				<c:otherwise>
					<div class="error-message">🔐 Invalid username or password</div>
				</c:otherwise>
			</c:choose>
		</c:if>

		<form action="<c:url value='/login'/>" method="post">
			<div class="form-group">
				<label for="username">🎤 Username</label> 
				<input type="text" id="username" name="username" 
					placeholder="Enter your username" required autofocus>
			</div>

			<div class="form-group">
				<label for="password">🔒 Password</label> 
				<input type="password" id="password" name="password" 
					placeholder="Enter your password" required>
			</div>

			<button type="submit">🎵 Sign In</button>
		</form>

		<a href="<c:url value='/'/>" class="back-link">← Back to Music</a>
	</div>
</body>
</html>