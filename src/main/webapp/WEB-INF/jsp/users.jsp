<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        
        .admin-nav {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .admin-nav-btn {
            color: white;
            text-decoration: none;
            padding: 0.7rem 1.5rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            font-weight: bold;
            border: 2px solid transparent;
        }
        
        .admin-nav-btn.primary {
            background: #4CAF50;
            border-color: #45a049;
        }
        
        .admin-nav-btn.secondary {
            background: #3742fa;
            border-color: #2f36d4;
        }
        
        .admin-nav-btn.warning {
            background: #ffa502;
            border-color: #e69500;
        }
        
        .admin-nav-btn.danger {
            background: #ff4757;
            border-color: #e84118;
        }
        
        .admin-nav-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: rgba(255,255,255,0.1);
            padding: 1.5rem;
            border-radius: 10px;
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: #ccc;
            font-size: 0.9rem;
        }
        
        .users-table {
            width: 100%;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            overflow: hidden;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 2rem;
        }
        
        .users-table th {
            background: rgba(255,255,255,0.2);
            padding: 1rem;
            text-align: left;
            font-weight: bold;
            color: white;
        }
        
        .users-table td {
            padding: 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .users-table tr:last-child td {
            border-bottom: none;
        }
        
        .users-table tr:hover {
            background: rgba(255,255,255,0.05);
        }
        
        .user-role-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
            text-align: center;
            display: inline-block;
        }
        
        .role-admin {
            background: #ff4757;
        }
        
        .role-artist {
            background: #4CAF50;
        }
        
        .role-user {
            background: #3742fa;
        }
        
        .status-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
            text-align: center;
            display: inline-block;
        }
        
        .status-active {
            background: #4CAF50;
        }
        
        .status-inactive {
            background: #747d8c;
        }
        
        .action-btn {
            padding: 0.4rem 0.8rem;
            border: none;
            border-radius: 15px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            margin: 0 0.2rem;
            transition: all 0.3s ease;
        }
        
        .action-btn.activate {
            background: #4CAF50;
            color: white;
        }
        
        .action-btn.deactivate {
            background: #ff4757;
            color: white;
        }
        
        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        
        .success-message {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            text-align: center;
            border: 1px solid rgba(76, 175, 80, 0.5);
        }
        
        .date-time {
            font-size: 0.85rem;
            color: #ccc;
        }
        
        .bottom-nav {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }
        
        .bottom-nav-btn {
            color: white;
            text-decoration: none;
            padding: 0.7rem 1.5rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            font-weight: bold;
            border: 2px solid transparent;
            background: rgba(255,255,255,0.2);
        }
        
        .bottom-nav-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<header>
    <h1>🎧 MusicHub 
        <c:if test="${isAdmin}">
            <span style="background: #ff4757; color: white; padding: 0.3rem 0.8rem; border-radius: 15px; font-size: 0.8rem; margin-left: 0.5rem;">ADMIN PANEL</span>
        </c:if>
    </h1>
    <div>
        <a href="/" style="color: #222; text-decoration: none; background: rgba(255,255,255,0.8); padding: 0.5rem 1rem; border-radius: 20px; margin-right: 1rem;">← Back to Site</a>
        <form action="/logout" method="post" style="display: inline;">
            <button type="submit" style="background: #ff4757; color: white; border: none; padding: 0.5rem 1rem; border-radius: 20px; cursor: pointer; font-weight: bold;">Logout</button>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
    </div>
</header>

<main>
    <c:if test="${isAdmin}">
        <div class="admin-nav">
            <a href="/admin/register-user" class="admin-nav-btn primary">👤 Add New User</a>
        </div>
    </c:if>

    <c:if test="${param.activated != null}">
        <div class="success-message">
            ✅ User activated successfully!
        </div>
    </c:if>
    
    <c:if test="${param.deactivated != null}">
        <div class="success-message">
            ✅ User deactivated successfully!
        </div>
    </c:if>

    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-number">${totalUsers}</div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${totalArtists}</div>
            <div class="stat-label">Artists</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${totalRegularUsers}</div>
            <div class="stat-label">Regular Users</div>
        </div>
    </div>

    <h2>All Users</h2>
    
    <table class="users-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Registered</th>
                <c:if test="${isAdmin}">
                    <th>Actions</th>
                </c:if>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.id}</td>
                    <td><strong>${user.username}</strong></td>
                    <td>${user.firstName} ${user.lastName}</td>
                    <td>${user.email}</td>
                    <td>
                        <c:choose>
                            <c:when test="${user.isAdmin}">
                                <span class="user-role-badge role-admin">Administrator</span>
                            </c:when>
                            <c:when test="${user.isArtist}">
                                <span class="user-role-badge role-artist">Artist</span>
                            </c:when>
                            <c:otherwise>
                                <span class="user-role-badge role-user">Registered User</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${user.isActive}">
                                <span class="status-badge status-active">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactive">Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${user.createdAt != null}">
                                <div class="date-time">
                                    ${fn:substring(user.createdAt.toString(), 0, 10)} 
                                    ${fn:substring(user.createdAt.toString(), 11, 19)}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="date-time">N/A</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <c:if test="${isAdmin}">
                        <td>
                            <c:choose>
                                <c:when test="${user.isActive && !user.isAdmin}">
                                    <form action="/admin/users/${user.id}/deactivate" method="post" style="display: inline;">
                                        <button type="submit" class="action-btn deactivate">Deactivate</button>
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    </form>
                                </c:when>
                                <c:when test="${!user.isActive && !user.isAdmin}">
                                    <form action="/admin/users/${user.id}/activate" method="post" style="display: inline;">
                                        <button type="submit" class="action-btn activate">Activate</button>
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #ccc;">No actions</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="bottom-nav">
        <a href="/" class="bottom-nav-btn">🏠 Back to Dashboard</a>
    </div>
</main>
</body>
</html>