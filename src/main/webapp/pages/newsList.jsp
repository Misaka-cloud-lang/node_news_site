<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<%
    // 获取分类参数
    String category = request.getParameter("category");
    
    // 获取页码参数
    int currentPage = 1;
    try {
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            currentPage = Integer.parseInt(pageStr);
        }
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
    
    // 每页显示的新闻数量
    final int PAGE_SIZE = 10;
    
    // 实例化 NewsService
    NewsService newsService = new NewsService();
    
    // 获取指定分类的新闻列表
    List<News> newsList = null;
    int total = 0;
    
    if (category != null && !category.isEmpty()) {
        newsList = newsService.getNewsByCategory(category);
        total = newsService.getNewsTotalByCategory(category);
    } else {
        newsList = newsService.getAllNews();
        total = newsList.size();
    }
    
    // 计算总页数
    int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
    
    // 确保当前页码有效
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages) currentPage = totalPages;
    
    // 计算当前页的新闻
    int startIndex = (currentPage - 1) * PAGE_SIZE;
    int endIndex = Math.min(startIndex + PAGE_SIZE, total);
    
    List<News> currentPageNews = newsList.subList(startIndex, endIndex);
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.category} - 新闻列表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .news-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp" />

    <div class="container mt-4">
        <!-- 面包屑导航 -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="../index.jsp">首页</a></li>
                <li class="breadcrumb-item active"><%= category != null ? category : "全部新闻" %></li>
            </ol>
        </nav>

        <!-- 新闻列表 -->
        <div class="news-list">
            <% for (News news : currentPageNews) { %>
                <div class="news-item">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="image-wrapper" style="background-color: #f8f9fa; padding-top: 75%; position: relative;">
                                <img src="<%= news.getImage() %>"
                                     class="news-image position-absolute top-0 start-0 w-100 h-100"
                                     alt="新闻图片"
                                     style="object-fit: cover;"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default.jpg';">
                            </div>
                        </div>
                        <div class="col-md-9">
                            <h3><a href="newsDetail.jsp?id=<%= news.getId() %>" class="text-dark text-decoration-none"><%= news.getTitle() %></a></h3>
                            <p class="text-muted mb-2">
                                <small>
                                    <i class="bi bi-calendar"></i> <%= news.getPublishTime() %> &nbsp;
                                    <i class="bi bi-tag"></i> <%= news.getCategory() %> &nbsp;
                                    <i class="bi bi-eye"></i> <%= news.getViews() %> 阅读
                                </small>
                            </p>
                            <p class="news-description"><%= news.getDescription() %></p>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- 分页导航 -->
        <% if (totalPages > 1) { %>
            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?category=<%= category %>&page=<%= currentPage - 1 %>">上一页</a>
                    </li>
                    
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= i == currentPage ? "active" : "" %>">
                            <a class="page-link" href="?category=<%= category %>&page=<%= i %>"><%= i %></a>
                        </li>
                    <% } %>
                    
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?category=<%= category %>&page=<%= currentPage + 1 %>">下一页</a>
                    </li>
                </ul>
            </nav>
        <% } %>
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
