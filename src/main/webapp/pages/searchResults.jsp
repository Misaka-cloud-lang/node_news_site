<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<%
    String query = request.getParameter("query");
    NewsService newsService = new NewsService();
    List<News> searchResults = null;
    
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
    
    if (query != null && !query.trim().isEmpty()) {
        searchResults = newsService.searchNews(query.trim());
    }
    
    // 计算分页
    int total = searchResults != null ? searchResults.size() : 0;
    int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
    
    // 确保当前页码有效
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages) currentPage = totalPages;
    
    // 获取当前页的新闻
    List<News> currentPageResults = null;
    if (searchResults != null && !searchResults.isEmpty()) {
        int startIndex = (currentPage - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, total);
        currentPageResults = searchResults.subList(startIndex, endIndex);
    }
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>搜索结果 - USST新闻网</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .news-card {
            transition: transform 0.3s ease;
            margin-bottom: 20px;
        }
        .news-card:hover {
            transform: translateY(-5px);
        }
        .search-highlight {
            background-color: yellow;
            padding: 2px;
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
                <li class="breadcrumb-item active">搜索结果</li>
            </ol>
        </nav>

        <% if (query != null && !query.trim().isEmpty()) { %>
            <h2 class="mb-4">搜索结果: "<%= query %>"</h2>
            
            <% if (currentPageResults != null && !currentPageResults.isEmpty()) { %>
                <p class="text-muted">找到 <%= total %> 条相关新闻</p>
                
                <!-- 搜索结果列表 -->
                <div class="row">
                    <% for (News news : currentPageResults) { %>
                        <div class="col-md-12 mb-4">
                            <div class="card news-card">
                                <div class="row g-0">
                                    <div class="col-md-3">
                                        <img src="<%= news.getImage() %>" 
                                             class="img-fluid rounded-start h-100" 
                                             alt="新闻图片"
                                             style="object-fit: cover;"
                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                    </div>
                                    <div class="col-md-9">
                                        <div class="card-body">
                                            <h5 class="card-title">
                                                <a href="newsDetail.jsp?id=<%= news.getId() %>" 
                                                   class="text-dark text-decoration-none">
                                                    <%= news.getTitle() %>
                                                </a>
                                            </h5>
                                            <p class="card-text"><%= news.getDescription() %></p>
                                            <p class="card-text">
                                                <small class="text-muted">
                                                    <i class="bi bi-calendar"></i> <%= news.getPublishTime() %> &nbsp;
                                                    <i class="bi bi-tag"></i> <%= news.getCategory() %> &nbsp;
                                                    <i class="bi bi-eye"></i> <%= news.getViews() %> 阅读
                                                </small>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- 分页导航 -->
                <% if (totalPages > 1) { %>
                    <nav aria-label="Search results pages">
                        <ul class="pagination justify-content-center">
                            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                                <a class="page-link" href="?query=<%= query %>&page=<%= currentPage - 1 %>">上一页</a>
                            </li>
                            
                            <% for (int i = 1; i <= totalPages; i++) { %>
                                <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                    <a class="page-link" href="?query=<%= query %>&page=<%= i %>"><%= i %></a>
                                </li>
                            <% } %>
                            
                            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                                <a class="page-link" href="?query=<%= query %>&page=<%= currentPage + 1 %>">下一页</a>
                            </li>
                        </ul>
                    </nav>
                <% } %>
            <% } else { %>
                <div class="alert alert-info" role="alert">
                    未找到相关新闻
                </div>
            <% } %>
        <% } %>
    </div>

    <!-- 底部广告位 -->
    <div class="mt-4">
        <jsp:include page="_ad.jsp">
            <jsp:param name="position" value="search_bottom"/>
        </jsp:include>
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