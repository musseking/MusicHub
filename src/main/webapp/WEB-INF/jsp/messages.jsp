<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        
        .messages-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .messages-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            background: rgba(255, 255, 255, 0.1);
            padding: 1.5rem;
            border-radius: 10px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .stats {
            display: flex;
            gap: 2rem;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            display: block;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #ccc;
        }
        
        .message-list {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            overflow: hidden;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .message-item {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: background 0.3s ease;
        }
        
        .message-item:last-child {
            border-bottom: none;
        }
        
        .message-item:hover {
            background: rgba(255, 255, 255, 0.05);
        }
        
        .message-item.unread {
            background: rgba(74, 144, 226, 0.2);
            border-left: 4px solid #4a90e2;
        }
        
        .message-item.unread:hover {
            background: rgba(74, 144, 226, 0.3);
        }
        
        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }
        
        .message-sender {
            font-weight: bold;
            font-size: 1.1rem;
            color: #4CAF50;
        }
        
        .message-date {
            color: #ccc;
            font-size: 0.9rem;
        }
        
        .message-subject {
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            color: white;
        }
        
        .message-content {
            color: #e0e0e0;
            line-height: 1.5;
            margin-bottom: 1rem;
        }
        
        .message-actions {
            display: flex;
            gap: 1rem;
        }
        
        .action-btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: bold;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .read-btn {
            background: #4CAF50;
            color: white;
        }
        
        .read-btn:hover {
            background: #45a049;
            transform: translateY(-1px);
        }
        
        .delete-btn {
            background: #ff4757;
            color: white;
        }
        
        .delete-btn:hover {
            background: #e84118;
            transform: translateY(-1px);
        }
        
        .no-messages {
            text-align: center;
            padding: 3rem;
            color: #ccc;
            font-style: italic;
        }
        
        .back-link {
            display: inline-block;
            color: #222;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.8);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            margin-right: 1rem;
            transition: all 0.3s ease;
        }
        
        .back-link:hover {
            background: rgba(255, 255, 255, 1);
            transform: translateY(-1px);
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
    </style>
</head>
<body>
    <header>
        <h1>🎧 MusicHub</h1>
        <div>
            <a href="/" class="back-link">← Back to Site</a>
            <form action="/logout" method="post" style="display: inline;">
                <button type="submit" style="background: #ff4757; color: white; border: none; padding: 0.5rem 1rem; border-radius: 20px; cursor: pointer; font-weight: bold;">Logout</button>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </form>
        </div>
    </header>

    <main class="messages-container">
        <div class="messages-header">
            <h2>📨 My Messages</h2>
            <div class="stats">
                <div class="stat-item">
                    <span class="stat-number">${totalCount}</span>
                    <span class="stat-label">Total Messages</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">${unreadCount}</span>
                    <span class="stat-label">Unread</span>
                </div>
            </div>
        </div>

        <c:if test="${param.marked != null}">
            <div class="success-message">
                ✅ Message marked as read!
            </div>
        </c:if>
        
        <c:if test="${param.deleted != null}">
            <div class="success-message">
                ✅ Message deleted successfully!
            </div>
        </c:if>

        <div class="message-list">
            <c:choose>
                <c:when test="${not empty messages}">
                    <c:forEach var="message" items="${messages}">
                        <div class="message-item ${message.isRead ? '' : 'unread'}">
                            <div class="message-header">
                                <div class="message-sender">
                                    From: ${message.sender.fullName} (@${message.sender.username})
                                </div>
                                <div class="message-date">
								    ${message.createdAt.toLocalDate()} at ${message.createdAt.toLocalTime()}
								</div>
                            </div>
                            
                            <div class="message-subject">
                                ${message.subject}
                            </div>
                            
                            <div class="message-content">
                                ${message.content}
                            </div>
                            
                            <div class="message-actions">
                                <c:if test="${not message.isRead}">
                                    <form action="/messages/${message.id}/read" method="post" style="display: inline;">
                                        <button type="submit" class="action-btn read-btn">Mark as Read</button>
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    </form>
                                </c:if>
                                <form action="/messages/${message.id}/delete" method="post" style="display: inline;">
                                    <button type="submit" class="action-btn delete-btn" onclick="return confirm('Are you sure you want to delete this message?')">Delete</button>
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-messages">
                        <div style="font-size: 4rem; margin-bottom: 1rem;">📭</div>
                        <div style="font-size: 1.2rem;">No messages yet</div>
                        <div style="margin-top: 0.5rem;">Your messages will appear here when you receive them.</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>