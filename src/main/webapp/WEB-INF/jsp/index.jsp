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
        
        /* Stil za user info u headeru */
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
        
        /* SEARCH STYLES */
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

        /* SEARCH RESULTS INFO */
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

        /* KOMPAKTNI GRID TILE LAYOUT */
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
            height: 220px;
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
        
        .download-section {
            margin-top: 0.6rem;
            padding-top: 0.6rem;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        .preview-link {
            color: #4CAF50;
            text-decoration: none;
            margin-right: 0.8rem;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 0.2rem;
            font-size: 0.8rem;
        }
        
        .preview-link:hover {
            text-decoration: underline;
        }
        
        .download-link {
            color: #4CAF50;
            text-decoration: none;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 0.2rem;
            font-size: 0.8rem;
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

        /* Responsive adjustments */
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
        <!-- SEARCH CONTAINER -->
        <div class="search-container">
            <input type="text" class="search-input" placeholder="Search songs, artists, or genres..." id="searchInput">
        </div>
        
        <c:choose>
            <c:when test="${isLoggedIn}">
                <!-- PRIKAZ ZA ULOGOVANE KORISNIKE -->
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
                <!-- PRIKAZ ZA NELOGOVANE KORISNIKE -->
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
                <!-- Slika pesme na vrhu -->
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
                
                <!-- Sadržaj ispod slike -->
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
                    
                    <!-- Download sekcija -->
                    <div class="download-section">
                        <!-- Preview uvek dostupan svima -->
                        <a href="/preview/${song.id}" class="preview-link">
                            <span>🎧</span>
                            <span>Preview</span>
                        </a>
                        
                        <!-- Download samo za registrovane -->
                        <c:choose>
                            <c:when test="${song.allowDownload}">
                                <c:choose>
                                    <c:when test="${isLoggedIn}">
                                        <a href="/download/${song.id}" class="download-link">
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
        </c:forEach>
    </div>
</main>

<script>
    // Search functionality with debounce
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
            
            // Pretraga po naslovu, artistu i žanru
            return title.includes(queryLower) || 
                   artist.includes(queryLower) || 
                   genre.includes(queryLower);
        });
    }

    function displaySearchResults(results, query) {
        // Sakrij sve pesme
        const allSongs = document.querySelectorAll('.song-tile');
        allSongs.forEach(song => song.style.display = 'none');
        
        // Prikaži samo rezultate pretrage
        results.forEach(songTile => {
            songTile.style.display = 'flex';
        });
        
        // Ažuriraj naslov i informacije
        pageTitle.textContent = `Search Results for "${query}"`;
        searchInfo.textContent = `Found ${results.length} result(s)`;
        searchInfo.style.display = 'block';
    }

    function displayNoResults(query) {
        // Sakrij sve pesme
        const allSongs = document.querySelectorAll('.song-tile');
        allSongs.forEach(song => song.style.display = 'none');
        
        // Prikaži poruku da nema rezultata
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
        // Prikaži sve pesme
        const allSongs = document.querySelectorAll('.song-tile');
        allSongs.forEach(song => song.style.display = 'flex');
        
        // Vrati originalni naslov
        pageTitle.textContent = 'Featured Tracks';
        searchInfo.style.display = 'none';
        
        // Vrati originalni grid ako je bio zamenjen sa no-results porukom
        if (!songGrid.querySelector('.song-tile')) {
            location.reload();
        }
    }

    // Clear search when clicking escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            searchInput.value = '';
            showAllSongs();
        }
    });

    // Initialize data attributes for all song tiles
    document.addEventListener('DOMContentLoaded', function() {
        const songTiles = document.querySelectorAll('.song-tile');
        songTiles.forEach(tile => {
            const title = tile.querySelector('.song-title').textContent;
            const artist = tile.querySelector('.song-meta:nth-child(2) span:nth-child(2)').textContent;
            const genre = tile.querySelector('.song-meta:nth-child(3) span:nth-child(2)').textContent;
            
            tile.setAttribute('data-title', title);
            tile.setAttribute('data-artist', artist);
            tile.setAttribute('data-genre', genre);
        });
    });
</script>
</body>
</html>