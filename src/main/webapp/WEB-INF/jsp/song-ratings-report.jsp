<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<title>${title}</title>
<link rel="stylesheet" href="./../css/song-ratings-report.css">

</head>
<body>
	<header>
		<h1>🎧 MusicHub</h1>
		<div class="user-display">
			<div class="user-info-container">
				<div class="username">${displayName}</div>
				<div class="user-role-badge ${loggedUserRole.toLowerCase()}">
					${loggedDisplayRole}</div>
			</div>
			<a href="/" class="back-link">← Back to Site</a>
		</div>
	</header>

	<main class="reports-container">
		<div class="reports-header">
			<h1>📊 Song Ratings Reports</h1>
			<p>View detailed ratings and download comprehensive PDF reports</p>
		</div>

		<!-- Song Ratings Display Section -->
		<div class="reports-section">
			<h2 class="section-title">
				🎵
				<c:choose>
					<c:when test="${isAdmin}">All Songs Ratings</c:when>
					<c:when test="${loggedUserRole == 'ARTIST'}">My Songs & All Ratings</c:when>
					<c:otherwise>Your Rated Songs & All Ratings</c:otherwise>
				</c:choose>
			</h2>

			<c:choose>
				<c:when test="${not empty ratedSongs}">
					<div class="ratings-grid">
						<c:forEach var="song" items="${ratedSongs}">
							<div class="rating-card">
								<div class="rating-header">
									<div class="rating-title">${song.title}</div>
									<div class="rating-artist">by ${song.artist}</div>
									<div class="rating-stats">
										<div class="average-rating">
											<fmt:formatNumber value="${song.averageRating}"
												pattern="#0.0" />
											★
										</div>
										<div class="rating-count">(${song.ratingCount} ratings)
										</div>
									</div>
									<c:if test="${song.userRating > 0}">
										<div class="user-rating">Your rating: ${song.userRating}
											★</div>
									</c:if>
									<c:if
										test="${loggedUserRole == 'ARTIST' && song.artistEntity.id == currentUser.id}">
										<div class="artist-song-badge">Your Song</div>
									</c:if>
								</div>
								<div class="rating-body">
									<div class="rating-details">
										<div class="detail-item">
											<span class="detail-label">Genre:</span> <span
												class="detail-value">${song.genre}</span>
										</div>
										<div class="detail-item">
											<span class="detail-label">Duration:</span> <span
												class="detail-value">${song.duration} sec</span>
										</div>
										<div class="detail-item">
											<span class="detail-label">Plays:</span> <span
												class="detail-value">${song.playCount}</span>
										</div>
										<div class="detail-item">
											<span class="detail-label">Downloads:</span> <span
												class="detail-value">${song.downloadCount}</span>
										</div>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:when>
				<c:otherwise>
					<div class="no-ratings">
						<div style="font-size: 4rem; margin-bottom: 1rem;">🎵</div>
						<div style="font-size: 1.2rem;">No songs available</div>
						<div style="margin-top: 0.5rem;">There are no songs to
							display ratings for.</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- PDF Reports Section -->
		<div class="reports-section">
			<h2 class="section-title">📈 Comprehensive PDF Reports</h2>

			<div class="reports-grid">
				<!-- Report for All Users -->
				<div class="report-card">
					<div class="report-icon">🏆</div>
					<div class="report-card-title">Songs Ranking</div>
					<div class="report-description">Complete ranking of all songs
						on the platform sorted by user ratings. Perfect for discovering
						the most popular tracks.</div>
					<a href="/reports/songs-ranking" class="download-btn"
						target="_blank"> 📥 Download PDF </a>
				</div>

				<!-- Report for Artists -->
				<c:if test="${loggedUserRole == 'ARTIST' || isAdmin}">
					<div class="report-card">
						<div class="artist-badge">FOR ARTISTS</div>
						<div class="report-icon">🎵</div>
						<div class="report-card-title">My Artist Reports</div>
						<div class="report-description">Detailed reports about your
							songs - ratings, ranking, play counts, and downloads. Track your
							music performance.</div>
						<a href="/reports/artist/my-songs" class="download-btn"
							target="_blank"> 📥 Download PDF </a>
					</div>
				</c:if>

				<!-- Admin Reports -->
				<c:if test="${isAdmin}">
					<div class="report-card">
						<div class="admin-badge">ADMIN ONLY</div>
						<div class="report-icon">👥</div>
						<div class="report-card-title">Users Report</div>
						<div class="report-description">Complete overview of all
							platform users - artists, regular users, statistics and
							activities. Monitor community growth.</div>
						<a href="/reports/admin/users" class="download-btn"
							target="_blank"> 📥 Download PDF </a>
					</div>

					<div class="report-card">
						<div class="admin-badge">ADMIN ONLY</div>
						<div class="report-icon">📊</div>
						<div class="report-card-title">Complete Ratings Report</div>
						<div class="report-description">Detailed analysis of all
							ratings on the platform - all songs, average ratings, vote counts
							and comprehensive statistics.</div>
						<a href="/reports/admin/song-ratings" class="download-btn"
							target="_blank"> 📥 Download PDF </a>
					</div>
				</c:if>
			</div>
		</div>

		<!-- Info Section -->
		<div
			style="text-align: center; color: #ccc; margin-top: 2rem; padding: 1.5rem; background: rgba(255, 255, 255, 0.1); border-radius: 10px;">
			<p>
				💡 <strong>Note:</strong> Some reports are available only to artists
				and administrators
			</p>
			<p>🕒 Reports are generated in real-time with the latest data</p>
			<p>📊 All PDF reports include detailed tables and statistics</p>
		</div>
	</main>

	<script>
        // Add loading effects to download buttons
        document.addEventListener('DOMContentLoaded', function() {
            const downloadButtons = document.querySelectorAll('.download-btn');
            
            downloadButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const originalText = this.innerHTML;
                    this.innerHTML = '⏳ Generating...';
                    this.style.opacity = '0.7';
                    this.style.cursor = 'wait';
                    
                    // Reset after 3 seconds if nothing happens
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.style.opacity = '1';
                        this.style.cursor = 'pointer';
                    }, 3000);
                });
            });
        });
    </script>
</body>
</html>