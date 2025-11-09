<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
<title>MusicHub - Share & Discover Music</title>
<link rel="stylesheet" href="./css/index.css">

</head>
<body>
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
					<a href="/messages" class="show-users-btn"
						style="margin-right: 0.5rem;"> 📨 Messages <c:if
							test="${unreadCount > 0}">
							<span
								style="background: #ff4757; color: white; border-radius: 50%; padding: 0.2rem 0.5rem; font-size: 0.7rem; margin-left: 0.3rem;">
								${unreadCount} </span>
						</c:if>
					</a>

					<div class="admin-buttons">
						<a href="/users" class="show-users-btn"> 👥 Show All Users </a>
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
										data-artist-name="${fn:escapeXml(song.artist.fullName)}">💌 Message</button>
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
						        <span class="average-rating">Not rated yet</span>
						        <span class="rating-count">(0 ratings)</span>
						        <span class="user-rating-badge" style="display: none;">Your rating: <span class="user-rating-value">0</span></span>
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

	<script>
    // POBOLJŠANI AUDIO PLAYER SA DIREKTNIM TESTIRANJEM ENDPOINTA
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== INITIALIZING AUDIO PLAYER WITH ENDPOINT TESTING ===');
        
        // Global audio state
        window.audioUnlocked = false;
        
        // Unlock audio na bilo koji user interaction
        document.addEventListener('click', function() {
            if (!window.audioUnlocked) {
                console.log('🔓 Audio unlocked by user interaction');
                window.audioUnlocked = true;
            }
        });
        
        initializeAudioPlayers();
        initializeDownloadButtons();
        initializeSearch();
        initializeArtistFollow();
        initializeSongRatings();
    });

    function initializeAudioPlayers() {
        const audioPlayers = document.querySelectorAll('.audio-player');
        console.log('Found audio players:', audioPlayers.length);
        
        // Globalni audio element za sve playere
        let globalAudio = null;
        let currentPlayer = null;
        let isSeeking = false;
        
        audioPlayers.forEach((player, index) => {
            const playBtn = player.querySelector('.play-pause-btn');
            const playIcon = player.querySelector('.play-icon');
            const pauseIcon = player.querySelector('.pause-icon');
            const progressBar = player.querySelector('.progress-bar');
            const progress = player.querySelector('.progress');
            const currentTimeEl = player.querySelector('.current-time');
            const durationEl = player.querySelector('.duration');
            
            const songId = player.getAttribute('data-song-id');
            const isLoggedIn = ${isLoggedIn};
            
            console.log(`Setting up player ${index} for song ${songId}`);
            
            // Format time function
            function formatTime(seconds) {
                if (isNaN(seconds)) return '0:00';
                const mins = Math.floor(seconds / 60);
                const secs = Math.floor(seconds % 60);
                return `${mins}:${secs.toString().padStart(2, '0')}`;
            }
            
            function showInfoMessage(message, isPreview = false) {
                removeMessages();
                const messageDiv = document.createElement('div');
                messageDiv.className = isPreview ? 'preview-limit-message' : 'audio-info-message';
                messageDiv.innerHTML = message;
                player.appendChild(messageDiv);
                
                // Automatski ukloni poruku nakon 5 sekundi
                setTimeout(() => {
                    if (messageDiv.parentNode === player) {
                        messageDiv.remove();
                    }
                }, 5000);
            }
            
            function removeMessages() {
                const messages = player.querySelectorAll('.preview-limit-message, .audio-info-message');
                messages.forEach(msg => msg.remove());
            }
            
            function showPreviewLimitMessage() {
                showInfoMessage('🎧 Preview limited to 60 seconds - <a href="/login" style="color: #4CAF50; font-weight: bold;">Login for full access</a>', true);
            }
            
            // Testiraj audio endpoint
            function testAudioEndpoint(songId) {
                return new Promise((resolve) => {
                    const audioSource = isLoggedIn ? `/stream/${songId}` : `/preview/${songId}`;
                    console.log('🔍 Testing audio endpoint:', audioSource);
                    
                    fetch(audioSource, { method: 'HEAD' })
                        .then(response => {
                            if (response.ok) {
                                console.log('✅ Audio endpoint OK:', audioSource);
                                resolve(true);
                            } else {
                                console.log('❌ Audio endpoint failed:', audioSource, response.status);
                                resolve(false);
                            }
                        })
                        .catch(error => {
                            console.log('❌ Audio endpoint error:', audioSource, error);
                            resolve(false);
                        });
                });
            }
            
            // Play funkcija - POBOLJŠANA SA ENDPOINT TESTING-OM
            async function playAudio() {
                console.log('🎵 Attempting to play audio for song:', songId);
                
                removeMessages();
                
                // Proveri da li je audio unlocked
                if (!window.audioUnlocked) {
                    console.log('🔒 Audio not unlocked yet');
                    showInfoMessage('🎧 Click anywhere on the page first, then click play to listen');
                    return;
                }
                
                // Testiraj endpoint pre nego što pokušaš da reprodukuješ
                const endpointWorking = await testAudioEndpoint(songId);
                if (!endpointWorking) {
                    showInfoMessage('🔇 Audio service temporarily unavailable - please try again later');
                    return;
                }
                
                // Zaustavi prethodni audio ako postoji
                if (globalAudio && currentPlayer !== player) {
                    globalAudio.pause();
                    const prevPlayer = currentPlayer;
                    if (prevPlayer) {
                        const prevPlayIcon = prevPlayer.querySelector('.play-icon');
                        const prevPauseIcon = prevPlayer.querySelector('.pause-icon');
                        if (prevPlayIcon) prevPlayIcon.style.display = 'block';
                        if (prevPauseIcon) prevPauseIcon.style.display = 'none';
                    }
                }
                
                // Kreiraj novi audio element ako ne postoji ili ako je drugi player
                if (!globalAudio || currentPlayer !== player) {
                    globalAudio = new Audio();
                    currentPlayer = player;
                    
                    const audioSource = isLoggedIn ? `/stream/${songId}` : `/preview/${songId}`;
                    globalAudio.src = audioSource;
                    globalAudio.preload = 'metadata';
                    
                    console.log('🎵 Using audio source:', audioSource);
                    
                    // Resetuj progress bar
                    progress.style.width = '0%';
                    currentTimeEl.textContent = '0:00';
                    
                    // Event listeners za NOVI audio element
                    globalAudio.addEventListener('loadeddata', function() {
                        console.log('✅ Audio loaded successfully for song:', songId);
                    });
                    
                    globalAudio.addEventListener('canplay', function() {
                        console.log('🎵 Audio can play for song:', songId);
                    });
                    
                    globalAudio.addEventListener('timeupdate', function() {
                        if (!isSeeking && globalAudio.duration) {
                            updateProgress();
                        }
                    });
                    
                    globalAudio.addEventListener('ended', function() {
                        console.log('⏹️ Audio ended for song:', songId);
                        playIcon.style.display = 'block';
                        pauseIcon.style.display = 'none';
                        progress.style.width = '0%';
                        currentTimeEl.textContent = '0:00';
                    });
                    
                    globalAudio.addEventListener('error', function(e) {
                        console.error('❌ Audio error for song', songId, ':', e);
                        console.error('Audio error details:', globalAudio.error);
                        
                        showInfoMessage('🔇 Could not load audio - please try another song');
                        playIcon.style.display = 'block';
                        pauseIcon.style.display = 'none';
                    });
                }
                
                // Pokušaj da reprodukuješ audio
                globalAudio.play()
                    .then(() => {
                        console.log('✅ Audio playing successfully for song:', songId);
                        playIcon.style.display = 'none';
                        pauseIcon.style.display = 'block';
                        
                        // Dodaj preview info poruku za nelogovane
                        if (!isLoggedIn) {
                            showInfoMessage('🎧 Listening to 60-second preview - <a href="/login" style="color: #4CAF50; font-weight: bold;">Login for full access</a>');
                        }
                    })
                    .catch(error => {
                        console.error('❌ Play failed for song:', songId, error);
                        
                        if (error.name === 'NotAllowedError') {
                            showInfoMessage('🔇 Please click anywhere on the page first, then click play');
                        } else if (error.name === 'NotSupportedError') {
                            showInfoMessage('🔇 Audio format not supported');
                        } else {
                            showInfoMessage('🔇 Could not play audio - please try again');
                        }
                        
                        playIcon.style.display = 'block';
                        pauseIcon.style.display = 'none';
                    });
            }
            
            // Pause funkcija
            function pauseAudio() {
                console.log('⏸️ Pausing audio for song:', songId);
                if (globalAudio && currentPlayer === player) {
                    globalAudio.pause();
                    playIcon.style.display = 'block';
                    pauseIcon.style.display = 'none';
                }
            }
            
            // Update progress
            function updateProgress() {
                if (globalAudio && globalAudio.duration && !isSeeking) {
                    const percent = (globalAudio.currentTime / globalAudio.duration) * 100;
                    progress.style.width = percent + '%';
                    currentTimeEl.textContent = formatTime(globalAudio.currentTime);
                    
                    // Preview limit za nelogovane
                    if (!isLoggedIn && globalAudio.currentTime >= 60) {
                        globalAudio.pause();
                        playIcon.style.display = 'block';
                        pauseIcon.style.display = 'none';
                        showPreviewLimitMessage();
                    }
                }
            }
            
            // Seek funkcija - POBOLJŠANA
            function seekToPosition(clientX) {
                if (!globalAudio || !globalAudio.duration) return;
                
                const rect = progressBar.getBoundingClientRect();
                const percent = Math.max(0, Math.min(1, (clientX - rect.left) / rect.width));
                const newTime = percent * globalAudio.duration;
                
                // Postavi seeking flag
                isSeeking = true;
                
                if (!isLoggedIn && newTime > 60) {
                    globalAudio.currentTime = 60;
                    if (!globalAudio.paused) {
                        pauseAudio();
                    }
                    showPreviewLimitMessage();
                } else {
                    globalAudio.currentTime = newTime;
                }
                
                // Instantly update progress bar
                progress.style.width = (newTime / globalAudio.duration) * 100 + '%';
                currentTimeEl.textContent = formatTime(newTime);
                
                // Reset seeking flag nakon kratkog vremena
                setTimeout(() => {
                    isSeeking = false;
                }, 100);
            }
            
            // Event listeners
            playBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                console.log('🎵 Play button clicked for song:', songId);
                
                if (globalAudio && !globalAudio.paused && currentPlayer === player) {
                    pauseAudio();
                } else {
                    playAudio();
                }
            });
            
            progressBar.addEventListener('click', function(e) {
                if (globalAudio) {
                    seekToPosition(e.clientX);
                }
            });
            
            // Inicijalizacija
            currentTimeEl.textContent = '0:00';
            const songDuration = parseInt(player.getAttribute('data-duration'));
            if (songDuration) {
                durationEl.textContent = '/' + formatTime(songDuration);
            }
        });
    }

    function initializeDownloadButtons() {
        console.log('=== INITIALIZING DOWNLOAD BUTTONS ===');
        
        const downloadLinks = document.querySelectorAll('.download-link');
        console.log('Found download links:', downloadLinks.length);
        
        downloadLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const songId = this.href.split('/').pop();
                const songTitle = this.getAttribute('data-song-title') || 
                                this.closest('.song-tile').querySelector('.song-title').textContent;
                const songArtist = this.getAttribute('data-song-artist') || 
                                 this.closest('.song-tile').querySelector('.song-meta:nth-child(2) span:nth-child(2)').textContent;
                
                const fileName = `${songArtist} - ${songTitle}.wav`;
                console.log('Download requested for:', fileName, 'ID:', songId);
                
                if (confirm(`Do you want to download "${fileName}"?`)) {
                    window.location.href = '/api/download/' + songId;
                }
            });
        });
    }

    function initializeSearch() {
        const searchInput = document.getElementById('searchInput');
        const songGrid = document.getElementById('songGrid');
        const pageTitle = document.getElementById('pageTitle');
        const searchInfo = document.getElementById('searchInfo');

        let searchTimeout;

        searchInput.addEventListener('input', function(e) {
            const query = e.target.value.trim();
            
            clearTimeout(searchTimeout);
            
            if (query.length === 0) {
                showAllSongs();
                return;
            }
            
            searchTimeout = setTimeout(() => {
                performSearch(query);
            }, 300);
        });

        function performSearch(query) {
            const results = filterSongsByQuery(query);
            
            if (results.length === 0) {
                displayNoResults(query);
            } else {
                displaySearchResults(results, query);
            }
        }

        function filterSongsByQuery(query) {
            const allSongs = Array.from(document.querySelectorAll('.song-tile'));
            const queryLower = query.toLowerCase();
            
            return allSongs.filter(songTile => {
                const title = songTile.getAttribute('data-title').toLowerCase();
                const artist = songTile.getAttribute('data-artist').toLowerCase();
                const genre = songTile.getAttribute('data-genre').toLowerCase();
                
                return title.includes(queryLower) || 
                       artist.includes(queryLower) || 
                       genre.includes(queryLower);
            });
        }

        function displaySearchResults(results, query) {
            const allSongs = document.querySelectorAll('.song-tile');
            allSongs.forEach(song => song.style.display = 'none');
            
            results.forEach(songTile => {
                songTile.style.display = 'flex';
            });
            
            pageTitle.textContent = `Search Results for "${query}"`;
            searchInfo.textContent = `Found ${results.length} result(s)`;
            searchInfo.style.display = 'block';
        }

        function displayNoResults(query) {
            const allSongs = document.querySelectorAll('.song-tile');
            allSongs.forEach(song => song.style.display = 'none');
            
            songGrid.innerHTML = `
                <div class="no-results">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                    <div>No results found for "${query}"</div>
                    <div style="margin-top: 0.5rem; font-size: 0.9rem;">Try different keywords or browse all tracks</div>
                </div>
            `;
            
            pageTitle.textContent = `Search Results for "${query}"`;
            searchInfo.style.display = 'none';
        }

        function showAllSongs() {
            const allSongs = document.querySelectorAll('.song-tile');
            allSongs.forEach(song => song.style.display = 'flex');
            
            pageTitle.textContent = 'Featured Tracks';
            searchInfo.style.display = 'none';
        }

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                searchInput.value = '';
                showAllSongs();
            }
        });
    }

    function initializeArtistFollow() {
        console.log('=== INITIALIZING ARTIST FOLLOW FUNCTIONALITY ===');
        
        const artistNames = document.querySelectorAll('.artist-name');
        console.log('Found artist names:', artistNames.length);
        
        // Globalno praćenje otvorenih dropdown-ova
        let openDropdown = null;
        
        // Zatvori sve dropdown-ove
        function closeAllDropdowns() {
            document.querySelectorAll('.artist-dropdown').forEach(dropdown => {
                if (dropdown) {
                    dropdown.style.display = 'none';
                }
            });
            openDropdown = null;
        }
        
        // Proveri follow status za artist-a
        async function checkFollowStatus(artistId) {
            console.log('🎯 checkFollowStatus called with artistId:', artistId, 'Type:', typeof artistId);
            
            if (!${isLoggedIn}) {
                console.log('👤 User not logged in, returning false');
                return false;
            }
            
            // Proveri da li je artistId validan
            if (!artistId || artistId === 'undefined' || artistId === 'null') {
                console.error('❌ Invalid artistId:', artistId);
                return false;
            }
            
            try {
                const url = '/api/follow/status/' + artistId;
                console.log('🔍 Fetching from URL:', url);
                
                const response = await fetch(url);
                console.log('📡 Response status:', response.status, response.statusText);
                
                if (response.ok) {
                    const data = await response.json();
                    console.log('✅ Follow status data:', data);
                    return data.isFollowing;
                } else {
                    console.warn('⚠️ Follow status check failed:', response.status);
                    return false;
                }
            } catch (error) {
                console.error('❌ Error checking follow status:', error);
                return false;
            }
        }
        
        // Ažuriraj tekst dugmeta
        function updateButtonText(button, isFollowing) {
            if (isFollowing) {
                button.textContent = 'Unfollow';
                button.classList.add('unfollow');
            } else {
                button.textContent = 'Follow';
                button.classList.remove('unfollow');
            }
            console.log('Button updated:', button.textContent, 'isFollowing:', isFollowing);
        }
        
        // Obrada follow/unfollow akcije
        async function handleFollowAction(artistId, button) {
            if (!${isLoggedIn}) {
                showLoginPrompt();
                return;
            }
            
            const isCurrentlyFollowing = button.classList.contains('unfollow');
            const action = isCurrentlyFollowing ? 'unfollow' : 'follow';
            
            // ISPRAVLJENO: Koristi obične stringove umesto template literals
            const endpoint = '/api/' + action + '/' + artistId;
            
            console.log('🎯 Performing', action, 'for artist:', artistId, 'Endpoint:', endpoint);
            
            try {
                const response = await fetch(endpoint, {
                    method: 'POST',
                    credentials: 'include' // Obavezno za slanje cookie-ja
                });
                
                console.log('📡 Response status:', response.status);
                
                if (response.ok) {
                    // Uspješno ažurirano - promeni tekst dugmeta
                    updateButtonText(button, !isCurrentlyFollowing);
                    showFollowMessage(isCurrentlyFollowing ? 'unfollowed' : 'followed');
                    
                    // Zatvori dropdown nakon uspešne akcije
                    setTimeout(() => {
                        closeAllDropdowns();
                    }, 1000);
                } else {
                    console.error('❌ Follow action failed:', response.status, response.statusText);
                    showFollowMessage('error');
                }
            } catch (error) {
                console.error('❌ Error performing follow action:', error);
                showFollowMessage('error');
            }
        }
        
        // Prikaži poruku o follow akciji
        function showFollowMessage(action) {
            const messages = {
                'followed': '✅ Successfully followed artist!',
                'unfollowed': '✅ Successfully unfollowed artist!',
                'error': '❌ Error performing action'
            };
            
            // Možete dodati notifikaciju ovde ako želite
            console.log(messages[action]);
        }
        
        // Prikaži prompt za login
        function showLoginPrompt() {
            alert('Please login to follow artists!');
        }
        
        // Event listener za imena autora
        artistNames.forEach(artistName => {
            artistName.addEventListener('click', async function(e) {
                e.stopPropagation();
                
                const artistContainer = this.closest('.artist-name-container');
                const artistId = artistContainer.getAttribute('data-artist-id');
                const dropdown = artistContainer.querySelector('.artist-dropdown');
                
                console.log('🎯 Artist clicked:', artistId, 'Dropdown found:', !!dropdown);
                
                if (!dropdown) {
                    console.error('Dropdown not found in container');
                    return;
                }
                
                // Zatvori prethodni dropdown
                if (openDropdown && openDropdown !== dropdown) {
                    closeAllDropdowns();
                }
                
                // Toggle dropdown
                if (dropdown.style.display === 'block') {
                    dropdown.style.display = 'none';
                    openDropdown = null;
                } else {
                    // Prikaži dropdown
                    dropdown.style.display = 'block';
                    openDropdown = dropdown;
                    
                    // Postavi artist ID na dugme
                    const button = dropdown.querySelector('.follow-btn');
                    button.setAttribute('data-artist-id', artistId);
                    
                    // Proveri follow status i ažuriraj dugme
                    if (${isLoggedIn}) {
                        try {
                            console.log('🔍 Checking follow status for artist:', artistId);
                            const isFollowing = await checkFollowStatus(artistId);
                            console.log('✅ Follow status result:', isFollowing);
                            updateButtonText(button, isFollowing);
                        } catch (error) {
                            console.error('❌ Error checking follow status:', error);
                            updateButtonText(button, false);
                        }
                    } else {
                        updateButtonText(button, false);
                    }
                }
            });
        });
        
        // Event listener za follow dugmad
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('follow-btn')) {
                e.stopPropagation();
                const artistId = e.target.getAttribute('data-artist-id');
                handleFollowAction(artistId, e.target);
                
                // Zatvori dropdown nakon akcije
                setTimeout(() => {
                    closeAllDropdowns();
                }, 500);
            }
        });

        // Event listener za message dugmad
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('message-btn')) {
                e.stopPropagation();
                const artistId = e.target.getAttribute('data-artist-id');
                const artistName = e.target.getAttribute('data-artist-name');
                openMessagePage(artistId, artistName);
            }
        });

        // Funkcija za otvaranje stranice za slanje poruke
        function openMessagePage(artistId, artistName) {
            if (!${isLoggedIn}) {
                showLoginPrompt();
                return;
            }
            
            // Preusmeri na stranicu za slanje poruke sa artist ID i imenom kao parametrima
            window.location.href = '/send-message?artistId=' + artistId + '&artistName=' + encodeURIComponent(artistName);
        }
        
        // Zatvori dropdown kada se klikne bilo gde drugde
        document.addEventListener('click', function() {
            closeAllDropdowns();
        });
        
        // Spreči zatvaranje dropdown-a kada se klikne unutar njega
        document.addEventListener('click', function(e) {
            if (e.target.closest('.artist-dropdown')) {
                e.stopPropagation();
            }
        });
    }

    function initializeSongRatings() {
        console.log('=== INITIALIZING SONG RATINGS ===');
        
        const ratingContainers = document.querySelectorAll('.rating-stars');
        console.log('Found rating containers:', ratingContainers.length);
        
        // Učitaj user ratings i stats za sve pesme
        ratingContainers.forEach(container => {
            const songId = container.getAttribute('data-song-id');
            loadUserRating(songId, container);
            loadRatingStats(songId, container);
        });
        
        // Event listener za zvezdice
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('star')) {
                const star = e.target;
                const rating = parseInt(star.getAttribute('data-rating'));
                const container = star.closest('.rating-stars');
                const songId = container.getAttribute('data-song-id');
                
                if (!${isLoggedIn}) {
                    showLoginPromptForRating();
                    return;
                }
                
                rateSong(songId, rating, container);
            }
        });

        // Hover efekat za zvezdice
        document.addEventListener('mouseover', function(e) {
            if (e.target.classList.contains('star')) {
                const star = e.target;
                const container = star.closest('.rating-stars');
                const rating = parseInt(star.getAttribute('data-rating'));
                
                // Prikaži hover efekat samo ako korisnik nije već ocenio
                if (!container.classList.contains('user-rated')) {
                    highlightStars(container, rating, true);
                }
            }
        });

        document.addEventListener('mouseout', function(e) {
            if (e.target.classList.contains('star')) {
                const container = e.target.closest('.rating-stars');
                // Vrati na originalno stanje nakon hover-a
                if (!container.classList.contains('user-rated')) {
                    const userRating = parseInt(container.getAttribute('data-user-rating') || '0');
                    highlightStars(container, userRating, false);
                }
            }
        });
    }

    // Učitaj user-ovu ocenu za pesmu
    async function loadUserRating(songId, container) {
	    if (!${isLoggedIn}) {
	        // Ako korisnik nije ulogovan, samo resetuj zvezdice
	        highlightUserRating(container, 0);
	        return;
	    }
	    
	    try {
	        const response = await fetch('/api/ratings/song/' + songId + '/user');
	        if (response.ok) {
	            const data = await response.json();
	            console.log('User rating loaded:', data.userRating, 'for song:', songId);
	            highlightUserRating(container, data.userRating);
	        }
	    } catch (error) {
	        console.error('Error loading user rating:', error);
	        highlightUserRating(container, 0);
	    }
	}

    // Učitaj statistiku ocena za pesmu
    async function loadRatingStats(songId, container) {
        try {
            const response = await fetch('/api/ratings/song/' + songId + '/stats');
            if (response.ok) {
                const data = await response.json();
                updateRatingStats(container, data.averageRating, data.ratingCount);
            }
        } catch (error) {
            console.error('Error loading rating stats:', error);
        }
    }

    // Oceni pesmu
    async function rateSong(songId, rating, container) {
	    try {
	        const response = await fetch('/api/ratings/song/' + songId + '?rating=' + rating, {
	            method: 'POST',
	            credentials: 'include'
	        });
	        
	        if (response.ok) {
	            const data = await response.json();
	            // Oznaci da je korisnik ocenio i prikazi njegovu ocenu
	            highlightUserRating(container, rating);
	            updateRatingStats(container, data.averageRating, data.ratingCount);
	            showRatingSuccessMessage(rating);
	        } else {
	            const errorData = await response.json();
	            showRatingErrorMessage(errorData.error);
	        }
	    } catch (error) {
	        console.error('Error rating song:', error);
	        showRatingErrorMessage('Network error');
	    }
	}
    
    function highlightStars(container, rating, isHover = false) {
        const stars = container.querySelectorAll('.star');
        stars.forEach(star => {
            const starRating = parseInt(star.getAttribute('data-rating'));
            if (starRating <= rating) {
                star.classList.add('active');
                if (isHover) {
                    star.classList.add('hover');
                } else {
                    star.classList.remove('hover');
                }
            } else {
                star.classList.remove('active');
                star.classList.remove('hover');
            }
        });
    }

    // Označi user-ovu ocenu
    function highlightUserRating(container, userRating) {
	    console.log('Highlighting user rating:', userRating, 'for container:', container);
	    
	    const stars = container.querySelectorAll('.star');
	    
	    if (userRating > 0) {
	        // Korisnik je ocenio pesmu - označi zvezdice
	        container.classList.add('user-rated');
	        container.setAttribute('data-user-rating', userRating);
	        
	        stars.forEach(star => {
	            const starRating = parseInt(star.getAttribute('data-rating'));
	            if (starRating <= userRating) {
	                star.classList.add('active');
	            } else {
	                star.classList.remove('active');
	            }
	            star.classList.remove('hover');
	        });
	    } else {
	        // Korisnik nije ocenio pesmu - resetuj zvezdice
	        container.classList.remove('user-rated');
	        container.removeAttribute('data-user-rating');
	        
	        stars.forEach(star => {
	            star.classList.remove('active');
	            star.classList.remove('hover');
	        });
	    }
	}

    // Ažuriraj statistiku ocena
    function updateRatingStats(container, averageRating, ratingCount) {
	    const ratingInfo = container.nextElementSibling;
	    const averageElement = ratingInfo.querySelector('.average-rating');
	    const countElement = ratingInfo.querySelector('.rating-count');
	    const userRatingBadge = ratingInfo.querySelector('.user-rating-badge');
	    const userRatingValue = ratingInfo.querySelector('.user-rating-value');
	    
	    if (averageRating > 0) {
	        averageElement.textContent = averageRating + ' ★';
	        countElement.textContent = '(' + ratingCount + ' rating' + (ratingCount !== 1 ? 's' : '') + ')';
	    } else {
	        averageElement.textContent = 'Not rated yet';
	        countElement.textContent = '(0 ratings)';
	    }
	    
	    // Prikaži user rating badge ako je korisnik ocenio
	    const userRating = parseInt(container.getAttribute('data-user-rating') || '0');
	    if (userRating > 0) {
	        userRatingValue.textContent = userRating;
	        userRatingBadge.style.display = 'inline-block';
	    } else {
	        userRatingBadge.style.display = 'none';
	    }
	}

    // Prikaži poruke
    function showRatingSuccessMessage(rating) {
	    const stars = '★'.repeat(rating) + '☆'.repeat(5 - rating);
	    console.log(`✅ Rating ${rating}/5 saved successfully! ${stars}`);
	    // Možete dodati toast notifikaciju:
	    // showToast(`Rated ${rating} stars!`, 'success');
	}
	
	function showRatingErrorMessage(message) {
	    console.error('❌ Rating error:', message);
	    alert('❌ ' + message);
	}

    function showLoginPromptForRating() {
        alert('Please login to rate songs!');
    }
</script>
</body>
</html>