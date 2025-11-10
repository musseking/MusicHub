(function(isLoggedIn) {
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
})(isLoggedIn);