document.addEventListener('DOMContentLoaded', function() {

    window.audioUnlocked = false;
    
    function attemptAudioUnlock() {
        if (!window.audioUnlocked) {
            console.log('🔓 Attempting to unlock audio...');
            
            const tempAudio = new Audio();
            tempAudio.volume = 0;
            tempAudio.src = 'data:audio/wav;base64,UklGRnoAAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoAAAC';
            
            const playPromise = tempAudio.play();
            
            if (playPromise !== undefined) {
                playPromise
                    .then(() => {
                        console.log('✅ Audio unlocked successfully!');
                        window.audioUnlocked = true;
                        tempAudio.pause();
                        tempAudio.remove();
                    })
                    .catch(error => {
                        console.log('🔒 Audio will unlock on first play button click');
                    });
            }
        }
    }

    attemptAudioUnlock();

    document.addEventListener('click', function(e) {
        if (e.target.closest('.play-pause-btn')) {
            if (!window.audioUnlocked) {
                console.log('🔓 Audio unlocked via play button click');
                window.audioUnlocked = true;
            }
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

    let globalAudio = null;
    let currentPlayer = null;
    let isSeeking = false;
    let progressUpdateInterval = null;

    audioPlayers.forEach((player, index) => {
        const playBtn = player.querySelector('.play-pause-btn');
        const playIcon = player.querySelector('.play-icon');
        const pauseIcon = player.querySelector('.pause-icon');
        const progressBar = player.querySelector('.progress-bar');
        const progress = player.querySelector('.progress');
        const currentTimeEl = player.querySelector('.current-time');
        const durationEl = player.querySelector('.duration');
        const progressHandle = player.querySelector('.progress-handle');

        const songId = player.getAttribute('data-song-id');
        const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';

        console.log(`Setting up player ${index} for song ${songId}`);

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

        function updateProgressBar() {
            if (!globalAudio || !globalAudio.duration || isSeeking) return;
            
            const currentTime = globalAudio.currentTime;
            const duration = globalAudio.duration;
            const percent = (currentTime / duration) * 100;
            
            progress.style.width = percent + '%';
            currentTimeEl.textContent = formatTime(currentTime);
            
            if (progressHandle) {
                progressHandle.style.left = `calc(${percent}% - 8px)`;
            }

            if (!isLoggedIn && currentTime >= 60) {
                globalAudio.pause();
                playIcon.style.display = 'block';
                pauseIcon.style.display = 'none';
                showPreviewLimitMessage();
                
                globalAudio.currentTime = 0;
                progress.style.width = '0%';
                currentTimeEl.textContent = '0:00';
                if (progressHandle) {
                    progressHandle.style.left = '-8px';
                }
            }
        }

        function startProgressUpdate() {
            if (progressUpdateInterval) {
                clearInterval(progressUpdateInterval);
            }
            progressUpdateInterval = setInterval(updateProgressBar, 100);
        }

        function stopProgressUpdate() {
            if (progressUpdateInterval) {
                clearInterval(progressUpdateInterval);
                progressUpdateInterval = null;
            }
        }

        function resetPlayerToStart() {
            if (globalAudio && currentPlayer === player) {
                globalAudio.currentTime = 0;
                progress.style.width = '0%';
                currentTimeEl.textContent = '0:00';
                if (progressHandle) {
                    progressHandle.style.left = '-8px';
                }
            }
        }

        async function playAudio() {
            console.log('🎵 Attempting to play audio for song:', songId);

            removeMessages();

            if (!window.audioUnlocked) {
                console.log('🔓 Unlocking audio via play button...');
                window.audioUnlocked = true;
            }

            const endpointWorking = await testAudioEndpoint(songId);
            if (!endpointWorking) {
                showInfoMessage('🔇 Audio service temporarily unavailable - please try again later');
                return;
            }

            if (globalAudio && currentPlayer !== player) {
                globalAudio.pause();
                stopProgressUpdate();
                const prevPlayer = currentPlayer;
                if (prevPlayer) {
                    const prevPlayIcon = prevPlayer.querySelector('.play-icon');
                    const prevPauseIcon = prevPlayer.querySelector('.pause-icon');
                    if (prevPlayIcon) prevPlayIcon.style.display = 'block';
                    if (prevPauseIcon) prevPauseIcon.style.display = 'none';
                }
            }

            if (globalAudio && currentPlayer === player && !isLoggedIn && globalAudio.currentTime >= 60) {
                resetPlayerToStart();
            }

            if (!globalAudio || currentPlayer !== player) {
                globalAudio = new Audio();
                currentPlayer = player;

                const audioSource = isLoggedIn ? `/stream/${songId}` : `/preview/${songId}`;
                globalAudio.src = audioSource;
                globalAudio.preload = 'metadata';

                console.log('🎵 Using audio source:', audioSource);

                resetPlayerToStart();

                globalAudio.addEventListener('loadeddata', function() {
                    console.log('✅ Audio loaded successfully for song:', songId);
                    if (durationEl) {
                        durationEl.textContent = formatTime(globalAudio.duration);
                    }
                });

                globalAudio.addEventListener('canplay', function() {
                    console.log('🎵 Audio can play for song:', songId);
                });

                globalAudio.addEventListener('play', function() {
                    startProgressUpdate();
                });

                globalAudio.addEventListener('pause', function() {
                    stopProgressUpdate();
                });

                globalAudio.addEventListener('ended', function() {
                    console.log('⏹️ Audio ended for song:', songId);
                    stopProgressUpdate();
                    playIcon.style.display = 'block';
                    pauseIcon.style.display = 'none';
                    resetPlayerToStart();
                });

                globalAudio.addEventListener('error', function(e) {
                    console.error('❌ Audio error for song', songId, ':', e);
                    console.error('Audio error details:', globalAudio.error);
                    stopProgressUpdate();
                    showInfoMessage('🔇 Could not load audio - please try another song');
                    playIcon.style.display = 'block';
                    pauseIcon.style.display = 'none';
                });
            }

            globalAudio.play()
                .then(() => {
                    console.log('✅ Audio playing successfully for song:', songId);
                    playIcon.style.display = 'none';
                    pauseIcon.style.display = 'block';

                    if (!isLoggedIn) {
                        showInfoMessage('🎧 Listening to 60-second preview - <a href="/login" style="color: #4CAF50; font-weight: bold;">Login for full access</a>');
                    }
                })
                .catch(error => {
                    console.error('❌ Play failed for song:', songId, error);
                    stopProgressUpdate();

                    if (error.name === 'NotAllowedError') {
                        showInfoMessage('🔇 Browser blocked audio playback - please click play again');
                    } else if (error.name === 'NotSupportedError') {
                        showInfoMessage('🔇 Audio format not supported');
                    } else {
                        showInfoMessage('🔇 Could not play audio - please try again');
                    }

                    playIcon.style.display = 'block';
                    pauseIcon.style.display = 'none';
                });
        }

        function pauseAudio() {
            if (globalAudio && currentPlayer === player) {
                globalAudio.pause();
                stopProgressUpdate();
                playIcon.style.display = 'block';
                pauseIcon.style.display = 'none';
            }
        }

        function seekToPosition(clientX) {
            if (!globalAudio || !globalAudio.duration) return;

            const rect = progressBar.getBoundingClientRect();
            const percent = Math.max(0, Math.min(1, (clientX - rect.left) / rect.width));
            const newTime = percent * globalAudio.duration;

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

            const newPercent = (newTime / globalAudio.duration) * 100;
            progress.style.width = newPercent + '%';
            currentTimeEl.textContent = formatTime(newTime);
            
            if (progressHandle) {
                progressHandle.style.left = `calc(${newPercent}% - 8px)`;
            }

            setTimeout(() => {
                isSeeking = false;
            }, 100);
        }

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
            if (globalAudio && globalAudio.duration) {
                seekToPosition(e.clientX);
            }
        });

        if (progressHandle) {
            let isDragging = false;

            progressHandle.addEventListener('mousedown', function(e) {
                e.stopPropagation();
                isDragging = true;
                isSeeking = true;
            });

            document.addEventListener('mousemove', function(e) {
                if (isDragging && globalAudio && globalAudio.duration) {
                    const rect = progressBar.getBoundingClientRect();
                    const percent = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
                    const newTime = percent * globalAudio.duration;
                    
                    if (!isLoggedIn && newTime > 60) {
                        globalAudio.currentTime = 60;
                        showPreviewLimitMessage();
                    } else {
                        globalAudio.currentTime = newTime;
                    }
                    
                    const newPercent = (newTime / globalAudio.duration) * 100;
                    progress.style.width = newPercent + '%';
                    currentTimeEl.textContent = formatTime(newTime);
                    progressHandle.style.left = `calc(${newPercent}% - 8px)`;
                }
            });

            document.addEventListener('mouseup', function() {
                if (isDragging) {
                    isDragging = false;
                    setTimeout(() => {
                        isSeeking = false;
                    }, 100);
                }
            });
        }

        currentTimeEl.textContent = '0:00';
        const songDuration = parseInt(player.getAttribute('data-duration'));
        if (songDuration && durationEl) {
            durationEl.textContent = '/' + formatTime(songDuration);
        }
    });
}

function initializeDownloadButtons() {

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

    const originalSongs = Array.from(songGrid.querySelectorAll('.song-tile'));

    searchInput.addEventListener('input', function(e) {
        const query = e.target.value.trim();

        if (query.length === 0) {
            originalSongs.forEach(song => {
                song.style.display = 'flex';
            });
            const noResults = songGrid.querySelector('.no-results');
            if (noResults) {
                noResults.remove();
            }
            if (pageTitle) pageTitle.textContent = 'Featured Tracks';
            if (searchInfo) searchInfo.style.display = 'none';
            return;
        }

        const queryLower = query.toLowerCase();
        let visibleCount = 0;

        originalSongs.forEach(song => {
            const title = song.getAttribute('data-title').toLowerCase();
            const artist = song.getAttribute('data-artist').toLowerCase();
            const genre = song.getAttribute('data-genre').toLowerCase();

            if (title.includes(queryLower) || artist.includes(queryLower) || genre.includes(queryLower)) {
                song.style.display = 'flex';
                visibleCount++;
            } else {
                song.style.display = 'none';
            }
        });

        const existingNoResults = songGrid.querySelector('.no-results');
        if (existingNoResults) {
            existingNoResults.remove();
        }

        if (visibleCount === 0) {
            const noResultsHTML = `
                <div class="no-results">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                    <div>No results found for "${query}"</div>
                    <button class="show-all-btn" style="margin-top: 1rem; padding: 0.5rem 1rem; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">
                        Show All Songs
                    </button>
                </div>
            `;
            songGrid.insertAdjacentHTML('beforeend', noResultsHTML);

            const showAllBtn = songGrid.querySelector('.show-all-btn');
            if (showAllBtn) {
                showAllBtn.addEventListener('click', function() {
                    searchInput.value = '';
                    const event = new Event('input');
                    searchInput.dispatchEvent(event);
                });
            }
        }

        if (pageTitle) pageTitle.textContent = `Search Results for "${query}"`;
        if (searchInfo) {
            searchInfo.textContent = `Found ${visibleCount} result(s)`;
            searchInfo.style.display = 'block';
        }
    });

    searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            searchInput.value = '';
            const event = new Event('input');
            searchInput.dispatchEvent(event);
        }
    });
}

