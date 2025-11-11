<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Login - MusicHub</title>
<link rel="stylesheet" href="./css/login.css">
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
					<c:remove var="LOGIN_ERROR_MESSAGE" scope="session" />
				</c:when>
				<c:otherwise>
					<div class="error-message">🔐 Invalid username or password</div>
				</c:otherwise>
			</c:choose>
		</c:if>

		<form action="<c:url value='/login'/>" method="post">
			<div class="form-group">
				<label for="username">🎤 Username</label> <input type="text"
					id="username" name="username" placeholder="Enter your username"
					required autofocus>
			</div>

			<div class="form-group">
				<label for="password">🔒 Password</label> <input type="password"
					id="password" name="password" placeholder="Enter your password"
					required>
			</div>

			<button type="submit">🎵 Sign In</button>
		</form>

		<a href="<c:url value='/'/>" class="back-link">← Back to Music</a>
	</div>
</body>
</html>