<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Add New User - MusicHub Admin</title>
<link rel="stylesheet" href="./css/register-user.css">
</head>
<body>
	<div class="register-container">
		<div class="register-header">
			<h1>
				MusicHub <span class="admin-badge">ADMIN</span>
			</h1>
			<p>Add New User Account</p>
		</div>

		<c:if test="${param.success != null}">
			<div class="success-message">✅ User registered successfully!</div>
		</c:if>

		<c:if test="${not empty error}">
			<div class="error-message">❌ ${error}</div>
		</c:if>

		<form action="/admin/register-user" method="post">
			<div class="form-group">
				<label for="username">👤 Username</label> <input type="text"
					id="username" name="username" placeholder="Enter username"
					value="${username}" required>
			</div>

			<div class="form-group">
				<label for="email">📧 Email</label> <input type="email" id="email"
					name="email" placeholder="Enter email" value="${email}" required>
			</div>

			<div class="form-group">
				<label for="password">🔒 Password</label> <input type="password"
					id="password" name="password" placeholder="Create a password"
					required>
			</div>

			<div class="form-group">
				<label for="firstName">👤 First Name</label> <input type="text"
					id="firstName" name="firstName" placeholder="First name"
					value="${firstName}" required>
			</div>

			<div class="form-group">
				<label for="lastName">👤 Last Name</label> <input type="text"
					id="lastName" name="lastName" placeholder="Last name"
					value="${lastName}" required>
			</div>

			<div class="form-group">
				<label for="bio">📝 Bio (Optional - for Artists)</label>
				<textarea id="bio" name="bio"
					placeholder="Brief description about the user (especially for artists)...">${bio}</textarea>
			</div>

			<div class="form-group">
				<label for="userType">🎭 User Type</label> <select id="userType"
					name="userType" required>
					<option value="REGULAR">Regular User</option>
					<option value="ARTIST">Artist</option>
				</select>
			</div>

			<button type="submit">👤 Add User</button>
		</form>

		<a href="/users" class="bottom-link">← Back to All Users</a> <a
			href="<c:url value='/'/>" class="back-link">← Back to Dashboard</a>
	</div>
</body>
</html>