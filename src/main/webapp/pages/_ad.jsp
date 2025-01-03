<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String position = request.getParameter("position");
    String template = request.getParameter("template");
    if (template == null) {
        template = "inFeed";  // 设置默认值
    }
    String adServer = "112.124.63.147:8080";

    // 获取广告位置参数
    int adLocation = 0;
    if (application.getAttribute("currentAdIndex") == null) {
        application.setAttribute("currentAdIndex", 0);
    } else {
        adLocation = (Integer) application.getAttribute("currentAdIndex");
        // 递增广告位置索引
        adLocation = adLocation + 1;
        application.setAttribute("currentAdIndex", adLocation);
    }

    int userId;
    try {
        userId = (int) session.getAttribute("userId");
    } catch (Exception e) {
        userId = 0;
    }

    // 构建广告URL，添加adLocation参数
    String adUrl = String.format("http://%s/api/ad/news?userId=%d&adLocation=%d",
            adServer, userId, adLocation);

    // 广告模板配置
    String width = "100%";
    String height = "90px";
    String className = "";

    // 添加null检查
    switch (template) {
        case "topBanner":
            height = "120px";
            className = "top-banner-ad";
            break;
        case "sidebar":
            width = "300px";
            height = "600px";
            className = "sidebar-ad";
            break;
        case "inFeed":
            height = "200px";
            className = "in-feed-ad";
            break;
        case "bottomBanner":
            height = "100px";
            className = "bottom-banner-ad";
            break;
        default:
            height = "90px";
            className = "default-ad";
            break;
    }
%>

