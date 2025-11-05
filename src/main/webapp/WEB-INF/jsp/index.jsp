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
        
        .download-info {
            margin-top: 0.5rem;
            padding: 0.5rem;
            border-radius: 5px;
            background: rgba(255,255,255,0.1);
        }
        
        .preview-link {
            color: #4CAF50;
            text-decoration: none;
            margin-right: 1rem;
        }
        
        .preview-link:hover {
            text-decoration: underline;
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
        <c:choose>
            <c:when test="${isLoggedIn}">
                <!-- PRIKAZ ZA ULOGOVANE KORISNIKE -->
                <div class="user-info-container">
                    <div class="username">${displayName}</div>
                    <div class="user-role-badge ${loggedUserRole.toLowerCase()}">
                        ${loggedDisplayRole}
                    </div>
                </div>
                
                <!-- DODATO: Poseban prikaz za ADMIN korisnike -->
                <sec:authorize access="hasRole('ADMIN')">
                    <div class="admin-buttons">
                        <a href="/admin/users" class="show-users-btn">
                            👥 Show All Users
                        </a>
                        <form action="/logout" method="post" style="display: inline; margin: 0;">
                            <button type="submit" class="logout-btn">Logout</button>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </form>
                    </div>
                </sec:authorize>
                
                <!-- PRIKAZ ZA OSTALE ULOGOVANE KORISNIKE (NON-ADMIN) -->
                <sec:authorize access="!hasRole('ADMIN')">
                    <form action="/logout" method="post" style="display: inline; margin: 0;">
                        <button type="submit" class="logout-btn">Logout</button>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </form>
                </sec:authorize>
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
    <h2>Featured Tracks</h2>
    
    <div class="song-list">
        <c:forEach var="song" items="${songs}">
            <div class="song-item">
                <c:if test="${not empty song.coverImage}">
                    <img src="${song.coverImage}" alt="${song.title}">
                </c:if>
                <div class="song-info">
                    <div class="song-title">${song.title}</div>
                    <div>🎤 Artist: ${song.artist.fullName}</div>
                    <div>🎵 Genre: ${song.genre.name}</div>
                    <c:if test="${song.album != null}">
                        <div>📀 Album: ${song.album.title}</div>
                    </c:if>
                    <div>⏱️ ${song.duration} sec</div>
                    
                    <div class="download-info">
                        <!-- Preview uvek dostupan svima -->
                        <a href="/preview/${song.id}" class="preview-link">🎧 Preview (30s)</a>
                        
                        <!-- Download samo za registrovane -->
                        <c:choose>
                            <c:when test="${song.allowDownload}">
                                <c:choose>
                                    <c:when test="${isLoggedIn}">
                                        <a href="/download/${song.id}" style="color: #4CAF50;">📥 Download Full Track</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #ccc;">📥 Register to Download</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #ff4757;">🚫 Download Not Available</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</main>
</body>
</html>