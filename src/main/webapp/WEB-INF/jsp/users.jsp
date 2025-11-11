<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<title>${title}</title>
<link rel="stylesheet" href="./css/users.css">

</head>
<body>
	<header>
		<h1>
			🎧 MusicHub
			<c:if test="${isAdmin}">
				<span
					style="background: #ff4757; color: white; padding: 0.3rem 0.8rem; border-radius: 15px; font-size: 0.8rem; margin-left: 0.5rem;">ADMIN
					PANEL</span>
			</c:if>
		</h1>
		<div>
			<a href="/"
				style="color: #222; text-decoration: none; background: rgba(255, 255, 255, 0.8); padding: 0.5rem 1rem; border-radius: 20px; margin-right: 1rem;">←
				Back to Site</a>
			<form action="/logout" method="post" style="display: inline;">
				<button type="submit"
					style="background: #ff4757; color: white; border: none; padding: 0.5rem 1rem; border-radius: 20px; cursor: pointer; font-weight: bold;">Logout</button>
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
			</form>
		</div>
	</header>

	<main>
		<c:if test="${isAdmin}">
			<div class="admin-nav">
				<a href="/admin/register-user" class="admin-nav-btn primary">👤
					Add New User</a>
			</div>
		</c:if>

		<c:if test="${param.activated != null}">
			<div class="success-message">✅ User activated successfully!</div>
		</c:if>

		<c:if test="${param.deactivated != null}">
			<div class="success-message">✅ User deactivated successfully!</div>
		</c:if>

		<div class="stats-container">
			<div class="stat-card">
				<div class="stat-number">${totalUsers}</div>
				<div class="stat-label">Total Users</div>
			</div>
			<div class="stat-card">
				<div class="stat-number">${totalArtists}</div>
				<div class="stat-label">Artists</div>
			</div>
			<div class="stat-card">
				<div class="stat-number">${totalRegularUsers}</div>
				<div class="stat-label">Regular Users</div>
			</div>
		</div>

		<h2>All Users</h2>

		<table class="users-table">
			<thead>
				<tr>
					<th>ID</th>
					<th>Username</th>
					<th>Name</th>
					<th>Email</th>
					<th>Role</th>
					<th>Status</th>
					<th>Registered</th>
					<c:if test="${isAdmin}">
						<th>Actions</th>
					</c:if>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="user" items="${users}">
					<tr>
						<td>${user.id}</td>
						<td><strong>${user.username}</strong></td>
						<td>${user.firstName}${user.lastName}</td>
						<td>${user.email}</td>
						<td><c:choose>
								<c:when test="${user.isAdmin}">
									<span class="user-role-badge role-admin">Administrator</span>
								</c:when>
								<c:when test="${user.isArtist}">
									<span class="user-role-badge role-artist">Artist</span>
								</c:when>
								<c:otherwise>
									<span class="user-role-badge role-user">Registered User</span>
								</c:otherwise>
							</c:choose></td>
						<td><c:choose>
								<c:when test="${user.isActive}">
									<span class="status-badge status-active">Active</span>
								</c:when>
								<c:otherwise>
									<span class="status-badge status-inactive">Inactive</span>
								</c:otherwise>
							</c:choose></td>
						<td><c:choose>
								<c:when test="${user.createdAt != null}">
									<div class="date-time">
										${fn:substring(user.createdAt.toString(), 0, 10)}
										${fn:substring(user.createdAt.toString(), 11, 19)}</div>
								</c:when>
								<c:otherwise>
									<div class="date-time">N/A</div>
								</c:otherwise>
							</c:choose></td>
						<c:if test="${isAdmin}">
							<td><c:choose>
									<c:when test="${user.isActive && !user.isAdmin}">
										<form action="/admin/users/${user.id}/deactivate"
											method="post" style="display: inline;">
											<button type="submit" class="action-btn deactivate">Deactivate</button>
											<input type="hidden" name="${_csrf.parameterName}"
												value="${_csrf.token}" />
										</form>
									</c:when>
									<c:when test="${!user.isActive && !user.isAdmin}">
										<form action="/admin/users/${user.id}/activate" method="post"
											style="display: inline;">
											<button type="submit" class="action-btn activate">Activate</button>
											<input type="hidden" name="${_csrf.parameterName}"
												value="${_csrf.token}" />
										</form>
									</c:when>
									<c:otherwise>
										<span style="color: #ccc;">No actions</span>
									</c:otherwise>
								</c:choose></td>
						</c:if>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<div class="bottom-nav">
			<a href="/" class="bottom-nav-btn">🏠 Back to Dashboard</a>
		</div>
	</main>
</body>
</html>