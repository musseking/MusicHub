<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<title>MusicHub - Share & Discover Music</title>
<link rel="stylesheet" href="./css/index.css">
<script src="./scripts/index.js"></script>
</head>
<body data-logged-in="${isLoggedIn}">
	<header>
		<h1>🎧 MusicHub</h1>
		<div class="user-display">
			<div class="search-container">
				<input type="text" class="search-input"
					placeholder="Search songs, artists, or genres..." id="searchInput">
			</div>

			<c:choose>
				<c:when test="${isLoggedIn}">
					<div class="user-info-container">
						<div class="username">${displayName}</div>
						<div class="user-role-badge ${loggedUserRole.toLowerCase()}">
							${loggedDisplayRole}</div>
					</div>

					<!-- REPORTS DROPDOWN -->
					<div class="reports-dropdown">
						<a href="/reports/song-ratings" class="report-link">🏆</a>

						<c:if test="${isAdmin}">
							<hr style="margin: 5px 0; border-color: #ccc;">
							<a href="/reports/admin/users" class="report-link admin">📊
								Izveštaj korisnika</a>
							<a href="/reports/admin/song-ratings" class="report-link admin">📈
								Kompletan izveštaj ocena</a>
						</c:if>
					</div>

					<a href="/messages" class="show-users-btn"
						style="margin-right: 0.5rem;">📨<c:if
							test="${unreadCount > 0}">
							<span
								style="background: #ff4757; color: white; border-radius: 50%; padding: 0.2rem 0.5rem; font-size: 0.7rem; margin-left: 0.3rem;">
								${unreadCount} </span>
						</c:if>
					</a>

					<div class="admin-buttons">
						<a href="/users" class="show-users-btn">👥</a>
						<form action="/logout" method="post"
							style="display: inline; margin: 0;">
							<button type="submit" class="logout-btn">Logout</button>
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}" />
						</form>
					</div>
				</c:when>

				<c:otherwise>
					<div class="user-info-container">
						<div class="username">Guest User</div>
						<div class="user-role-badge not-registered">Not Registered</div>
					</div>
					<div class="guest-buttons">
						<a href="/login" class="login-btn">Login</a> <a href="/register"
							class="register-btn">Register</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</header>

	<main>
		<h2 id="pageTitle">Featured Tracks</h2>
		<div class="search-info" id="searchInfo" style="display: none;"></div>

		<div class="song-grid" id="songGrid">
			<c:forEach var="song" items="${songs}">
				<div class="song-tile" data-title="${song.title}"
					data-artist="${song.artist.fullName}"
					data-genre="${song.genre.name}">
					<c:choose>
						<c:when test="${not empty song.coverImage}">
							<img src="${song.coverImage}" alt="${song.title}"
								class="song-image">
						</c:when>
						<c:otherwise>
							<div class="song-image"
								style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem;">
								🎵</div>
						</c:otherwise>
					</c:choose>

					<div class="song-content">
						<div class="song-title">${song.title}</div>

						<div class="song-meta artist-meta-container">
							<span class="song-meta-icon">🎤</span>
							<div class="artist-name-container"
								data-artist-id=${song.artist.id}>
								<span class="artist-name"> ${song.artist.fullName} </span>

								<div class="artist-dropdown"
									id="dropdown-<c:out value='${song.artist.id}'/>"
									style="display: none;">
									<button class="follow-btn" data-artist-id="${song.artist.id}">Follow</button>
									<button class="message-btn" data-artist-id="${song.artist.id}"
										data-artist-name="${fn:escapeXml(song.artist.fullName)}">💌
										Message</button>
								</div>
							</div>
						</div>

						<div class="song-meta">
							<span class="song-meta-icon">🎵</span> <span>${song.genre.name}</span>
						</div>

						<c:if test="${song.album != null}">
							<div class="song-meta">
								<span class="song-meta-icon">📀</span> <span>${song.album.title}</span>
							</div>
						</c:if>

						<div class="song-meta">
							<span class="song-meta-icon">⏱️</span> <span>${song.duration}
								sec</span>
						</div>

						<!-- Rating Section -->
						<div class="rating-section">
							<div class="rating-stars" data-song-id="${song.id}">
								<span class="star" data-rating="1" title="1 star - Poor">★</span>
								<span class="star" data-rating="2" title="2 stars - Fair">★</span>
								<span class="star" data-rating="3" title="3 stars - Good">★</span>
								<span class="star" data-rating="4" title="4 stars - Very Good">★</span>
								<span class="star" data-rating="5" title="5 stars - Excellent">★</span>
							</div>
							<div class="rating-info">
								<span class="average-rating">Not rated yet</span> <span
									class="rating-count">(0 ratings)</span> <span
									class="user-rating-badge" style="display: none;">Your
									rating: <span class="user-rating-value">0</span>
								</span>
							</div>
						</div>

						<div class="download-section">
							<div class="audio-player" data-song-id="${song.id}"
								data-duration="${song.duration}">
								<div class="player-controls">
									<button class="play-pause-btn" type="button">
										<span class="play-icon">▶</span> <span class="pause-icon"
											style="display: none;">❚❚</span>
									</button>

									<div class="progress-container">
										<div class="progress-bar">
											<div class="progress"></div>
											<div class="progress-handle"></div>
										</div>
										<div class="time-display">
											<span class="current-time">0:00</span> <span class="duration">/${song.duration}
												sec</span>
										</div>
									</div>
								</div>

								<c:choose>
									<c:when test="${song.allowDownload}">
										<c:choose>
											<c:when test="${isLoggedIn}">
												<a href="/api/download/${song.id}" class="download-link"
													data-song-title="${song.title}"
													data-song-artist="${song.artist.fullName}"> <span>📥</span>
													<span>Download</span>
												</a>
											</c:when>
											<c:otherwise>
												<span class="register-prompt">Register to Download</span>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<span class="download-unavailable">No Download</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</main>
</body>
</html>