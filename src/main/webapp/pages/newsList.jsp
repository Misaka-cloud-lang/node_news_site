<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String category = request.getParameter("category");
    NewsService newsService = new NewsService();
    List<News> newsList = null;
    
    if (category != null && !category.isEmpty()) {
        newsList = newsService.getNewsByCategory(category);
    }

    Map<String, Object> categoryStats = newsService.getCategoryStats(category);
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= category != null ? category : "全部" %>新闻 - USST新闻网</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        /* 新闻列表样式优化 */
        .news-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .news-card .card-img-wrapper {
            overflow: hidden;
            height: 200px;
        }

        .news-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .news-card:hover img {
            transform: scale(1.05);
        }

        .news-meta {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .news-meta i {
            margin-right: 5px;
        }

        .category-header {
            background: linear-gradient(135deg, #1a237e 0%, #0d47a1 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
            border-radius: 0 0 20px 20px;
        }

        .category-stats {
            background: rgba(255,255,255,0.1);
            padding: 15px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }

        .filter-bar {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .sort-btn {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-right: 10px;
            background: white;
            border: 1px solid #dee2e6;
            color: #495057;
        }

        .sort-btn.active {
            background: #0d47a1;
            color: white;
            border-color: #0d47a1;
        }

        .page-header {
            margin-top: 0;
            padding-top: 20px;
        }

        .grid-view .list-item,
        .grid-view .list-ad {
            display: none !important;
        }

        .list-view .grid-item,
        .list-view .grid-ad {
            display: none !important;
        }

        /* 确保广告在不同视图下正确显示 */
        .ad-item {
            display: block !important;
        }

        /* 悬浮广告位置调整 */
        .float-right-ad {
            right: 20px;
        }

        .float-left-ad {
            left: 20px;
        }

        /* 视图切换控制 */
        .grid-view .list-item,
        .grid-view .list-ad {
            display: none !important;
        }

        .list-view .grid-item,
        .list-view .grid-ad {
            display: none !important;
        }

        /* 确保广告容器正确显示 */
        .ad-item {
            width: 100%;
        }

        /* 广告样式调整 */
        .grid-ad {
            margin: 20px 0;
        }

        .list-ad {
            margin: 15px 0;
        }
    </style>
</head>
<body style="overflow-x: hidden; position: relative;">

<jsp:include page="common/navbar.jsp" />

<!-- 分类头部区域 -->
<div class="category-header glass-effect">
    <div class="container py-3">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h1 class="text-white mb-2"><%= category %></h1>
                <p class="text-white-50 mb-0" style="font-size: 0.95rem;">
                    <% 
                        String description = "";
                        switch(category) {
                            case "国内":
                                description = "深度报道国内重大事件，聚焦社会发展，传递时代进步的声音";
                                break;
                            case "国际":
                                description = "全球视角，深度解读国际局势，第一时间获取世界重要资讯";
                                break;
                            case "军事":
                                description = "权威军事资讯，深度剖析国防动态，洞察全球军事战略格局";
                                break;
                            case "科技":
                                description = "探索科技前沿，见证创新突破，解读未来科技发展趋势";
                                break;
                            case "财经":
                                description = "实时掌握金融动态，深度解析市场趋势，权威财经资讯一手掌握";
                                break;
                            case "体育":
                                description = "实时体育赛事，深度赛事解析，全方位呈现体育竞技魅力";
                                break;
                            case "娱乐":
                                description = "独家娱乐资讯，深度文化观察，展现多彩文娱世界";
                                break;
                            case "社会":
                                description = "关注民生热点，记录时代变迁，讲述平凡中的感动故事";
                                break;
                            case "股市":
                                description = "专业股市分析，实时行情追踪，助您把握投资机遇";
                                break;
                            case "美股":
                                description = "全球金融市场动态，美股深度分析，海外投资精准指南";
                                break;
                            default:
                                description = "为您提供最新、最全面的" + category + "资讯";
                        }
                    %>
                    <%= description %>
                </p>
            </div>
            <div class="col-md-6">
                <div class="row text-center">
                    <div class="col-4">
                        <div class="stat-card smooth-shadow">
                            <h3 class="text-white mb-1" style="font-size: 1.5rem;">
                                <%= categoryStats.get("totalNews") %>
                            </h3>
                            <p class="text-white-50 mb-0" style="font-size: 0.85rem;">文章总数</p>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="stat-card smooth-shadow">
                            <h3 class="text-white mb-1" style="font-size: 1.5rem;">
                                <%= categoryStats.get("totalViews") %>
                            </h3>
                            <p class="text-white-50 mb-0" style="font-size: 0.85rem;">总阅读量</p>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="stat-card smooth-shadow">
                            <h3 class="text-white mb-1" style="font-size: 1.5rem;">
                                <%= categoryStats.get("todayUpdates") %>
                            </h3>
                            <p class="text-white-50 mb-0" style="font-size: 0.85rem;">今日更新</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container mt-4">
    <!-- 使用玻璃拟态效果的筛选栏 -->
    <div class="filter-bar glass-effect p-3 mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <button class="btn btn-3d active me-2">最新发布</button>
                <button class="btn btn-3d me-2">最多阅读</button>
                <button class="btn btn-3d">最多评论</button>
            </div>
            <div class="d-flex align-items-center">
                <div class="view-switcher mb-3">
                    <button type="button" class="btn active" data-view="grid">
                        <i class="bi bi-grid"></i> 网格视图
                    </button>
                    <button type="button" class="btn" data-view="list">
                        <i class="bi bi-list"></i> 列表视图
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 筛选栏下方，列表前的广告位 -->
    <div class="ad-container mb-4">
        <jsp:include page="_ad.jsp">
            <jsp:param name="position" value="list_top"/>
            <jsp:param name="template" value="inFeed"/>
        </jsp:include>
    </div>

    <!-- 新闻列表容器 -->
    <div class="news-container">
        <% if (newsList != null && !newsList.isEmpty()) { %>
            <div class="row">
                <!-- 网格视图 -->
                <% 
                int gridCount = 0;
                for (News news : newsList) { 
                    gridCount++;
                %>
                    <div class="col-md-6 col-lg-4 mb-4 grid-item">
                        <div class="card news-card gradient-border hover-float">
                            <div class="card-img-wrapper shine-effect">
                                <img src="<%= news.getImage() %>" 
                                     class="card-img-top" 
                                     alt="<%= news.getTitle() %>"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                <div class="category-badge">
                                    <span class="tag"><%= news.getCategory() %></span>
                                </div>
                            </div>
                            <div class="card-body">
                                <!-- 标题 -->
                                <h5 class="card-title">
                                    <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= news.getId() %>" 
                                       class="text-decoration-none text-dark">
                                        <%= news.getTitle() %>
                                    </a>
                                </h5>
                                
                                <!-- 上半部分元信息 -->
                                <div class="meta-top">
                                    <div class="author">
                                        <i class="bi bi-person"></i>
                                        <%= news.getAuthor() %>
                                    </div>
                                    <div class="time">
                                        <i class="bi bi-clock"></i>
                                        <%= news.getReadTime() %>分钟
                                    </div>
                                </div>
                                
                                <!-- 描述文本 -->
                                <p class="card-text text-muted">
                                    <%= news.getDescription().length() > 100 ? 
                                        news.getDescription().substring(0, 100) + "..." : 
                                        news.getDescription() %>
                                </p>
                                
                                <!-- 下半部分元信息 -->
                                <div class="meta-bottom">
                                    <div class="meta-stats">
                                        <span><i class="bi bi-eye"></i><%= news.getViews() %></span>
                                        <span><i class="bi bi-chat"></i><%= news.getComments() %></span>
                                        <span><i class="bi bi-heart"></i><%= news.getLikes() %></span>
                                    </div>
                                    <div class="mt-3">
                                        <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= news.getId() %>" 
                                           class="btn btn-primary btn-sm">
                                            阅读更多 <i class="bi bi-arrow-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (gridCount % 6 == 0) { %>
                        <div class="col-12 mb-4 ad-item grid-ad">
                            <div class="ad-container">
                                <jsp:include page="_ad.jsp">
                                    <jsp:param name="position" value="grid_feed_<%= gridCount/6 %>"/>
                                    <jsp:param name="template" value="inFeed"/>
                                </jsp:include>
                            </div>
                        </div>
                    <% } %>
                <% } %>

                <!-- 列表视图 -->
                <% 
                int listCount = 0;
                for (News news : newsList) { 
                    listCount++;
                %>
                    <div class="col-12 mb-3 list-item">
                        <div class="card news-card gradient-border hover-float">
                            <div class="d-flex">
                                <div class="card-img-wrapper">
                                    <img src="<%= news.getImage() %>" 
                                         class="img-fluid" 
                                         alt="<%= news.getTitle() %>"
                                         style="object-fit: cover; width: 100%; height: 100%;"
                                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="card-title mb-0"><%= news.getTitle() %></h5>
                                        <span class="tag ms-2"><%= news.getCategory() %></span>
                                    </div>
                                    <p class="card-text flex-grow-1"><%= news.getDescription() %></p>
                                    <div class="card-meta d-flex justify-content-between align-items-center mt-auto">
                                        <div class="meta-info">
                                            <small class="text-muted">
                                                <i class="bi bi-eye me-1"></i><%= news.getViews() %>
                                                <i class="bi bi-chat ms-2 me-1"></i><%= news.getComments() %>
                                                <i class="bi bi-heart ms-2 me-1"></i><%= news.getLikes() %>
                                                <i class="bi bi-share ms-2 me-1"></i><%= news.getShares() %>
                                            </small>
                                        </div>
                                        <div class="meta-info">
                                            <small class="text-muted">
                                                <i class="bi bi-person me-1"></i><%= news.getAuthor() %>
                                                <i class="bi bi-clock ms-2 me-1"></i><%= news.getReadTime() %>分钟
                                            </small>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= news.getId() %>"
                                           class="btn btn-primary btn-sm btn-3d"
                                        onclick="UserTracker.sendUserData(${sessionScope.get("userId")},'<%=news.getCategory()%>','<%=news.getTags()%>')">
                                            阅读更多
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (listCount % 3 == 0 && listCount < newsList.size()) { %>
                        <div class="col-12 mb-3 ad-item list-ad">
                            <div class="ad-container">
                                <jsp:include page="_ad.jsp">
                                    <jsp:param name="position" value="list_feed_<%= listCount/3 %>"/>
                                    <jsp:param name="template" value="inFeed"/>
                                </jsp:include>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- 内容下方广告 -->
    <div class="ad-container mb-4">
        <jsp:include page="_ad.jsp">
            <jsp:param name="position" value="list_content_bottom"/>
            <jsp:param name="template" value="inFeed"/>
        </jsp:include>
    </div>
</div>

<!-- 使用统一的页脚 -->
<jsp:include page="common/footer.jsp" />

<!-- 底部固定悬浮广告 -->
<div class="ad-container">
    <jsp:include page="_ad.jsp">
        <jsp:param name="position" value="list_bottom_float"/>
        <jsp:param name="template" value="bottomBanner"/>
    </jsp:include>
</div>

<!-- 返回顶部按钮 -->
<button id="backToTop" class="back-to-top">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- 脚 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
// 添加滚动动画
document.addEventListener('DOMContentLoaded', function() {
    const animateElements = document.querySelectorAll('.news-card');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-fadeInUp');
            }
        });
    }, {
        threshold: 0.1
    });

    animateElements.forEach(element => {
        observer.observe(element);
    });
});
</script>

