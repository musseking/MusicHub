<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        }
        header {
            background: rgba(0,0,0,0.8);
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        .song-list {
            display: grid;
            gap: 1rem;
            margin-top: 2rem;
        }
        .song-item {
            background: rgba(255,255,255,0.1);
            padding: 1rem;
            border-radius: 10px;
            display: flex;
            gap: 1rem;
            align-items: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }
        .song-item img {
            border-radius: 8px;
            width: 120px;
            height: 120px;
            object-fit: cover;
        }
        .song-info {
            flex: 1;
        }
        .song-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
<header>
    <h1>🎧 MusicHub</h1>
    <div>
        <a href="/login" style="color: white; text-decoration: none;">Login</a>
    </div>
</header>

<main>
    <h2>Featured Tracks</h2>
    
    <div class="song-list">
        <c:forEach var="song" items="${songs}">
            <div class="song-item">
<%--                 <img src="${song.coverImage}" alt="${song.title}"  --%>
<!--                      onerror="this.src='https://via.placeholder.com/120x120/333/fff?text=No+Image'"/> -->
                <div class="song-info">
                    <div class="song-title">${song.title}</div>
                    <div>🎤 Artist: ${song.artist.fullName}</div>
                    <div>🎵 Genre: ${song.genre.name}</div>
                    <c:if test="${song.album != null}">
                        <div>📀 Album: ${song.album.title}</div>
                    </c:if>
                    <div>⏱️ ${song.duration} sec</div>
                    <div style="margin-top: 0.5rem;">
                        <c:choose>
                            <c:when test="${song.allowDownload}">📥 Downloadable</c:when>
                            <c:otherwise>🚫 No Download</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</main>
</body>
</html>