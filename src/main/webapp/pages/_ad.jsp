<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="ad-wrapper ${param.position}-ad">
    <div class="ad-label">广告</div>
    <c:choose>
        <c:when test="${param.position eq 'header'}">
            <!-- 顶部横幅广告 -->
            <div class="banner-ad">
                <iframe src="https://your-ad-server.com/ads/header" 
                        width="100%" height="90px" 
                        frameborder="0"></iframe>
            </div>
        </c:when>
        <c:when test="${param.position eq 'sidebar'}">
            <!-- 侧边栏广告 -->
            <div class="sidebar-ad">
                <iframe src="https://your-ad-server.com/ads/sidebar" 
                        width="300px" height="600px" 
                        frameborder="0"></iframe>
            </div>
        </c:when>
        <c:when test="${param.position eq 'content'}">
            <!-- 文章内容广告 -->
            <div class="content-ad">
                <iframe src="https://your-ad-server.com/ads/content" 
                        width="100%" height="250px" 
                        frameborder="0"></iframe>
            </div>
        </c:when>
    </c:choose>
</div>