<div class="ad-wrapper <%= className %>" id="ad-<%= position %>">
    <button class="ad-close" onclick="closeAd(this)" title="关闭广告">
        <i class="bi bi-x"></i>
    </button>

    <div class="ad-label">
        <i class="bi bi-badge-ad"></i>
        <span>广告</span>
    </div>

    <div class="ad-content" id="ad-main-div"
         onload="fetchAdHTML('<%=adUrl%>')"
    >
        <iframe
                src="<%= adUrl %>"
                width="<%= width %>"
                height="<%= height %>"
                frameborder="0"
                scrolling="no"
                onload="checkAdContent(this)"
                onerror="handleAdError(this)"
        >
        </iframe>
    </div>
    <script>
        function fetchAdHTML(url) {
            fetch(url)
                .then(response => response.text())
                .then(html => {
                    const adContent = document.getElementById("ad-main-div");
                    adContent.innerHTML = html;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }
    </script>

    <div class="ad-placeholder" style="display: none;">
        <div class="placeholder-content">
            <i class="bi bi-building"></i>
            <h5>广告位招租</h5>
            <p>联系电话：021-12345678</p>
            <button class="btn btn-sm btn-outline-primary" onclick="contactUs()">
                立即咨询
            </button>
            <div class="error-message text-danger small mt-2"></div>
        </div>
    </div>
</div>

<style>
    .ad-wrapper {
        margin: 15px 0;
        overflow: hidden;
        transition: all 0.3s ease;
        background: #f8f9fa;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        position: relative;
        min-height: 90px;
    }

    /* 添加广告关闭后的样式 */
    .ad-wrapper.ad-closed {
        margin: 0 !important;
        min-height: 0 !important;
        height: 0 !important;
        padding: 0 !important;
        border: none !important;
        overflow: hidden;
    }

    /* 侧边栏广告特殊处理 */
    .sidebar-ad.ad-closed {
        position: static !important;
        margin: 0 !important;
    }

    /* 底部通栏广告特殊处理 */
    .bottom-banner-ad.ad-closed {
        display: none !important;
    }

    .ad-label {
        position: absolute;
        top: 5px;
        right: 5px;
        background: rgba(0, 0, 0, 0.4);
        color: rgba(255, 255, 255, 0.9);
        padding: 3px 8px;
        font-size: 12px;
        border-radius: 4px;
        z-index: 1;
        backdrop-filter: blur(4px);
        display: flex;
        align-items: center;
        gap: 4px;
        transition: opacity 0.3s ease;
    }

    /* 鼠标悬停时降低标签透明度 */
    .ad-wrapper:hover .ad-label {
        opacity: 0.7;
    }

    /* 广告占位样式 */
    .ad-placeholder {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #f8f9fa;
        border: 2px dashed #dee2e6;
        border-radius: 8px;
        text-align: center;
        padding: 20px;
    }

    .placeholder-content {
        color: #6c757d;
    }

    .placeholder-content i {
        font-size: 32px;
        margin-bottom: 10px;
        color: #adb5bd;
    }

    .placeholder-content h5 {
        margin-bottom: 8px;
        color: #495057;
    }

    .placeholder-content p {
        font-size: 14px;
        margin-bottom: 12px;
    }

    /* 顶部通栏广告 */
    .top-banner-ad {
        width: 100%;
        margin: 0 0 20px 0;
        background: #fff;
        border-bottom: 1px solid #eee;
    }

    /* 侧边栏广告 */
    .sidebar-ad {
        position: sticky;
        top: 80px;
        margin: 0 0 20px 0;
        border: 1px solid rgba(0, 0, 0, 0.1);
        background: white;
    }

    /* 信息流广告 */
    .in-feed-ad {
        margin: 20px auto;
        max-width: 100%;
        background: white;
        border: 1px solid rgba(0, 0, 0, 0.1);
    }

    /* 右侧悬浮广告 */
    .float-right-ad {
        position: fixed;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
        z-index: 999;
    }

    /* 左侧悬浮广告 */
    .float-left-ad {
        position: fixed;
        left: 10px;
        top: 50%;
        transform: translateY(-50%);
        z-index: 999;
    }

    /* 底部通栏广告 */
    .bottom-banner-ad {
        width: 100%;
        position: fixed;
        bottom: 0;
        left: 0;
        z-index: 999;
        background: white;
        border-top: 1px solid rgba(0, 0, 0, 0.1);
        box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
    }

    /* 响应式调整 */
    @media (max-width: 768px) {
        .float-left-ad, .float-right-ad {
            display: none; /* 移动端隐藏悬浮广告 */
        }

        .sidebar-ad {
            position: static;
            width: 100%;
            height: 250px;
            margin: 15px 0;
        }

        .bottom-banner-ad {
            height: 60px;
        }
    }

    /* 添加关闭按钮样式 */
    .ad-close {
        position: absolute;
        top: 5px;
        left: 5px;
        width: 24px;
        height: 24px;
        border: none;
        background: rgba(0, 0, 0, 0.4);
        color: white;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 2;
        transition: all 0.3s ease;
    }

    .ad-close:hover {
        background: rgba(0, 0, 0, 0.6);
        transform: scale(1.1);
    }
</style>

<script>
    function checkAdContent(iframe) {
        try {
            // 添加超时检查
            setTimeout(() => {
                try {
                    const iframeContent = iframe.contentDocument || iframe.contentWindow.document;
                    if (!iframeContent || !iframeContent.body.innerHTML.trim()) {
                        console.error('[Ad] 广告加载超时或内容为空');
                        // 不显示占位内容，而是重试加载广告
                        retryLoadAd(iframe);
                    }
                } catch (e) {
                    console.error('[Ad] 广告加载失败:', e);
                    retryLoadAd(iframe);
                }
            }, 300000);
        } catch (e) {
            console.error('[Ad] 广告加载出错:', e);
            retryLoadAd(iframe);
        }
    }

    // 添加重试加载广告的函数
    function retryLoadAd(iframe) {
        const currentLocation = parseInt(new URLSearchParams(iframe.src).get('adLocation'));
        // 尝试加载下一个位置的广告
        const newLocation = currentLocation + 1;
        const newSrc = iframe.src.replace(`adLocation=${currentLocation}`, `adLocation=${newLocation}`);
        iframe.src = newSrc;
    }

    // 修改错误处理函数
    function handleAdError(iframe) {
        // 不再显示占位内容，而是重试加载
        retryLoadAd(iframe);
    }

    // 关闭广告
    function closeAd(button) {
        const wrapper = button.closest('.ad-wrapper');
        if (wrapper) {
            // 添加关闭类名
            wrapper.classList.add('ad-closed');

            // 淡出动画
            wrapper.style.opacity = '0';
            setTimeout(() => {
                wrapper.style.height = '0';
                wrapper.style.margin = '0';
                wrapper.style.padding = '0';
            }, 300);
        }
    }

    // 联系我们
    function contactUs() {
        alert('请联系我们的广告部门\n电话：021-12345678\n邮箱：ad@example.com');
    }
</script>