<script src="${pageContext.request.contextPath}/js/common.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const viewSwitchers = document.querySelectorAll('.view-switcher .btn');
    const newsContainer = document.querySelector('.news-container');
    
    // 添加调试函数
    function debugElements() {
        console.log('Debug info:');
        console.log('Container:', newsContainer);
        console.log('Container classes:', newsContainer.classList.toString());
        console.log('Grid items:', document.querySelectorAll('.grid-item').length);
        console.log('List items:', document.querySelectorAll('.list-item').length);
        console.log('Visible grid items:', document.querySelectorAll('.grid-item:not([style*="display: none"])').length);
        console.log('Visible list items:', document.querySelectorAll('.list-item:not([style*="display: none"])').length);
    }

    viewSwitchers.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const viewType = this.getAttribute('data-view');
            console.log('Switching to view:', viewType);
            
            // 更新按钮状态
            viewSwitchers.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // 直接设置显示/隐藏
            const gridItems = document.querySelectorAll('.grid-item');
            const listItems = document.querySelectorAll('.list-item');
            
            if (viewType === 'grid') {
                gridItems.forEach(item => item.style.display = 'block');
                listItems.forEach(item => item.style.display = 'none');
                newsContainer.classList.remove('list-view');
                newsContainer.classList.add('grid-view');
            } else {
                gridItems.forEach(item => item.style.display = 'none');
                listItems.forEach(item => item.style.display = 'block');
                newsContainer.classList.remove('grid-view');
                newsContainer.classList.add('list-view');
            }
            
            debugElements(); // 打印调试信息
        });
    });
    
    // 初始状态调试
    debugElements();
});
</script>

<script>
// 返回顶部按钮功能
document.addEventListener('DOMContentLoaded', function() {
    const backToTopButton = document.getElementById('backToTop');
    
    // 监听滚动事件，控制按钮显示/隐藏
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) { // 滚动超过300px显示按钮
            backToTopButton.style.display = 'flex';
        } else {
            backToTopButton.style.display = 'none';
        }
    });
    
    // 点击按钮返回顶部
    backToTopButton.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth' // 平滑滚动
        });
    });
    
    // 初始状态隐藏按钮
    backToTopButton.style.display = 'none';
});
</script>

<script src="${pageContext.request.contextPath}/js/userTracker.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const category = '<%= category %>'; // 当前分类
        UserTracker.sendUserData(${sessionScope.get("userId")},category, null);
});
</script>

</body>
</html>