function initializeArtistFollow() {

    const artistNames = document.querySelectorAll('.artist-name');
    console.log('Found artist names:', artistNames.length);

    let openDropdown = null;

    function closeAllDropdowns() {
        document.querySelectorAll('.artist-dropdown').forEach(dropdown => {
            if (dropdown) {
                dropdown.style.display = 'none';
            }
        });
        openDropdown = null;
    }

    async function checkFollowStatus(artistId) {
        console.log('🎯 checkFollowStatus called with artistId:', artistId, 'Type:', typeof artistId);

        const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
        if (!isLoggedIn) {
            console.log('👤 User not logged in, returning false');
            return false;
        }

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

    async function handleFollowAction(artistId, button) {
        const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
        if (!isLoggedIn) {
            showLoginPrompt();
            return;
        }

        const isCurrentlyFollowing = button.classList.contains('unfollow');
        const action = isCurrentlyFollowing ? 'unfollow' : 'follow';
        const endpoint = '/api/' + action + '/' + artistId;

        console.log('🎯 Performing', action, 'for artist:', artistId, 'Endpoint:', endpoint);

        try {
            const response = await fetch(endpoint, {
                method: 'POST',
                credentials: 'include'
            });

            console.log('📡 Response status:', response.status);

            if (response.ok) {
                updateButtonText(button, !isCurrentlyFollowing);
                showFollowMessage(isCurrentlyFollowing ? 'unfollowed' : 'followed');

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

    function showFollowMessage(action) {
        const messages = {
            'followed': '✅ Successfully followed artist!',
            'unfollowed': '✅ Successfully unfollowed artist!',
            'error': '❌ Error performing action'
        };

        console.log(messages[action]);
    }

    function showLoginPrompt() {
        alert('Please login first!');
    }

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

            if (openDropdown && openDropdown !== dropdown) {
                closeAllDropdowns();
            }

            if (dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
                openDropdown = null;
            } else {
                dropdown.style.display = 'block';
                openDropdown = dropdown;

                const button = dropdown.querySelector('.follow-btn');
                button.setAttribute('data-artist-id', artistId);

                const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
                if (isLoggedIn) {
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

    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('follow-btn')) {
            e.stopPropagation();
            const artistId = e.target.getAttribute('data-artist-id');
            handleFollowAction(artistId, e.target);

            setTimeout(() => {
                closeAllDropdowns();
            }, 500);
        }
    });

    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('message-btn')) {
            e.stopPropagation();
            const artistId = e.target.getAttribute('data-artist-id');
            const artistName = e.target.getAttribute('data-artist-name');
            openMessagePage(artistId, artistName);
        }
    });

    function openMessagePage(artistId, artistName) {
        const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
        if (!isLoggedIn) {
            showLoginPrompt();
            return;
        }

        window.location.href = '/send-message?artistId=' + artistId + '&artistName=' + encodeURIComponent(artistName);
    }

    document.addEventListener('click', function() {
        closeAllDropdowns();
    });

    document.addEventListener('click', function(e) {
        if (e.target.closest('.artist-dropdown')) {
            e.stopPropagation();
        }
    });
}

