<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-newspaper"></i> USST NEWS
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- 添加时间和天气信息 -->
        <div class="navbar-text text-white me-3 d-none d-lg-block">
            <i class="bi bi-calendar-event"></i>
            <span id="currentDate"></span>
            <i class="bi bi-clock ms-3"></i>
            <span id="currentTime"></span>
            <i class="bi bi-cloud-sun ms-3"></i>
            <span id="weather">上海</span>
        </div>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">
                        <i class="bi bi-house-door"></i> 首页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=国内">国内</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=国际">国际</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=体育">体育</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=科技">科技</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=娱乐">娱乐</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=财经">财经</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pages/newsList.jsp?category=军事">军事</a>
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
            
            <!-- 添加搜索框 -->
            <form class="d-flex" action="${pageContext.request.contextPath}/pages/searchResults.jsp" method="get">
                <input class="form-control me-2" type="text" name="query" 
                       value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>"
                       placeholder="搜索新闻" required>
                <button class="btn btn-outline-light" type="submit">
                    <i class="bi bi-search"></i>
                </button>
            </form>
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
                        `上海 ${weather.temp}°C ${weather.text}`;
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