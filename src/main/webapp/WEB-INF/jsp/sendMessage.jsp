<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>${title}</title>
<link rel="stylesheet" href="./css/sendMessage.css">

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

	<main class="message-container">
		<h2>💌 Send Message</h2>

		<c:if test="${param.success != null}">
			<div class="success-message">
				✅ Message sent successfully!
				<div style="margin-top: 0.5rem;">
					<a
						href="/send-message?artistId=${param.artistId}&artistName=${param.artistName}"
						style="color: #4CAF50; font-weight: bold;">Send another
						message</a> or <a href="/" style="color: #4CAF50; font-weight: bold;">return
						to site</a>
				</div>
			</div>
		</c:if>

		<c:if test="${not empty error}">
			<div class="error-message">❌ ${error}</div>
		</c:if>

		<div class="recipient-info">
			<strong>To:</strong> ${artistName}
		</div>

		<form action="/send-message" method="post">
			<input type="hidden" name="artistId" value="${artistId}"> <input
				type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

			<div class="form-group">
				<label for="subject">Subject</label> <input type="text" id="subject"
					name="subject" value="${subject}"
					placeholder="Enter message subject" required>
			</div>

			<div class="form-group">
				<label for="content">Message</label>
				<textarea id="content" name="content"
					placeholder="Write your message here..." required>${content}</textarea>
			</div>

			<div class="btn-group">
				<a href="/" class="cancel-btn">Cancel</a>
				<button type="submit" class="send-btn">Send Message</button>
			</div>
		</form>
	</main>
</body>
</html>