function initializeSongRatings() {

    const ratingContainers = document.querySelectorAll('.rating-stars');
    console.log('Found rating containers:', ratingContainers.length);

    ratingContainers.forEach(container => {
        const songId = container.getAttribute('data-song-id');
        loadUserRating(songId, container);
        loadRatingStats(songId, container);
    });

    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('star')) {
            const star = e.target;
            const rating = parseInt(star.getAttribute('data-rating'));
            const container = star.closest('.rating-stars');
            const songId = container.getAttribute('data-song-id');

            const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
            if (!isLoggedIn) {
                showLoginPromptForRating();
                return;
            }

            rateSong(songId, rating, container);
        }
    });

    document.addEventListener('mouseover', function(e) {
        if (e.target.classList.contains('star')) {
            const star = e.target;
            const container = star.closest('.rating-stars');
            const rating = parseInt(star.getAttribute('data-rating'));

            if (!container.classList.contains('user-rated')) {
                highlightStars(container, rating, true);
            }
        }
    });

    document.addEventListener('mouseout', function(e) {
        if (e.target.classList.contains('star')) {
            const container = e.target.closest('.rating-stars');
            if (!container.classList.contains('user-rated')) {
                const userRating = parseInt(container.getAttribute('data-user-rating') || '0');
                highlightStars(container, userRating, false);
            }
        }
    });
}

