<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 获取广告位置参数
    String position = request.getParameter("position");
    String size = request.getParameter("size") != null ? request.getParameter("size") : "medium";
%>

<!-- 广告样式 -->
<style>
    .ad-wrapper {
        width: 100%;
        position: relative;
        overflow: hidden;
        transition: all 0.3s ease;
    }

    .ad-wrapper.header-position {
        min-height: 120px;
    }

    .ad-wrapper.sidebar-position {
        min-height: 600px;
    }

    .ad-wrapper.content-position {
        min-height: 100px;
    }

    .ad-wrapper.footer-position {
        min-height: 100px;
    }

    .ad-content {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 15px;
        text-align: center;
        border: 1px solid #e9ecef;
    }

    .ad-loading {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: loading 1.5s infinite;
    }

    .ad-error {
        padding: 20px;
        color: #856404;
        background-color: #fff3cd;
        border: 1px solid #ffeeba;
        border-radius: 8px;
        text-align: center;
        display: none;
    }

    .ad-close {
        position: absolute;
        top: 5px;
        right: 5px;
        cursor: pointer;
        background: rgba(0, 0, 0, 0.5);
        color: white;
        border: none;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        font-size: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1;
    }

    /* 响应式布局 */
    @media (max-width: 768px) {
        .ad-wrapper.header-position,
        .ad-wrapper.footer-position {
            min-height: 80px;
        }

        .ad-wrapper.sidebar-position {
            min-height: 300px;
        }

        .ad-content {
            padding: 10px;
        }
    }

    @keyframes loading {
        0% { background-position: 200% 0; }
        100% { background-position: -200% 0; }
    }

    /* 添加占位符样式 */
    .ad-placeholder {
        width: 100%;
        height: 100%;
        background-color: #f8f9fa;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 1px dashed #dee2e6;
    }
    
    .ad-placeholder-text {
        color: #6c757d;
        font-size: 14px;
    }
</style>

<!-- 广告容器 -->
<div class="ad-wrapper <%= position %>-position" id="ad-<%= position %>">
    <button class="ad-close" onclick="closeAd(this)" title="关闭广告">×</button>
    <div class="ad-loading" id="loading-<%= position %>"></div>
    <div class="ad-error" id="error-<%= position %>">
        广告加载失败，请稍后再试
    </div>
    <div class="ad-content" id="content-<%= position %>">
        <%
            String adServer = "112.124.63.147:8080";
            String userId = "3"; // 这里可以从 session 或参数中获取
            
            // 根据位置设置不同的广告尺寸
            String width = "100%";
            String height = "90px";
            
            if ("header".equals(position)) {
                height = "90px";
            } else if ("sidebar".equals(position)) {
                width = "300px";
                height = "600px";
            } else if ("content".equals(position)) {
                height = "250px";
            } else if ("footer".equals(position)) {
                height = "90px";
            } else if ("nav_bottom".equals(position)) {
                width = "100%";
                height = "60px";
            } else if ("article_top".equals(position) || "article_bottom".equals(position)) {
                width = "100%";
                height = "120px";
            } else if ("article_middle".equals(position) || "article_middle2".equals(position)) {
                width = "300px";
                height = "250px";
            } else if ("related_news_top".equals(position)) {
                width = "100%";
                height = "90px";
            } else if ("search_top".equals(position) || "search_bottom".equals(position)) {
                width = "100%";
                height = "90px";
            } else if ("pagination_top".equals(position)) {
                width = "100%";
                height = "90px";
            }
        %>
        <iframe 
            src="http://<%= adServer %>/news?userId=<%= userId %>&position=<%= position %>"
            width="<%= width %>" 
            height="<%= height %>"
            frameborder="0"
            scrolling="no"
            id="ad-frame-<%= position %>"
            style="display: none" <!-- 初始隐藏iframe -->

            onload="handleAdLoad(this)"
            onerror="handleAdError(this)">
        </iframe>
        <!-- 添加广告位占位符 -->
        <div class="ad-placeholder" id="placeholder-<%= position %>">
            <div class="ad-placeholder-text">广告位</div>
        </div>
    </div>
</div>

<!-- 广告处理脚本 -->
<script>
    // 广告加载完成后移除加载动画
    window.addEventListener('load', function() {
        const position = '<%= position %>';
        const loading = document.getElementById('loading-' + position);
        const content = document.getElementById('content-' + position);
        const error = document.getElementById('error-' + position);

        try {
            // 模拟广告加载
            setTimeout(() => {
                loading.style.display = 'none';
                content.style.display = 'block';
            }, 1000);
        } catch (e) {
            loading.style.display = 'none';
            error.style.display = 'block';
            console.error('广告加载失败:', e);
        }
    });

    // 关闭广告
    function closeAd(button) {
        const adWrapper = button.parentElement;
        adWrapper.style.display = 'none';
        
        // 可以在这里添加广告关闭的统计代码
        console.log('广告已关闭:', adWrapper.id);
    }

    // 处理广告 iframe 加载完成
    function handleAdLoad(iframe) {
        const position = iframe.id.replace('ad-frame-', '');
        const loading = document.getElementById('loading-' + position);
        const placeholder = document.getElementById('placeholder-' + position);
        
        try {
            // 检查iframe内容是否加载成功
            const iframeContent = iframe.contentWindow.document.body;
            if (iframeContent) {
                loading.style.display = 'none';
                placeholder.style.display = 'none';
                iframe.style.display = 'block';
                logAdImpression(position);
            } else {
                handleAdError(iframe);
            }
        } catch(e) {
            handleAdError(iframe);
        }
    }
    
    // 处理广告加载失败
    function handleAdError(iframe) {
        const position = iframe.id.replace('ad-frame-', '');
        const loading = document.getElementById('loading-' + position);
        const placeholder = document.getElementById('placeholder-' + position);
        
        loading.style.display = 'none';
        iframe.style.display = 'none';
        placeholder.style.display = 'block';
        
        // 只在控制台输出错误，不影响用户体验
        console.warn('广告加载失败:', position);
    }
    
    // 自适应 iframe 高度
    function adjustIframeHeight(iframe) {
        iframe.onload = function() {
            try {
                const height = iframe.contentWindow.document.body.scrollHeight;
                iframe.style.height = height + 'px';
            } catch(e) {
                console.warn('无法访问iframe内容:', e);
            }
        }
    }
    
    // 改进的广告展示统计
    function logAdImpression(position) {
        const data = {
            position: position,
            timestamp: new Date().toISOString(),
            url: window.location.href,
            userAgent: navigator.userAgent
        };
        
        // 修改 fetch 请求配置
        fetch('http://<%= adServer %>/ad/impression', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'  // 添加跨域头
            },
            mode: 'cors',  // 添加 cors 模式
            credentials: 'omit',  // 不发送 cookies
            body: JSON.stringify(data)
        }).catch(error => {
            console.warn('广告统计请求失败:', error);
            // 失败时静默处理，不影响用户体验
        });
    }
    
    // 添加广告可见性检测
    const observerOptions = {
        root: null,
        threshold: 0.5 // 当广告可见面积超过50%时触发
    };
    
    const adObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const position = entry.target.id.replace('ad-', '');
                logAdImpression(position);
                adObserver.unobserve(entry.target); // 只统计一次
            }
        });
    }, observerOptions);
    
    // 观察所有广告容器
    document.querySelectorAll('.ad-wrapper').forEach(ad => {
        adObserver.observe(ad);
    });
</script>

