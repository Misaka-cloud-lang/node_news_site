<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<%
    // 获取新闻ID
    String newsId = request.getParameter("id");
    News news = null;
    List<News> relatedNews = null;
    NewsService newsService = new NewsService();
    
    if (newsId != null && !newsId.isEmpty()) {
        try {
            int id = Integer.parseInt(newsId);
            // 获取当前新闻（使其成为 effectively final）
            final News currentNews = newsService.getNewsById(id);
            news = currentNews;  // 保存对 news 变量的赋值
            
            // 获取相关新闻（同类别的其他新闻）
            if (currentNews != null) {
                relatedNews = newsService.getNewsByCategory(currentNews.getCategory());
                // 使用 currentNews 代替 news
                relatedNews.removeIf(n -> n.getId() == currentNews.getId());
                // 只保留前4条
                if (relatedNews.size() > 4) {
                    relatedNews = relatedNews.subList(0, 4);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= news != null ? news.getTitle() : "新闻详情" %> - USST新闻网</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .news-content {
            line-height: 1.8;
            font-size: 1.1em;
        }
        .news-meta {
            color: #666;
            font-size: 0.9em;
            margin: 15px 0;
        }
        .news-image {
            max-width: 100%;
            height: auto;
            margin: 20px 0;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .related-news .card {
            transition: transform 0.3s ease;
        }
        .related-news .card:hover {
            transform: translateY(-5px);
        }
    </style>
    <jsp:include page="common/navbar.jsp" />
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="../index.jsp">USST NEWS</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="../index.jsp">首页</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=国内">国内</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=国际">国际</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=体育">体育</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=科技">科技</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=娱乐">娱乐</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=财经">财经</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=军事">军事</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=社会">社会</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=股市">股市</a></li>
                <li class="nav-item"><a class="nav-link" href="newsList.jsp?category=美股">美股</a></li>
            </ul>
            <!-- 添加搜索框 -->
            <form class="d-flex ms-auto" action="searchResults.jsp" method="get">
                <input class="form-control me-2" type="text" name="query" placeholder="搜索新闻" required>
                <button class="btn btn-outline-light" type="submit">搜索</button>
            </form>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <jsp:include page="_ad.jsp">
        <jsp:param name="position" value="detail_top"/>
    </jsp:include>
</div>

<div class="container mt-4">
    <% if (news != null) { %>
        <!-- 面包屑导航 -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="../index.jsp">首页</a></li>
                <li class="breadcrumb-item"><a href="newsList.jsp?category=<%= news.getCategory() %>"><%= news.getCategory() %></a></li>
                <li class="breadcrumb-item active">新闻详情</li>
            </ol>
        </nav>

        <!-- 新闻内容 -->
        <div class="news-content-wrapper">
            <h1 class="mb-3"><%= news.getTitle() %></h1>
            <div class="news-meta text-muted mb-4">
                <span><i class="bi bi-calendar"></i> <%= news.getPublishTime() %></span>
                <span class="ms-3"><i class="bi bi-tag"></i> <%= news.getCategory() %></span>
                <span class="ms-3"><i class="bi bi-eye"></i> <%= news.getViews() %> 阅读</span>
            </div>
            
            <% if (news.getImage() != null && !news.getImage().isEmpty()) { %>
                <div class="text-center mb-4">
                    <img src="<%= news.getImage() %>" 
                         class="news-image img-fluid rounded" 
                         alt="新闻图片"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default.jpg';">
                </div>
            <% } %>

            <div class="news-content">
                <%= news.getContent() %>
            </div>
        </div>

        <!-- 相关新闻 -->
        <% if (relatedNews != null && !relatedNews.isEmpty()) { %>
            <div class="related-news mt-5">
                <h3 class="mb-4">相关新闻</h3>
                <div class="row">
                    <% for (News related : relatedNews) { %>
                        <div class="col-md-3 mb-4">
                            <div class="card h-100">
                                <img src="<%= related.getImage() %>" 
                                     class="card-img-top" 
                                     alt="新闻图片"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default.jpg';">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <a href="newsDetail.jsp?id=<%= related.getId() %>" 
                                           class="text-dark text-decoration-none">
                                            <%= related.getTitle() %>
                                        </a>
                                    </h5>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="alert alert-warning" role="alert">
            未找到相关新闻
        </div>
    <% } %>

    <!-- 底部广告位 -->
    <div class="mt-4">
        <jsp:include page="_ad.jsp">
            <jsp:param name="position" value="detail_bottom"/>
        </jsp:include>
    </div>
</div>

<!-- 页脚 -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p>&copy; 2024 USST新闻网. 版权所有.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>