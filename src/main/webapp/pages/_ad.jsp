<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="advertisement">
    <c:if test="${not empty ad}">
        <c:choose>
            <c:when test="${ad.type eq 'BANNER'}">
                <div class="banner-ad">
                    <a href="${ad.linkUrl}" target="_blank">
                        <img src="${ad.imageUrl}" alt="${ad.content}">
                    </a>
                </div>
            </c:when>
            <c:when test="${ad.type eq 'SCROLL_TEXT'}">
                <div class="scroll-text">
                    <marquee>
                        <a href="${ad.linkUrl}" target="_blank">${ad.content}</a>
                    </marquee>
                </div>
            </c:when>
            <c:when test="${ad.type eq 'FLOATING'}">
                <div class="floating-ad" id="floatingAd">
                    <span class="close-btn" onclick="closeFloatingAd()">&times;</span>
                    <a href="${ad.linkUrl}" target="_blank">
                        <img src="${ad.imageUrl}" alt="${ad.content}">
                    </a>
                </div>
            </c:when>
            <c:when test="${ad.type eq 'POPUP'}">
                <div class="popup-ad" id="popupAd">
                    <div class="popup-content">
                        <span class="close-btn" onclick="closePopupAd()">&times;</span>
                        <a href="${ad.linkUrl}" target="_blank">
                            <img src="${ad.imageUrl}" alt="${ad.content}">
                        </a>
                    </div>
                </div>
            </c:when>
        </c:choose>
    </c:if>
</div>

<script>
function closeFloatingAd() {
    document.getElementById('floatingAd').style.display = 'none';
}

function closePopupAd() {
    document.getElementById('popupAd').style.display = 'none';
}

// 延迟显示弹窗广告
setTimeout(function() {
    const popupAd = document.getElementById('popupAd');
    if (popupAd) {
        popupAd.style.display = 'block';
    }
}, 2000);
</script>
