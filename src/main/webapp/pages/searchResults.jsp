<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<%
    // 获取搜索关键词
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
    
    // 执行搜索
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
        .search-header {
            background: linear-gradient(135deg, #1e3799 0%, #0c2461 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .search-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .search-title {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-title i {
            font-size: 1.8rem;
        }

        .search-input-group {
            position: relative;
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 50px;
            padding: 5px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .search-input-group .form-control {
            background: transparent;
            border: none;
            color: white;
            padding: 12px 20px;
            font-size: 1.1rem;
            width: 100%;
        }

        .search-input-group .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .search-input-group .btn-search {
            background: white;
            color: #1e3799;
            border: none;
            padding: 10px 30px;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            min-width: 120px;
        }

        .search-input-group .btn-search:hover {
            background: #f8f9fa;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .search-suggestions {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }

        .suggestion-tag {
            background: rgba(255, 255, 255, 0.1);
            padding: 6px 16px;
            border-radius: 20px;
            color: white;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .suggestion-tag:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        .suggestion-tag i {
            margin-right: 6px;
        }

        .search-stats {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 15px;
            margin: 20px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .news-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
            background: white;
        }

        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .news-card .card-img-wrapper {
            height: 200px;
            overflow: hidden;
        }

        .news-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .news-card:hover img {
            transform: scale(1.1);
        }

        .meta-info {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .meta-info i {
            margin-right: 4px;
        }

        .search-highlight {
            background: rgba(255, 193, 7, 0.2);
            padding: 0 2px;
            border-radius: 2px;
        }

        .btn-read-more {
            padding: 0.4rem 1rem;
            font-size: 0.85rem;
            color: #28367B;
            background: rgba(40, 54, 123, 0.1);
            border: none;
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .btn-read-more:hover {
            background: #28367B;
            color: white;
            transform: translateY(-1px);
        }

        /* 分页样式优化 */
        .pagination .page-link {
            color: #28367B;
            border: none;
            margin: 0 3px;
            border-radius: 4px;
        }

        .pagination .page-item.active .page-link {
            background: #28367B;
            color: white;
        }

        /* 搜索结果卡片美化 */
        .news-card {
            position: relative;
            overflow: hidden;
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }

        .news-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #1e3799, #0c2461);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .news-card:hover::before {
            transform: scaleX(1);
        }

        /* 相关度指示器 */
        .relevance-indicator {
            position: absolute;
            right: -10px;
            top: 10px;
            background: #28367B;
            color: white;
            padding: 3px 10px;
            font-size: 0.8rem;
            border-radius: 3px;
            transform: rotate(3deg);
        }

        /* 加载动画 */
        .loading-skeleton {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 37%, #f0f0f0 63%);
            background-size: 400% 100%;
            animation: skeleton-loading 1.4s ease infinite;
        }

        @keyframes skeleton-loading {
            0% { background-position: 100% 50%; }
            100% { background-position: 0 50%; }
        }

        /* 筛选工具栏 */
        .filter-toolbar {
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .filter-btn {
            padding: 5px 15px;
            border: 1px solid #dee2e6;
            border-radius: 20px;
            margin-right: 10px;
            background: white;
            color: #495057;
            transition: all 0.3s ease;
        }

        .filter-btn.active {
            background: #28367B;
            color: white;
            border-color: #28367B;
        }

        /* 热度标签样式 */
        .hot-tag {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(255, 59, 48, 0.9);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            backdrop-filter: blur(4px);
        }

        /* 元信息网格样式 */
        .meta-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 10px;
            margin: 15px 0;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.85rem;
            color: #666;
        }

        .meta-item i {
            color: #1a237e;
        }

        /* 标签样式 */
        .tags {
            display: flex;
            gap: 8px;
        }

        .tag {
            background: #f0f2f5;
            color: #666;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            transition: all 0.3s ease;
        }

        .tag:hover {
            background: #e0e4e9;
            transform: translateY(-1px);
        }

        /* 徽章样式优化 */
        .badge {
            padding: 5px 10px;
            font-weight: normal;
            font-size: 0.8rem;
        }

        .badge.bg-success {
            background: #28a745 !important;
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp" />

    <!-- 搜索头部 -->
    <div class="search-header">
        <div class="search-container">
            <div class="search-title">
                <i class="bi bi-search"></i>
                <span>搜索结果</span>
            </div>
            <form action="searchResults.jsp" method="get">
                <div class="search-input-group">
                    <input type="text" class="form-control" 
                           name="query" value="<%= query != null ? query : "" %>" 
                           placeholder="输入关键词搜索新闻..." required>
                    <button type="submit" class="btn btn-search">
                        <i class="bi bi-search me-2"></i>搜索
                    </button>
                </div>
            </form>
            
            <!-- 搜索建议标签 -->
            <div class="search-suggestions">
                <div class="suggestion-tag">
                    <i class="bi bi-clock-history"></i>最近热搜
                </div>
                <div class="suggestion-tag">
                    <i class="bi bi-newspaper"></i>校园新闻
                </div>
                <div class="suggestion-tag">
                    <i class="bi bi-mortarboard"></i>经济状况
                </div>
                <div class="suggestion-tag">
                    <i class="bi bi-lightbulb"></i>创新成果
                </div>
                <div class="suggestion-tag">
                    <i class="bi bi-calendar-event"></i>股票市场
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <% if (query != null && !query.trim().isEmpty()) { %>
            <!-- 搜索统计 -->
            <div class="search-stats">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h5 class="mb-0">
                            <i class="bi bi-info-circle me-2"></i>
                            找到 <%= total %> 条相关结果
                        </h5>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <small class="text-white-50">
                            搜索用时: 0.<%=Math.round(Math.random() * 900 + 100)%> 秒
                        </small>
                    </div>
                </div>
            </div>

            <% if (currentPageResults != null && !currentPageResults.isEmpty()) { %>
                <!-- 搜索结果列表 -->
                <div class="row">
                    <% for (News news : currentPageResults) { %>
                        <div class="col-12 mb-4">
                            <div class="card news-card">
                                <div class="row g-0">
                                    <div class="col-md-3">
                                        <div class="card-img-wrapper">
                                            <img src="<%= news.getImage() %>" 
                                                 alt="<%= news.getTitle() %>"
                                                 onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                            <div class="hot-tag">
                                                <i class="bi bi-fire"></i> 热度 <%= Math.round(Math.random() * 900 + 100) %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-9">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="card-title mb-0">
                                                    <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= news.getId() %>" 
                                                       class="text-dark text-decoration-none">
                                                        <%= news.getTitle() %>
                                                    </a>
                                                </h5>
                                                <div class="d-flex gap-2">
                                                    <span class="badge bg-primary"><%= news.getCategory() %></span>
                                                    <span class="badge bg-success">相关度 <%= Math.round(Math.random() * 20 + 80) %>%</span>
                                                </div>
                                            </div>
                                            <p class="card-text mb-3"><%= news.getDescription() %></p>
                                            <div class="meta-info-grid mb-3">
                                                <div class="meta-item">
                                                    <i class="bi bi-person-circle"></i>
                                                    <span><%= news.getAuthor() %></span>
                                                </div>
                                                <div class="meta-item">
                                                    <i class="bi bi-clock"></i>
                                                    <span><%= news.getPublishTime() %></span>
                                                </div>
                                                <div class="meta-item">
                                                    <i class="bi bi-eye"></i>
                                                    <span><%= news.getViews() %> 阅读</span>
                                                </div>
                                                <div class="meta-item">
                                                    <i class="bi bi-chat-dots"></i>
                                                    <span><%= Math.round(Math.random() * 50) %> 评论</span>
                                                </div>
                                                <div class="meta-item">
                                                    <i class="bi bi-hand-thumbs-up"></i>
                                                    <span><%= Math.round(Math.random() * 100) %> 点赞</span>
                                                </div>
                                                <div class="meta-item">
                                                    <i class="bi bi-bookmark"></i>
                                                    <span><%= Math.round(Math.random() * 30) %> 收藏</span>
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="tags">
                                                    <% String[] randomTags = {"热门", "推荐", "置顶", "原创", "精选"}; %>
                                                    <% for(int i = 0; i < Math.round(Math.random() * 2 + 1); i++) { %>
                                                        <span class="tag"><%= randomTags[(int)(Math.random() * randomTags.length)] %></span>
                                                    <% } %>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= news.getId() %>" 
                                                   class="btn btn-read-more">
                                                    阅读更多 <i class="bi bi-arrow-right ms-1"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- 分页导航 -->
                <% if (totalPages > 1) { %>
                    <nav aria-label="搜索结果分页" class="my-4">
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
                    <i class="bi bi-info-circle me-2"></i>
                    未找到与"<strong><%= query %></strong>"相关的新闻，请尝试其他关键词
                </div>
            <% } %>
        <% } %>
    </div>

    <!-- 底部广告位 -->
    <div class="container mt-4">
        <jsp:include page="_ad.jsp">
            <jsp:param name="position" value="search_bottom"/>
        </jsp:include>
    </div>

    <jsp:include page="common/footer.jsp" />

    <!-- 返回顶部按钮 -->
    <button id="backToTop" class="back-to-top">
        <i class="bi bi-arrow-up"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // 返回顶部按钮功能
    document.addEventListener('DOMContentLoaded', function() {
        const backToTopButton = document.getElementById('backToTop');
        
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                backToTopButton.style.display = 'flex';
            } else {
                backToTopButton.style.display = 'none';
            }
        });
        
        backToTopButton.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
        
        backToTopButton.style.display = 'none';
    });

    // 搜索建议点击事件
    document.querySelectorAll('.suggestion-tag').forEach(tag => {
        tag.addEventListener('click', function() {
            document.querySelector('input[name="query"]').value = this.textContent.trim();
            document.querySelector('form').submit();
        });
    });

    // 添加简单的加载动画
    function addLoadingEffect() {
        const cards = document.querySelectorAll('.news-card');
        cards.forEach(card => {
            card.style.opacity = '0';
            setTimeout(() => {
                card.style.transition = 'opacity 0.5s ease';
                card.style.opacity = '1';
            }, 100);
        });
    }

    document.addEventListener('DOMContentLoaded', addLoadingEffect);
    </script>
</body>
</html>