<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<!-- 在页面顶部创建 NewsService 实例 -->
<%
    NewsService newsService = new NewsService();
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新闻详情</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .news-image {
            max-width: 100%;
            height: auto;
            margin: 20px 0;
        }
        .news-meta {
            color: #666;
            font-size: 0.9em;
            margin: 15px 0;
        }
        .news-content {
            line-height: 1.8;
            font-size: 1.1em;
        }
        .ad-space {
            background: #f8f9fa;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .ad-space img {
            max-width: 100%;
            height: auto;
        }
    </style>
</head>
<body>

<!-- 头部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="../index.jsp">usst在线新闻网站</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="../index.jsp">首页</a></li>
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
            <form class="d-flex ms-auto" action="news" method="get">
                <input class="form-control me-2" type="text" name="query" placeholder="搜索新闻" required>
                <button class="btn btn-outline-light" type="submit">搜索</button>
            </form>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="row">
        <!-- 新闻详情部分 -->
        <div class="col-md-9">
            <%
                News news = (News) request.getAttribute("news");
                if (news != null) {
            %>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="../index.jsp">首页</a></li>
                    <li class="breadcrumb-item"><a href="newsList.jsp?category=<%= news.getCategory() %>"><%= news.getCategory() %></a></li>
                    <li class="breadcrumb-item active">新闻详情</li>
                </ol>
            </nav>

            <article>
                <h1 class="mb-4"><%= news.getTitle() %></h1>
                <jsp:include page="_ad.jsp">
                    <jsp:param name="position" value="header"/>
                </jsp:include>

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

                <img src="<%= news.getImage() %>" class="news-image" alt="新闻图片"
                     onerror="this.src='../images/default.jpg'">

                <div class="ad-container banner-ad">
                    <span class="ad-tag">广告</span>
                    <jsp:include page="_ad.jsp">
                        <jsp:param name="position" value="header"/>
                    </jsp:include>
                </div>

                <div class="news-content">
                    <%= news.getDescription().substring(0, news.getDescription().length()/2) %>
                    <jsp:include page="_ad.jsp">
                        <jsp:param name="position" value="content"/>
                    </jsp:include>
                    <%= news.getDescription().substring(news.getDescription().length()/2) %>
                </div>

                <div class="ad-container mt-4">
                    <span class="ad-tag">广告</span>
                    <jsp:include page="_ad.jsp">
                        <jsp:param name="position" value="footer"/>
                    </jsp:include>
                </div>
            </article>


            <!-- 相关新闻推荐 -->
            <div class="related-news mt-5">
                <h3>相关新闻</h3>
                <div class="row">
                    <%
                        List<News> relatedNews = newsService.getNewsByCategory(news.getCategory());
                        int count = 0;
                        for (News related : relatedNews) {
                            if (related.getId() != news.getId() && count < 3) {
                    %>
                    <div class="col-md-4">
                        <div class="card mb-4">
                            <img src="<%= related.getImage() %>" class="card-img-top" alt="相关新闻图片"
                                 onerror="this.src='../images/default.jpg'">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a href="news?id=<%= related.getId() %>" class="text-decoration-none">
                                        <%= related.getTitle() %>
                                    </a>
                                </h5>
                            </div>
                        </div>
                    </div>
                    <%
                                count++;
                            }
                        }
                    %>
                </div>
            </div>
            <%
            } else {
            %>
            <div class="alert alert-warning" role="alert">
                未找到该新闻！
            </div>
            <%
                }
            %>
        </div>

        <!-- 广告栏部分 -->
        <div class="col-md-3">
            <jsp:include page="_ad.jsp">
                <jsp:param name="position" value="sidebar"/>
            </jsp:include>
        </div>
    </div>
</div>

<!-- 底部 -->
<footer class="bg-light py-3 mt-5 text-center">
    <p>&copy; 2024 上海理工大学. 版权所有.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>