<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>MusicHub - Share & Discover Music</title>
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
            background: #ff4757;
        }
        
        .user-role-badge.artist {
            background: #4CAF50;
        }
        
        .user-role-badge.user {
            background: #3742fa;
        }
        
        .user-role-badge.not-registered {
            background: #747d8c;
        }
        
        .logout-btn {
            background: #ff4757;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            font-weight: bold;
        }
        
        .logout-btn:hover {
            background: #e84118;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .login-btn {
            color: #333;
            text-decoration: none;
            text-align: center;
            background: rgba(255, 255, 255, 0.9);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            white-space: nowrap;
            font-weight: bold;
            border: 2px solid #ddd;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .login-btn:hover {
            background: #f8f9fa;
            color: #222;
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .register-btn {
            color: white;
            text-decoration: none;
            background: #4CAF50;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            white-space: nowrap;
            font-weight: bold;
            border: 2px solid #45a049;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .register-btn:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            border-color: #3d8b40;
        }
        
        .show-users-btn {
            color: white;
            text-decoration: none;
            background: #3742fa;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            white-space: nowrap;
            font-weight: bold;
            border: 2px solid #2f36d4;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-right: 0.5rem;
        }
        
        .show-users-btn:hover {
            background: #2f36d4;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            border-color: #252ba8;
        }
        
        .guest-buttons {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }
        
        .admin-buttons {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }
        
        .search-container {
            position: relative;
            margin-right: 1rem;
        }
        
        .search-input {
            padding: 0.7rem 1rem;
            border: none;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            font-size: 0.9rem;
            width: 250px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            outline: none;
            background: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .search-input::placeholder {
            color: #666;
        }

        .search-info {
            margin: 1rem 0;
            color: #ccc;
            font-style: italic;
        }

        .no-results {
            text-align: center;
            color: #ccc;
            font-style: italic;
            padding: 3rem;
            font-size: 1.1rem;
        }

        .song-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .song-tile {
            background: rgba(255,255,255,0.1);
            border-radius: 12px;
            overflow: hidden;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            height: fit-content;
        }
        
        .song-tile:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
            background: rgba(255,255,255,0.15);
        }
        
        .song-image {
            width: 100%;
            height: 230px;
            object-fit: cover;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .song-content {
            padding: 0.8rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .song-title {
            font-size: 0.95rem;
            font-weight: bold;
            margin-bottom: 0.6rem;
            line-height: 1.2;
            min-height: 2.4em;
        }
        
        .song-meta {
            color: #ccc;
            margin-bottom: 0.3rem;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .song-meta-icon {
            width: 14px;
            text-align: center;
            font-size: 0.75rem;
        }
        
        /* AUDIO PLAYER STYLES */
        .audio-player {
            margin-top: 0.8rem;
            padding: 0.8rem;
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .player-controls {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin-bottom: 0.5rem;
        }

        .play-pause-btn {
            background: #4CAF50;
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            color: white;
            font-size: 0.8rem;
            flex-shrink: 0;
        }

        .play-pause-btn:hover {
            background: #45a049;
            transform: scale(1.1);
        }

        .progress-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
            min-width: 0;
        }

        .progress-bar {
            position: relative;
            height: 4px;
            background: rgba(255,255,255,0.2);
            border-radius: 2px;
            cursor: pointer;
            overflow: visible;
        }

        .progress {
            height: 100%;
            background: #4CAF50;
            border-radius: 2px;
            width: 0%;
            transition: width 0.1s ease;
            position: relative;
        }

        .progress-handle {
            position: absolute;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 12px;
            height: 12px;
            background: #4CAF50;
            border-radius: 50%;
            border: 2px solid white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
            opacity: 0;
            transition: opacity 0.2s ease;
            cursor: pointer;
        }

        .progress-bar:hover .progress-handle {
            opacity: 1;
        }

        .time-display {
            display: flex;
            justify-content: space-between;
            font-size: 0.7rem;
            color: #ccc;
        }

        .current-time {
            font-weight: bold;
        }

        /* PREVIEW LIMIT STYLING */
        .preview-limit-marker {
            position: absolute;
            top: 0;
            width: 2px;
            height: 100%;
            background: #ff4757;
            z-index: 2;
        }

        .preview-limit-message {
            background: rgba(255, 71, 87, 0.1);
            color: #ff6b81;
            padding: 0.6rem;
            border-radius: 6px;
            margin-top: 0.6rem;
            text-align: center;
            font-size: 0.8rem;
            border: 1px solid rgba(255, 107, 129, 0.3);
        }

        .preview-limit-message a {
            color: #4CAF50 !important;
            font-weight: bold;
            text-decoration: underline;
        }

        .download-section {
            margin-top: 0.6rem;
            padding-top: 0.6rem;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        .download-link {
            color: #4CAF50;
            text-decoration: none;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 0.2rem;
            font-size: 0.8rem;
            cursor: pointer;
        }
        
        .download-link:hover {
            text-decoration: underline;
        }
        
        .register-prompt {
            color: #ccc;
            font-style: italic;
            font-size: 0.75rem;
        }
        
        .download-unavailable {
            color: #ff4757;
            font-style: italic;
            font-size: 0.75rem;
        }

        .audio-info-message {
            background: rgba(255, 193, 7, 0.1);
            color: #ffc107;
            padding: 0.6rem;
            border-radius: 6px;
            margin-top: 0.6rem;
            text-align: center;
            font-size: 0.8rem;
            border: 1px solid rgba(255, 193, 7, 0.3);
        }

        .audio-info-message a {
            color: #4CAF50 !important;
            font-weight: bold;
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .song-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 0.8rem;
            }
            
            .search-input {
                width: 200px;
            }
        }
        
        @media (max-width: 480px) {
            .song-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 0.6rem;
            }
            
            .song-image {
                height: 120px;
            }
            
            .song-content {
                padding: 0.6rem;
            }
            
            .song-title {
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
            }
            
            .song-meta {
                font-size: 0.75rem;
            }
            
            .search-input {
                width: 150px;
            }
        }

        header h1 {
            color: #222;
            margin: 0;
        }
    </style>
</head>
<body>
<header>
    <h1>🎧 MusicHub</h1>
    <div class="user-display">
        <div class="search-container">
            <input type="text" class="search-input" placeholder="Search songs, artists, or genres..." id="searchInput">
        </div>
        
        <c:choose>
            <c:when test="${isLoggedIn}">
                <div class="user-info-container">
                    <div class="username">${displayName}</div>
                    <div class="user-role-badge ${loggedUserRole.toLowerCase()}">
                        ${loggedDisplayRole}
                    </div>
                </div>
               
                <div class="admin-buttons">
                    <a href="/users" class="show-users-btn">
                        👥 Show All Users
                    </a>
                    <form action="/logout" method="post" style="display: inline; margin: 0;">
                        <button type="submit" class="logout-btn">Logout</button>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </form>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="user-info-container">
                    <div class="username">Guest User</div>
                    <div class="user-role-badge not-registered">
                        Not Registered
                    </div>
                </div>
                <div class="guest-buttons">
                    <a href="/login" class="login-btn">Login</a>
                    <a href="/register" class="register-btn">Register</a>
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
            <div class="song-tile" data-title="${song.title}" data-artist="${song.artist.fullName}" data-genre="${song.genre.name}">
                <c:choose>
                    <c:when test="${not empty song.coverImage}">
                        <img src="${song.coverImage}" alt="${song.title}" class="song-image">
                    </c:when>
                    <c:otherwise>
                        <div class="song-image" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem;">
                            🎵
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="song-content">
                    <div class="song-title">${song.title}</div>
                    
                    <div class="song-meta">
                        <span class="song-meta-icon">🎤</span>
                        <span>${song.artist.fullName}</span>
                    </div>
                    
                    <div class="song-meta">
                        <span class="song-meta-icon">🎵</span>
                        <span>${song.genre.name}</span>
                    </div>
                    
                    <c:if test="${song.album != null}">
                        <div class="song-meta">
                            <span class="song-meta-icon">📀</span>
                            <span>${song.album.title}</span>
                        </div>
                    </c:if>
                    
                    <div class="song-meta">
                        <span class="song-meta-icon">⏱️</span>
                        <span>${song.duration} sec</span>
                    </div>
                    
                    <div class="download-section">
                        <div class="audio-player" data-song-id="${song.id}" data-duration="${song.duration}">
                            <div class="player-controls">
                                <button class="play-pause-btn" type="button">
                                    <span class="play-icon">▶</span>
                                    <span class="pause-icon" style="display: none;">❚❚</span>
                                </button>
                                
                                <div class="progress-container">
                                    <div class="progress-bar">
                                        <div class="progress"></div>
                                        <div class="progress-handle"></div>
                                    </div>
                                    <div class="time-display">
                                        <span class="current-time">0:00</span>
                                        <span class="duration">/${song.duration} sec</span>
                                    </div>
                                </div>
                            </div>
                            
                            <c:choose>
                                <c:when test="${song.allowDownload}">
                                    <c:choose>
                                        <c:when test="${isLoggedIn}">
                                            <a href="/api/download/${song.id}" class="download-link" data-song-title="${song.title}" data-song-artist="${song.artist.fullName}">
                                                <span>📥</span>
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
</script>
</body>
</html>