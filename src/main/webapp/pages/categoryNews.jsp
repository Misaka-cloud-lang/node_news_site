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
    <style>
        .news-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
        }
        .news-image {
            width: 200px;
            height: 150px;
            object-fit: cover;
        }
        .news-meta {
            color: #666;
            font-size: 0.9em;
        }
        .pagination {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="../index.jsp">usst在线新��网站</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="../index.jsp">首页</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=国内">国内</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=国际">国际</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=经济">经济</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=科技">科技</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=娱乐">娱乐</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=体育">体育</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=教育">教育</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=健康">健康</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=文化">文化</a></li>
                <li class="nav-item"><a class="nav-link" href="?category=军事">军事</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
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
    <div class="news-item row">
        <div class="col-md-3">
            <img src="<%= news.getImage() %>" class="news-image" alt="新闻图片" 
                 onerror="this.src='../images/default.jpg'">
        </div>
        <div class="col-md-9">
            <h3><a href="newsDetail.jsp?id=<%= news.getId() %>" class="text-decoration-none">
                <%= news.getTitle() %>
            </a></h3>
            <p class="news-description"><%= news.getDescription() %></p>
            <div class="news-meta">
                <span class="category">分类：<%= news.getCategory() %></span>
            </div>
        </div>
    </div>
    <%
        }
    %>
    
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
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 