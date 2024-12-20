<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="advertisement">
    <!-- 调试输出广告对象 -->
    <p>广告类型: ${ad.type}</p>
    <p>广告链接: ${ad.link}</p>
    <p>广告内容: ${ad.content}</p>

    <c:choose>
        <!-- Banner广告 -->
        <c:when test="${ad.type == 'banner'}">
            <a href="${ad.link}" target="_blank">
                <img src="${ad.content}" alt="Banner广告" style="width:100%; height:auto;">
            </a>
        </c:when>

        <!-- Logo广告 -->
        <c:when test="${ad.type == 'logo'}">
            <a href="${ad.link}" target="_blank">
                <img src="${ad.content}" alt="Logo广告" style="width:150px; height:auto;">
            </a>
        </c:when>

        <!-- 滚动字幕 -->
        <c:when test="${ad.type == 'scroll'}">
            <marquee style="font-size:18px; color:#FF0000;">
                    ${ad.content}
            </marquee>
        </c:when>

        <!-- 弹出窗口广告 -->
        <c:when test="${ad.type == 'popup'}">
            <a href="${ad.link}" target="_blank" class="popup-ad">
                    ${ad.content}
            </a>
        </c:when>

        <!-- 浮动广告 -->
        <c:when test="${ad.type == 'floating'}">
            <a href="${ad.link}" target="_blank">
                <img src="${ad.content}" alt="浮动广告" class="floating-ad">
            </a>
        </c:when>

        <!-- 如果没有匹配的广告类型，则显示默认提示 -->
        <c:otherwise>
            <p>没有找到匹配的广告类型</p>
        </c:otherwise>
    </c:choose>
</div>
