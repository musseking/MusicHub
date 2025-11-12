<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Register New Artist - MusicHub</title>
<link rel="stylesheet" href="./css/register-artist.css">
</head>
<body>
	<div class="register-container">
		<div class="register-header">
			<h1>
				MusicHub <span class="admin-badge">ADMIN</span>
			</h1>
			<p>Register New Artist Account</p>
		</div>

		<c:if test="${param.success != null}">
			<div class="success-message">✅ Artist registered successfully!
			</div>
		</c:if>

		<c:if test="${not empty error}">
			<div class="error-message">❌ ${error}</div>
		</c:if>

		<form action="/admin/register-artist" method="post">
			<div class="form-group">
				<label for="username">🎤 Artist Username</label> <input type="text"
					id="username" name="username" placeholder="Enter artist username"
					value="${username}" required>
			</div>

			<div class="form-group">
				<label for="email">📧 Email</label> <input type="email" id="email"
					name="email" placeholder="Enter artist email" value="${email}"
					required>
			</div>

			<div class="form-group">
				<label for="password">🔒 Password</label> <input type="password"
					id="password" name="password" placeholder="Create a password"
					required>
			</div>

			<div class="form-group">
				<label for="firstName">👤 First Name</label> <input type="text"
					id="firstName" name="firstName" placeholder="Artist first name"
					value="${firstName}" required>
			</div>

			<div class="form-group">
				<label for="lastName">👤 Last Name</label> <input type="text"
					id="lastName" name="lastName" placeholder="Artist last name"
					value="${lastName}" required>
			</div>

			<div class="form-group">
				<label for="bio">📝 Artist Bio (Optional)</label>
				<textarea id="bio" name="bio"
					placeholder="Brief description about the artist...">${bio}</textarea>
			</div>

			<button type="submit">🎵 Register Artist</button>
		</form>

		<a href="/admin/users" class="bottom-link">← Back to All Users</a> <a
			href="<c:url value='/'/>" class="back-link">← Back to Dashboard</a>
	</div>
</body>
</html>