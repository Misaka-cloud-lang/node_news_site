<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 在头部添加 Bootstrap Icons CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top" style="position: fixed; top: 0; width: 100%; z-index: 1030;">
    <div class="container-fluid px-4">
        <!-- 左半部分：Logo和时间天气 -->
        <div class="d-flex">
            <!-- Logo保持原样 -->
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
                <i class="bi bi-newspaper"></i> USST NEWS
            </a>

            <!-- 时间天气信息-两行显示 -->
            <div class="datetime-weather d-none d-lg-flex flex-column justify-content-center ms-3">
                <!-- 第一行：日期 -->
                <div class="navbar-text text-white">
                    <i class="bi bi-calendar-event me-1"></i>
                    <span id="currentDate"></span>
                </div>
                <!-- 第二行：时间和天气 -->
                <div class="navbar-text text-white d-flex">
                    <span class="me-3">
                        <i class="bi bi-clock me-1"></i>
                        <span id="currentTime"></span>
                    </span>
                    <span>
                        <i class="bi bi-cloud-sun me-1"></i>
                        <span id="weather">上海</span>
                    </span>
                </div>
            </div>
        </div>

        <!-- 右半部分：分类导航和搜索框 -->
        <div class="navbar-right d-flex align-items-center">
            <!-- 分类导航 -->
            <ul class="navbar-nav categories-nav me-2 flex-row flex-nowrap">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=国内">国内</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=国际">国际</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=财经">财经</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=科技">科技</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=军事">军事</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=体育">体育</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=娱乐">娱乐</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=社会">社会</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=股市">股市</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=美股">美股</a>
                </li>
            </ul>

            <!-- 搜索框 -->
            <div class="search-wrapper">
                <form class="d-flex ms-auto" action="${pageContext.request.contextPath}/pages/searchResults.jsp" method="get">
                    <input class="form-control me-2" type="text" name="query" 
                           value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>"
                           placeholder="搜索新闻" required>
                    <button class="btn btn-outline-light" type="submit">搜索</button>
                </form>
            </div>
        </div>
    </div>
</nav>

<script src="${pageContext.request.contextPath}/js/common.js" defer></script>
<script>
    // 使用和风天气 API
    function getWeather() {
        const KEY = '你的和风天气API密钥';
        const url = `https://devapi.qweather.com/v7/weather/now?location=101020100&key=${KEY}`;
        
        fetch(url)
            .then(response => response.json())
            .then(data => {
                if (data.code === '200') {
                    const weather = data.now;
                    document.getElementById('weather').textContent = 
                        `上海 ${weather.temp}��C ${weather.text}`;
                }
            })
            .catch(error => {
                console.error('获取天气信息失败:', error);
                document.getElementById('weather').textContent = '上海';
            });
    }

    // 只在页面加载完成后获取一次天气
    window.addEventListener('load', getWeather);
</script> 