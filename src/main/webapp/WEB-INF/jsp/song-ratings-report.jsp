<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<title>${title}</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 20px;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
	min-height: 100vh;
}

header {
	background: rgba(240, 240, 240, 0.98);
	padding: 1rem;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-radius: 10px;
	margin-bottom: 2rem;
	color: #222;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	border: 1px solid rgba(255, 255, 255, 0.3);
}

.user-display {
	display: flex;
	align-items: center;
	gap: 1rem;
}

.user-info-container {
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-right: 1rem;
}

.username {
	font-weight: bold;
	font-size: 1.1rem;
	text-align: center;
	white-space: nowrap;
	margin: 0;
	color: #222;
}

.user-role-badge {
	padding: 0.4rem 1rem;
	border-radius: 20px;
	font-size: 0.85rem;
	font-weight: bold;
	text-align: center;
	min-width: 120px;
	box-sizing: border-box;
	margin-top: 0.3rem;
	color: white;
}

.user-role-badge.admin {
	background: #ff4757 !important;
}

.user-role-badge.artist {
	background: #4CAF50;
}

.user-role-badge.user {
	background: #3742fa;
}

.back-link {
	color: #222;
	text-decoration: none;
	background: rgba(255, 255, 255, 0.8);
	padding: 0.5rem 1rem;
	border-radius: 20px;
	margin-right: 1rem;
	transition: all 0.3s ease;
	font-weight: bold;
}

.back-link:hover {
	background: rgba(255, 255, 255, 1);
	transform: translateY(-2px);
	text-decoration: none;
	color: #222;
}

.reports-container {
	max-width: 1200px;
	margin: 0 auto;
}

.reports-header {
	text-align: center;
	margin-bottom: 2rem;
}

.reports-header h1 {
	font-size: 2.5rem;
	margin-bottom: 0.5rem;
	text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.reports-header p {
	font-size: 1.2rem;
	color: #e0e0e0;
	margin-bottom: 0;
}

.ratings-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 1.5rem;
	margin-bottom: 3rem;
}

.rating-card {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 12px;
	overflow: hidden;
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.2);
	transition: all 0.3s ease;
}

.rating-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
	background: rgba(255, 255, 255, 0.15);
}

.rating-header {
	background: rgba(255, 255, 255, 0.2);
	padding: 1rem;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.rating-title {
	font-size: 1.2rem;
	font-weight: bold;
	margin-bottom: 0.5rem;
	color: #4CAF50;
}

.rating-artist {
	color: #ccc;
	font-size: 0.9rem;
	margin-bottom: 0.5rem;
}

.rating-stats {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 0.5rem;
}

.average-rating {
	font-size: 1.5rem;
	font-weight: bold;
	color: #ffc107;
}

.rating-count {
	color: #ccc;
	font-size: 0.9rem;
}

.rating-body {
	padding: 1rem;
}

.rating-details {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 0.5rem;
	margin-bottom: 1rem;
}

.detail-item {
	display: flex;
	justify-content: space-between;
	padding: 0.3rem 0;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.detail-label {
	color: #ccc;
	font-size: 0.85rem;
}

.detail-value {
	font-weight: bold;
	font-size: 0.85rem;
}

.user-rating {
	background: rgba(255, 193, 7, 0.2);
	color: #ffc107;
	padding: 0.3rem 0.8rem;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: bold;
	display: inline-block;
	margin-top: 0.5rem;
}

.artist-song-badge {
	background: rgba(76, 175, 80, 0.3);
	color: #4CAF50;
	padding: 0.3rem 0.8rem;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: bold;
	display: inline-block;
	margin-top: 0.5rem;
}

.reports-section {
	background: rgba(255, 255, 255, 0.1);
	padding: 2rem;
	border-radius: 15px;
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.2);
	margin-bottom: 2rem;
}

.section-title {
	font-size: 1.8rem;
	margin-bottom: 1.5rem;
	color: #4CAF50;
	text-align: center;
}

.reports-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
	gap: 1.5rem;
}

.report-card {
	background: rgba(255, 255, 255, 0.1);
	padding: 1.5rem;
	border-radius: 10px;
	text-align: center;
	transition: all 0.3s ease;
	border: 1px solid rgba(255, 255, 255, 0.2);
}

.report-card:hover {
	transform: translateY(-3px);
	background: rgba(255, 255, 255, 0.15);
}

.report-icon {
	font-size: 2.5rem;
	margin-bottom: 1rem;
}

.report-card-title {
	font-size: 1.2rem;
	font-weight: bold;
	margin-bottom: 0.8rem;
	color: #ffc107;
}

.report-description {
	color: #ccc;
	font-size: 0.9rem;
	margin-bottom: 1.2rem;
	line-height: 1.4;
}

.download-btn {
	background: #4CAF50;
	color: white;
	border: none;
	padding: 0.7rem 1.5rem;
	border-radius: 20px;
	cursor: pointer;
	font-size: 0.9rem;
	font-weight: bold;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	transition: all 0.3s ease;
}

.download-btn:hover {
	background: #45a049;
	transform: translateY(-2px);
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	text-decoration: none;
	color: white;
}

.admin-badge {
	background: #ff4757;
	color: white;
	padding: 0.3rem 0.8rem;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: bold;
	display: inline-block;
	margin-bottom: 0.8rem;
}

.artist-badge {
	background: #3742fa;
	color: white;
	padding: 0.3rem 0.8rem;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: bold;
	display: inline-block;
	margin-bottom: 0.8rem;
}

.no-ratings {
	text-align: center;
	padding: 3rem;
	color: #ccc;
	font-style: italic;
	background: rgba(255, 255, 255, 0.1);
	border-radius: 10px;
	border: 1px solid rgba(255, 255, 255, 0.2);
}

@media ( max-width : 768px) {
	.ratings-grid {
		grid-template-columns: 1fr;
	}
	.reports-grid {
		grid-template-columns: 1fr;
	}
	header {
		flex-direction: column;
		gap: 1rem;
		text-align: center;
	}
	.rating-details {
		grid-template-columns: 1fr;
	}
}
</style>
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