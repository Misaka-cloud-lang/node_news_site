<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>搜索结果</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
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
        .highlight {
            background-color: yellow;
            padding: 2px;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="../index.jsp">usst在线新闻网站</a>
        <!-- ... 导航栏内容 ... -->
    </div>
</nav>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-9">
            <h2>搜索结果：${param.query}</h2>
            
            <%
                String query = request.getParameter("query");
                int currentPage = request.getParameter("page") != null ? 
                    Integer.parseInt(request.getParameter("page")) : 1;
                int pageSize = 10;
                
                NewsService newsService = new NewsService();
                List<News> searchResults = newsService.searchNews(query);
                int total = searchResults.size();
                int totalPages = (int) Math.ceil((double) total / pageSize);
                
                int start = (currentPage - 1) * pageSize;
                int end = Math.min(start + pageSize, total);
                List<News> pageResults = searchResults.subList(start, end);
                
                if (pageResults.isEmpty()) {
            %>
                <div class="alert alert-info mt-4">
                    未找到相关新闻，请尝试其他关键词。
                </div>
            <%
                } else {
                    for (News news : pageResults) {
            %>
                <div class="news-item">
                    <div class="row">
                        <div class="col-md-3">
                            <img src="<%= news.getImage() %>" class="news-image img-fluid" 
                                 alt="新闻图片" onerror="this.src='../images/default.jpg'">
                        </div>
                        <div class="col-md-9">
                            <h3>
                                <a href="newsDetail.jsp?id=<%= news.getId() %>" 
                                   class="text-decoration-none text-dark">
                                    <%= news.getTitle().replaceAll(query, 
                                        "<span class='highlight'>" + query + "</span>") %>
                                </a>
                            </h3>
                            <p class="news-description">
                                <%= news.getDescription().replaceAll(query, 
                                    "<span class='highlight'>" + query + "</span>") %>
                            </p>
                            <div class="news-meta">
                                <span class="category badge bg-primary">
                                    分类：<%= news.getCategory() %>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
            
            <!-- 分页导航 -->
            <% if (totalPages > 1) { %>
            <nav aria-label="Search results pages">
                <ul class="pagination justify-content-center">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?query=${param.query}&page=<%= currentPage-1 %>">
                            上一页
                        </a>
                    </li>
                    
                    <% for(int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= currentPage == i ? "active" : "" %>">
                            <a class="page-link" href="?query=${param.query}&page=<%= i %>">
                                <%= i %>
                            </a>
                        </li>
                    <% } %>
                    
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?query=${param.query}&page=<%= currentPage+1 %>">
                            下一页
                        </a>
                    </li>
                </ul>
            </nav>
            <% } %>
        </div>

        <!-- 右侧边栏 -->
        <div class="col-md-3">
            <!-- 搜索框 -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">搜索新闻</h5>
                    <form action="${pageContext.request.contextPath}/news" method="get">
                        <div class="input-group">
                            <input type="text" class="form-control" name="query" 
                                   value="${param.query}" placeholder="输入关键词">
                            <button class="btn btn-primary" type="submit">搜索</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
