<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>在线新闻网站</title>

    <!-- 引入 Bootstrap CSS 和 JS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 自定义样式 -->
    <style>
        .carousel-item img {
            width: 100%;
            height: 500px;
            object-fit: cover;
        }
        footer {
            background-color: #f8f9fa;
            padding: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<!-- 头部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">usst在线新闻网站</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="index.jsp">首页</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=国内">国内</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=国际">国际</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=体育">体育</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=科技">科技</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=娱乐">娱乐</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=财经">财经</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=军事">军事</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=社会">社会</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=股市">股市</a></li>
                <li class="nav-item"><a class="nav-link" href="news?category=美股">美股</a></li>
            </ul>
            <form class="d-flex ms-auto" action="${pageContext.request.contextPath}/news" method="get">
                <input class="form-control me-2" type="text" name="query" placeholder="搜索新闻" required>
                <button class="btn btn-outline-light" type="submit">搜索</button>
            </form>
        </div>
    </div>
</nav>

<!-- 轮播图 -->
<div id="newsCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://p3.img.cctvpic.com/photoworkspace/2024/12/18/2024121817482356356.jpg" alt="国内新闻">
            <div class="carousel-caption d-none d-md-block">
                <h5>国内新闻</h5>
                <p>聚焦国内热点新闻，关心社会动态。</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://p3.img.cctvpic.com/photoworkspace/2024/12/18/2024121811410555141.jpg" alt="国际新闻">
            <div class="carousel-caption d-none d-md-block">
                <h5>国际新闻</h5>
                <p>了解全球事件，拓展国际视野。</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://p4.img.cctvpic.com/photoworkspace/2024/12/18/2024121818033116098.png" alt="科技新闻">
            <div class="carousel-caption d-none d-md-block">
                <h5>科技新闻</h5>
                <p>探索前沿科技，畅想未来生活。</p>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#newsCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#newsCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>

<!-- 新闻分类 -->
<div class="container mt-4">
    <h4>新闻分类</h4>
    <div class="row">
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=国内" class="btn btn-outline-primary d-block">国内新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=国际" class="btn btn-outline-success d-block">国际新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=经济" class="btn btn-outline-danger d-block">经济新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=科技" class="btn btn-outline-warning d-block">科技新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=娱乐" class="btn btn-outline-info d-block">娱乐新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=体育" class="btn btn-outline-dark d-block">体育新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=教育" class="btn btn-outline-secondary d-block">教育新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=健康" class="btn btn-outline-info d-block">健康新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=文化" class="btn btn-outline-warning d-block">文化新闻</a></div>
        <div class="col-md-3"><a href="${pageContext.request.contextPath}/news?category=军事" class="btn btn-outline-danger d-block">军事新闻</a></div>
    </div>
</div>

<!-- 最新新闻 -->
<div class="container mt-4">
    <h4>最新新闻</h4>
    <div class="row" id="newsList">
        <%
            NewsService newsService = new NewsService();
            List<News> latestNews = newsService.getAllNews();
            for (News news : latestNews) {
        %>
        <div class="col-md-4 mb-4">
            <div class="card">
                <img src="<%= news.getImage() %>" class="card-img-top" alt="新闻图片" onerror="this.src='/news_system/images/default.jpg'">
                <div class="card-body">
                    <h5 class="card-title"><%= news.getTitle() %></h5>
                    <p class="card-text"><%= news.getDescription() %></p>
                    <p class="card-text"><small class="text-muted">分类：<%= news.getCategory() %></small></p>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</div>

<!-- 底部 -->
<footer class="mt-5">
    <p>&copy; 2024 上海理工大学. 版权所有.</p>
</footer>

<!-- 将爬虫按钮移到页面底部，添加管理员检查 -->
<% if (session.getAttribute("isAdmin") != null && (Boolean)session.getAttribute("isAdmin")) { %>
    <div class="container mt-3 mb-3">
        <button class="btn btn-primary" onclick="crawlNews()">手动更新新闻数据</button>
    </div>
<% } %>

<script>
function crawlNews() {
    if (confirm('确定要更新新闻数据吗？这可能需要一些时间。')) {
        fetch('/news_system/crawl-now')
            .then(response => response.text())
            .then(text => {
                alert(text);
                location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('更新失败：' + error);
            });
    }
}
</script>

</body>
</html>