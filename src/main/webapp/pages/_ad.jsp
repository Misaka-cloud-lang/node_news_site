<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 顶部通栏广告 -->
<div class="ad-container header-ad">
    <c:if test="${not empty headerAd}">
        <c:choose>
            <c:when test="${headerAd.type eq 'BANNER'}">
                <div class="banner-ad">
                    <a href="${headerAd.linkUrl}" target="_blank">
                        <img src="${headerAd.imageUrl}" alt="${headerAd.content}">
                    </a>
                </div>
            </c:when>
            <c:when test="${headerAd.type eq 'SCROLL_TEXT'}">
                <div class="scroll-text">
                    <marquee scrollamount="5">
                        <span class="hot-tag">🔥爆</span>
                        <a href="${headerAd.linkUrl}" target="_blank">${headerAd.content}</a>
                    </marquee>
                </div>
            </c:when>
        </c:choose>
    </c:if>
</div>

<!-- 轮播广告 -->
<div class="ad-container carousel-ad">
    <c:if test="${not empty carouselAd}">
        <div class="carousel-wrapper" id="adCarousel">
            <div class="carousel-items">
                <a href="${carouselAd.linkUrl}" target="_blank">
                    <img src="${carouselAd.imageUrl}" alt="${carouselAd.content}">
                </a>
            </div>
        </div>
    </c:if>
</div>

<!-- 侧边栏广告 -->
<div class="ad-container sidebar-ad">
    <c:if test="${not empty sidebarAd}">
        <c:choose>
            <c:when test="${sidebarAd.type eq 'FLOATING'}">
                <div class="floating-ad" id="floatingAd">
                    <span class="close-btn" onclick="closeFloatingAd()">&times;</span>
                    <div class="ad-tag">广告</div>
                    <a href="${sidebarAd.linkUrl}" target="_blank">
                        <img src="${sidebarAd.imageUrl}" alt="${sidebarAd.content}">
                    </a>
                </div>
            </c:when>
            <c:when test="${sidebarAd.type eq 'POPUP'}">
                <div class="popup-ad" id="popupAd">
                    <div class="popup-content">
                        <span class="close-btn" onclick="closePopupAd()">&times;</span>
                        <div class="ad-tag">限时优惠</div>
                        <a href="${sidebarAd.linkUrl}" target="_blank">
                            <img src="${sidebarAd.imageUrl}" alt="${sidebarAd.content}">
                        </a>
                        <div class="countdown">剩余 <span id="countdown">05:00</span></div>
                    </div>
                </div>
            </c:when>
        </c:choose>
    </c:if>
</div>

<!-- 内容区广告 -->
<div class="ad-container content-ad">
    <c:if test="${not empty contentAd}">
        <div class="large-image-ad">
            <div class="ad-tag">推广</div>
            <a href="${contentAd.linkUrl}" target="_blank">
                <img src="${contentAd.imageUrl}" alt="${contentAd.content}">
                <div class="ad-description">${contentAd.content}</div>
            </a>
        </div>
    </c:if>
</div>

<!-- 右下角悬浮广告 -->
<div class="corner-float-ad" id="cornerAd">
    <c:if test="${not empty cornerAd}">
        <div class="corner-content">
            <span class="close-btn" onclick="closeCornerAd()">&times;</span>
            <div class="qr-code">
                <img src="${cornerAd.imageUrl}" alt="扫码下载">
            </div>
            <div class="ad-text">${cornerAd.content}</div>
        </div>
    </c:if>
</div>

<!-- 底部固定广告 -->
<div class="fixed-bottom-ad" id="bottomAd">
    <c:if test="${not empty bottomAd}">
        <div class="bottom-content">
            <span class="close-btn" onclick="closeBottomAd()">&times;</span>
            <a href="${bottomAd.linkUrl}" target="_blank">
                <img src="${bottomAd.imageUrl}" alt="${bottomAd.content}">
            </a>
        </div>
    </c:if>
</div>

<!-- 广告控制脚本 -->
<script>
// 关闭按钮功能
function closeFloatingAd() {
    document.getElementById('floatingAd').style.display = 'none';
}

function closePopupAd() {
    document.getElementById('popupAd').style.display = 'none';
}

function closeCornerAd() {
    document.getElementById('cornerAd').style.display = 'none';
}

function closeBottomAd() {
    document.getElementById('bottomAd').style.display = 'none';
}

// 延迟显示弹窗广告
setTimeout(function() {
    const popupAd = document.getElementById('popupAd');
    if (popupAd) {
        popupAd.style.display = 'block';
    }
}, 2000);

// 浮动广告随机位置
function randomFloatingPosition() {
    const floatingAd = document.getElementById('floatingAd');
    if (floatingAd) {
        const maxX = window.innerWidth - floatingAd.offsetWidth - 50;
        const maxY = window.innerHeight - floatingAd.offsetHeight - 50;
        const randomX = Math.floor(Math.random() * maxX);
        const randomY = Math.floor(Math.random() * maxY);
        floatingAd.style.left = randomX + 'px';
        floatingAd.style.top = randomY + 'px';
    }
}

// 倒计时功能
function startCountdown() {
    let time = 300; // 5分钟
    const countdownElement = document.getElementById('countdown');
    const countdownInterval = setInterval(function() {
        time--;
        const minutes = Math.floor(time / 60);
        const seconds = time % 60;
        countdownElement.textContent = 
            (minutes < 10 ? '0' + minutes : minutes) + ':' + 
            (seconds < 10 ? '0' + seconds : seconds);
        if (time <= 0) {
            clearInterval(countdownInterval);
            closePopupAd();
        }
    }, 1000);
}

// 初始化
window.onload = function() {
    setInterval(randomFloatingPosition, 3000);
    startCountdown();
};
</script>
