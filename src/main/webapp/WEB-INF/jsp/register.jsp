<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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

		<form:form action="/register" method="post" modelAttribute="userDTO">
			<div class="form-group">
				<form:label path="username">Username</form:label>
				<form:input path="username" placeholder="Choose your username" required="true"/>
				<form:errors path="username" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="email">Email</form:label>
				<form:input path="email" type="email" placeholder="Enter your email" required="true"/>
				<form:errors path="email" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="firstName">First Name</form:label>
				<form:input path="firstName" placeholder="Your first name" required="true"/>
				<form:errors path="firstName" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="lastName">Last Name</form:label>
				<form:input path="lastName" placeholder="Your last name" required="true"/>
				<form:errors path="lastName" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="password">Password</form:label>
				<form:password path="password" placeholder="Create a password" required="true"/>
				<form:errors path="password" cssClass="error" />
			</div>

			<button type="submit">Create Account</button>
		</form:form>

		<a href="<c:url value='/'/>" class="back-link">Back to MusicHub</a>

		<div class="login-prompt">
			<span class="login-text">Already have an account? </span>
			<a href="<c:url value='/login'/>" class="login-link">Login here</a>
		</div>
	</div>
</body>
</html>