async function loadUserRating(songId, container) {
    const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
    if (!isLoggedIn) {
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

async function rateSong(songId, rating, container) {
    try {
        const response = await fetch('/api/ratings/song/' + songId + '?rating=' + rating, {
            method: 'POST',
            credentials: 'include'
        });

        if (response.ok) {
            const data = await response.json();
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

function highlightUserRating(container, userRating) {
    console.log('Highlighting user rating:', userRating, 'for container:', container);

    const stars = container.querySelectorAll('.star');

    if (userRating > 0) {
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
        container.classList.remove('user-rated');
        container.removeAttribute('data-user-rating');

        stars.forEach(star => {
            star.classList.remove('active');
            star.classList.remove('hover');
        });
    }
}

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

    const userRating = parseInt(container.getAttribute('data-user-rating') || '0');
    if (userRating > 0) {
        userRatingValue.textContent = userRating;
        userRatingBadge.style.display = 'inline-block';
    } else {
        userRatingBadge.style.display = 'none';
    }
}

function showRatingSuccessMessage(rating) {
    const stars = '★'.repeat(rating) + '☆'.repeat(5 - rating);
    console.log(`✅ Rating ${rating}/5 saved successfully! ${stars}`);
}

function showRatingErrorMessage(message) {
    console.error('❌ Rating error:', message);
    alert('❌ ' + message);
}

function showLoginPromptForRating() {
    alert('Please login to rate songs!');
}