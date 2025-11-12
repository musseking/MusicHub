<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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
			<div class="success-message">User registered successfully!</div>
		</c:if>

		<c:if test="${not empty error}">
			<div class="error-message">${error}</div>
		</c:if>

		<form:form action="/admin/register-user" method="post" modelAttribute="userDTO">
			<input type="hidden" name="userType" value="${userType}"/>
			<input type="hidden" name="bio" value="${bio}"/>
			
			<div class="form-group">
				<form:label path="username">Username</form:label>
				<form:input path="username" placeholder="Enter username" required="true"/>
				<form:errors path="username" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="email">Email</form:label>
				<form:input path="email" type="email" placeholder="Enter email" required="true"/>
				<form:errors path="email" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="password">Password</form:label>
				<form:password path="password" placeholder="Create a password" required="true"/>
				<form:errors path="password" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="firstName">First Name</form:label>
				<form:input path="firstName" placeholder="First name" required="true"/>
				<form:errors path="firstName" cssClass="error" />
			</div>

			<div class="form-group">
				<form:label path="lastName">Last Name</form:label>
				<form:input path="lastName" placeholder="Last name" required="true"/>
				<form:errors path="lastName" cssClass="error" />
			</div>

			<div class="form-group">
				<label for="bio">Bio (Optional - for Artists)</label>
				<textarea id="bio" name="bio" placeholder="Brief description about the user (especially for artists)...">${bio}</textarea>
			</div>

			<div class="form-group">
				<label for="userType">User Type</label>
				<select id="userType" name="userType" required>
					<option value="REGULAR">Regular User</option>
					<option value="ARTIST">Artist</option>
				</select>
			</div>

			<button type="submit">Add User</button>
		</form:form>

		<a href="/users" class="bottom-link">Back to All Users</a>
		<a href="<c:url value='/'/>" class="back-link">Back to Dashboard</a>
	</div>
</body>
</html>