<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.category} - 新闻列表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ad.css">
    <style>
        .news-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
            margin-bottom: 20px;
        }
        .news-image {
            width: 200px;
            height: 150px;
            object-fit: cover;
        }
        .news-meta {
            color: #666;
            font-size: 0.9em;
            margin-top: 10px;
        }
        .news-description {
            margin: 10px 0;
            color: #666;
        }
        .pagination {
            margin-top: 30px;
        }
    </style>

</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="../index.jsp">usst在线新闻网站</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="../index.jsp">首页</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=国内">国内</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=国际">国际</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=体育">体育</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=科技">科技</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=娱乐">娱乐</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=财经">财经</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=军事">军事</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=社会">社会</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=股市">股市</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=美股">美股</a></li>
            </ul>
            <form class="d-flex ms-auto" action="news" method="get">
                <input class="form-control me-2" type="text" name="query" placeholder="搜索新闻" required>
                <button class="btn btn-outline-light" type="submit">搜索</button>
            </form>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <!-- 头部广告 -->
    <c:if test="${not empty headerAd}">
        <div class="ad-container header-ad">
            <c:choose>
                <c:when test="${headerAd.type eq 'BANNER'}">
                    <div class="banner-ad">
                        <a href="#" target="_blank">
                            <img src="${headerAd.imageUrl}" alt="${headerAd.content}">
                        </a>
                    </div>
                </c:when>
                <c:when test="${headerAd.type eq 'SCROLL_TEXT'}">
                    <div class="scroll-text">
                        <marquee>${headerAd.content}</marquee>
                    </div>
                </c:when>
            </c:choose>
        </div>
    </c:if>

    <h2 class="mb-4">${param.category}新闻</h2>

    <%
        String category = request.getParameter("category");
        int currentPage = request.getParameter("page") != null ?
            Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 10; // 每页显示10条新闻

        NewsService newsService = new NewsService();
        List<News> allNews = newsService.getNewsByCategory(category);
        int total = allNews.size();
        int totalPages = (int) Math.ceil((double) total / pageSize);

        // 计算当前页的新闻
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, total);
        List<News> pageNews = allNews.subList(start, end);

        for (News news : pageNews) {
    %>
    <div class="news-item">
        <div class="row">
            <div class="col-md-3">
                <img src="<%= news.getImage() %>" class="news-image img-fluid" alt="新闻图片"
                     onerror="this.src='../images/default.jpg'">
            </div>
            <div class="col-md-9">
                <h3>
                    <a href="${pageContext.request.contextPath}/news?id=<%= news.getId() %>"
                       class="text-decoration-none text-dark"
               
                    > <!-- onclick="catchAction(1,'${param.category}')" -->
                        <%= news.getTitle() %>
                    </a>
                </h3>
                <p class="news-description"><%= news.getDescription() %></p>
                <div class="news-meta">
                    <span class="category badge bg-primary">分类：<%= news.getCategory() %></span>
                    <span class="author badge bg-secondary">作者：<%= news.getAuthor() %></span>
                    <span class="source badge bg-info">来源：<%= news.getSource() %></span>
                    <span class="time badge bg-dark">时间：<%= news.getPublishTime() %></span>
                    <span class="views badge bg-success">阅读：<%= news.getViews() %></span>
                    <span class="likes badge bg-danger">点赞：<%= news.getLikes() %></span>
                    <% if (news.getTags() != null && !news.getTags().isEmpty()) { %>
                        <div class="tags mt-2">
                            <% for (String tag : news.getTags().split(",")) { %>
                                <span class="badge bg-light text-dark"><%= tag %></span>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <%
        }
    %>

    <!-- 中间广告 -->
    <div class="ad-container">
        <span class="ad-tag">广告</span>
        <jsp:include page="_ad.jsp">
            <jsp:param name="position" value="between"/>
        </jsp:include>
    </div>

    <!-- 分页导航 -->
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                <a class="page-link" href="?category=${param.category}&page=<%= currentPage-1 %>">上一页</a>
            </li>

            <% for(int i = 1; i <= totalPages; i++) { %>
                <li class="page-item <%= currentPage == i ? "active" : "" %>">
                    <a class="page-link" href="?category=${param.category}&page=<%= i %>"><%= i %></a>
                </li>
            <% } %>

            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                <a class="page-link" href="?category=${param.category}&page=<%= currentPage+1 %>">下一页</a>
            </li>
        </ul>
    </nav>

    <!-- 侧边栏广告 -->
    <div class="col-md-3">
        <c:if test="${not empty sidebarAd}">
            <div class="ad-container sidebar-ad">
                <c:choose>
                    <c:when test="${sidebarAd.type eq 'FLOATING'}">
                        <div class="floating-ad" id="floatingAd">
                            <span class="close-btn" onclick="closeFloatingAd()">&times;</span>
                            <img src="${sidebarAd.imageUrl}" alt="${sidebarAd.content}">
                        </div>
                    </c:when>
                </c:choose>
            </div>
        </c:if>
    </div>

    <!-- 页脚广告 -->
    <c:if test="${not empty footerAd}">
        <div class="ad-container footer-ad">
            <c:choose>
                <c:when test="${footerAd.type eq 'SCROLL_TEXT'}">
                    <div class="scroll-text">
                        <marquee>${footerAd.content}</marquee>
                    </div>
                </c:when>
            </c:choose>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function closeFloatingAd() {
        document.getElementById('floatingAd').style.display = 'none';
    }

    // 随机移动浮动广告位置
    function randomFloatingPosition() {
        const floatingAd = document.getElementById('floatingAd');
        if (floatingAd) {
            const maxX = window.innerWidth - floatingAd.offsetWidth;
            const maxY = window.innerHeight - floatingAd.offsetHeight;
            const randomX = Math.floor(Math.random() * maxX);
            const randomY = Math.floor(Math.random() * maxY);
            floatingAd.style.left = randomX + 'px';
            floatingAd.style.top = randomY + 'px';
        }
    }

    // 每5秒随机改变浮动广告位置
    setInterval(randomFloatingPosition, 5000);
</script>
<script>
    function catchAction(userId,tagName){
        let adServer="localhost";
        let backend_url="http://"+adServer+":8080/receive/news";
        let backend_url_full=backend_url+"?userId="+userId+"&tagName="+tagName
        fetch(backend_url_full,{
            method: 'POST'
        }
        ).then(response => {

            console.log(response)
        })
            .catch(error => console.log(error));

    }
</script>
</body>
</html>
