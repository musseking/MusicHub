<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.net.URLEncoder"%>
<html>
<head>
<title>${title}</title>
<link rel="stylesheet" href="./css/messages.css">
</head>
<body>
	<header>
		<h1>🎧 MusicHub</h1>
		<div>
			<a href="/" class="back-link">← Back to Site</a>
			<form action="/logout" method="post" style="display: inline;">
				<button type="submit"
					style="background: #ff4757; color: white; border: none; padding: 0.5rem 1rem; border-radius: 20px; cursor: pointer; font-weight: bold;">Logout</button>
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
			</form>
		</div>
	</header>

	<main class="messages-container">
		<div class="messages-header">
			<h2>📨 My Messages</h2>
			<div class="stats">
				<div class="stat-item">
					<span class="stat-number">${totalCount}</span> <span
						class="stat-label">Total Messages</span>
				</div>
				<div class="stat-item">
					<span class="stat-number">${unreadCount}</span> <span
						class="stat-label">Unread</span>
				</div>
			</div>
		</div>

		<c:if test="${param.marked != null}">
			<div class="success-message">✅ Message marked as read!</div>
		</c:if>

		<c:if test="${param.deleted != null}">
			<div class="success-message">✅ Message deleted successfully!</div>
		</c:if>

		<div class="message-list">
			<c:choose>
				<c:when test="${not empty messages}">
					<c:forEach var="message" items="${messages}">
						<div class="message-item ${message.isRead ? '' : 'unread'}">
							<div class="message-header">
								<div class="message-sender">From:
									${message.sender.fullName} (@${message.sender.username})</div>
								<div class="message-date">
									${message.createdAt.toLocalDate()} at
									${message.createdAt.toLocalTime()}</div>
							</div>

							<div class="message-subject">${message.subject}</div>

							<div class="message-content">${message.content}</div>

							<div class="message-actions">
								<c:if test="${not message.isRead}">
									<form action="/messages/${message.id}/read" method="post"
										style="display: inline;">
										<button type="submit" class="action-btn read-btn">Mark
											as Read</button>
										<input type="hidden" name="${_csrf.parameterName}"
											value="${_csrf.token}" />
									</form>
								</c:if>
								<a
									href="/send-message?artistId=${message.sender.id}&artistName=${message.sender.fullName}&subject=Re: ${message.subject}"
									class="action-btn reply-btn">Reply</a>
								<form action="/messages/${message.id}/delete" method="post"
									style="display: inline;">
									<button type="submit" class="action-btn delete-btn"
										onclick="return confirm('Are you sure you want to delete this message?')">Delete</button>
									<input type="hidden" name="${_csrf.parameterName}"
										value="${_csrf.token}" />
								</form>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="no-messages">
						<div style="font-size: 4rem; margin-bottom: 1rem;">📭</div>
						<div style="font-size: 1.2rem;">No messages yet</div>
						<div style="margin-top: 0.5rem;">Your messages will appear
							here when you receive them.</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>
</body>
</html>