<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>USST在线新闻网站</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        /* 自定义样式 */
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), url('images/news-bg.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            margin-bottom: 40px;
        }

        .category-card {
            transition: transform 0.3s ease;
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }

        .category-card:hover {
            transform: translateY(-5px);
        }

        .category-icon {
            font-size: 2rem;
            margin-bottom: 15px;
            color: #0d6efd;
        }

        .latest-news {
            background-color: #f8f9fa;
            padding: 40px 0;
            margin: 40px 0;
        }

        .news-card {
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .news-card:hover {
            transform: translateY(-5px);
        }

        .search-box {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .navbar {
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }

        .footer {
            background-color: #343a40;
            color: white;
            padding: 40px 0;
            margin-top: 40px;
        }

        /* 导航栏样式 */
        .navbar {
            background: linear-gradient(to right, #1a237e, #0d47a1) !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: bold;
            letter-spacing: 1px;
        }

        .nav-link {
            position: relative;
            padding: 0.5rem 1rem;
            transition: color 0.3s ease;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: #fff;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::after {
            width: 80%;
        }

        /* 头部大图样式 */
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), 
                        url('https://source.unsplash.com/random/1920x1080/?news') no-repeat center center;
            background-size: cover;
            padding: 150px 0;
            margin-bottom: 60px;
        }

        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        .hero-section .lead {
            font-size: 1.5rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }

        /* 搜索框样式 */
        .search-box {
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }

        .search-box input {
            border: none;
            background: rgba(255,255,255,0.9);
            padding: 15px 25px;
            border-radius: 30px;
            font-size: 1.1rem;
        }

        .search-box button {
            padding: 15px 30px;
            border-radius: 30px;
            font-weight: 600;
        }

        /* 新闻分类卡片样式 */
        .category-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 30px;
        }

        .category-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .category-icon {
            font-size: 3rem;
            margin: 20px 0;
        }

        /* 最新新闻样式 */
        .latest-news {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 80px 0;
            margin: 60px 0;
        }

        .news-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .news-card img {
            transition: transform 0.3s ease;
        }

        .news-card:hover img {
            transform: scale(1.05);
        }

        /* 页脚样式 */
        .footer {
            background: #1a237e;
            color: white;
            padding: 60px 0 30px;
        }

        .footer h5 {
            color: #fff;
            font-weight: 600;
            margin-bottom: 25px;
        }

        .footer ul li {
            margin-bottom: 15px;
        }

        .footer a {
            color: rgba(255,255,255,0.8);
            transition: color 0.3s ease;
            text-decoration: none;
        }

        .footer a:hover {
            color: white;
        }

        /* 动画效果 */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-fadeInUp {
            animation: fadeInUp 0.6s ease forwards;
        }

        .tag-cloud {
            text-align: center;
        }

        .tag-item {
            display: inline-block;
            padding: 8px 15px;
            margin: 5px;
            background: white;
            border-radius: 20px;
            text-decoration: none;
            color: #333;
            font-size: var(--size, 1rem);
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .tag-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            background: #007bff;
            color: white;
        }

        .tag-count {
            font-size: 0.8em;
            color: #666;
            margin-left: 5px;
        }

        .back-to-top {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 1000;
        }

        .back-to-top.visible {
            opacity: 1;
        }

        /* 轮播样式 */
        .carousel-item {
            height: 400px;
            background-color: #000;
        }
        
        .carousel-caption {
            background: rgba(0,0,0,0.5);
            padding: 20px;
            border-radius: 10px;
        }

        /* 导航栏样式优化 */
        .navbar {
            background: linear-gradient(135deg, #1a237e 0%, #0d47a1 100%);
            padding: 0.5rem 0;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            padding: 0.5rem 0;
            background: rgba(26, 35, 126, 0.95) !important;
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: 1px;
        }

        .navbar-brand i {
            margin-right: 8px;
        }

        .nav-link {
            font-weight: 500;
            padding: 0.5rem 1rem;
            position: relative;
        }

        .nav-link i {
            margin-right: 5px;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: #fff;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::after {
            width: 80%;
        }

        .dropdown-menu {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 1rem 0;
        }

        .dropdown-item {
            padding: 0.5rem 1.5rem;
            transition: all 0.3s ease;
        }

        .dropdown-item:hover {
            background: #f8f9fa;
            transform: translateX(5px);
        }

        /* 调整页面顶部边距，适应固定导航栏 */
        body {
            padding-top: 76px;
        }

        /* 时间和天气信息样式 */
        .navbar-text {
            font-size: 0.9rem;
        }

        .navbar-text i {
            margin-right: 5px;
        }

        .navbar {
            background: linear-gradient(135deg, #1a237e 0%, #0d47a1 100%);
            padding: 0.5rem 0;
        }

        .nav-link {
            padding: 1rem 1.2rem;
            font-weight: 500;
            position: relative;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: #fff;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::after {
            width: 80%;
        }

        .navbar-nav {
            margin-left: 20px;
        }

        .navbar-brand {
            padding: 0.5rem 1rem;
            font-size: 1.4rem;
            font-weight: 700;
        }

        .navbar-text {
            margin-right: 2rem;
        }

        @media (max-width: 991.98px) {
            .navbar-nav {
                margin-left: 0;
                padding: 1rem 0;
            }
            
            .nav-link {
                padding: 0.5rem 1rem;
            }
            
            .navbar-text {
                margin: 0.5rem 0;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<!-- 在页面顶部初始化 NewsService -->
<%
    NewsService newsService = new NewsService();
%>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="bi bi-newspaper"></i> USST NEWS
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- 添加时间和天气信息 -->
        <div class="navbar-text text-white me-3 d-none d-lg-block">
            <i class="bi bi-calendar-event"></i>
            <span id="currentDate"></span>
            <i class="bi bi-clock ms-3"></i>
            <span id="currentTime"></span>
            <i class="bi bi-cloud-sun ms-3"></i>
            <span id="weather">上海</span>
        </div>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="#"><i class="bi bi-house-door"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=国内">国内</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=国际">国际</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=体育">体育</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=科技">科技</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=娱乐">娱乐</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=财经">财经</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=军事">军事</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=社会">社会</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=股市">股市</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="pages/newsList.jsp?category=美股">美股</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- 头部大图 -->
<section class="hero-section text-center">
    <div class="container">
        <h1 class="display-4 mb-4">欢迎访问USST新闻网站</h1>
        <p class="lead mb-4">及时、准确、全面的新闻资讯平台</p>
        <div class="search-box">
            <form class="d-flex justify-content-center" action="${pageContext.request.contextPath}/pages/searchResults.jsp" method="get">
                <input class="form-control me-2 w-50" type="text" name="query" placeholder="搜索感兴趣的新闻..." required>
                <button class="btn btn-primary" type="submit">搜索</button>
            </form>
        </div>
    </div>
</section>

<!-- 新闻图片轮播 -->
<section class="container my-5">
    <div id="newsCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <% 
            try {
                // 使用随机新闻替换热门新闻
                List<News> carouselNews = newsService.getRandomNews(6);
                for(int i = 0; i < carouselNews.size(); i++) {
            %>
                <button type="button" data-bs-target="#newsCarousel" 
                        data-bs-slide-to="<%= i %>" 
                        class="<%= i == 0 ? "active" : "" %>"></button>
            <% 
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
        </div>
        <div class="carousel-inner">
            <% 
            try {
                // 使用随机新闻替换热门新闻
                List<News> carouselNews = newsService.getRandomNews(6);
                for(int i = 0; i < carouselNews.size(); i++) {
                    News news = carouselNews.get(i);
            %>
            <div class="carousel-item <%= i == 0 ? "active" : "" %>">
                <img src="<%= news.getImage() %>" class="d-block w-100" alt="新闻图片"
                     style="height: 400px; object-fit: cover;"
                     onerror="this.src='images/default.jpg'">
                <div class="carousel-caption d-none d-md-block">
                    <h5><%= news.getTitle() %></h5>
                    <p><%= news.getDescription().length() > 100 ? 
                           news.getDescription().substring(0, 100) + "..." : 
                           news.getDescription() %></p>
                    <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= news.getId() %>" 
                       class="btn btn-primary btn-sm">阅读更多</a>
                </div>
            </div>
            <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#newsCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#newsCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
</section>


<!-- 第一个广告位 - 轮播图下方 -->
<div class="ad-container mb-4">
    <jsp:include page="pages/_ad.jsp">
        <jsp:param name="position" value="index_carousel_bottom"/>
        <jsp:param name="template" value="inFeed"/>
    </jsp:include>
</div>

<!-- 新闻分类 -->
<section class="container my-5">
    <h2 class="text-center mb-5">新闻分类</h2>
    <div class="row justify-content-center">
        <!-- 第一排 -->
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">🏛️</div>
                    <h5 class="category-title">国内新闻</h5>
                    <a href="${pageContext.request.contextPath}/pages/newsList.jsp?category=国内" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">🌏</div>
                    <h5 class="category-title">国际新闻</h5>
                    <a href="pages/newsList.jsp?category=国际" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">⚽</div>
                    <h5 class="category-title">体育新闻</h5>
                    <a href="pages/newsList.jsp?category=体育" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">💡</div>
                    <h5 class="category-title">科技新闻</h5>
                    <a href="pages/newsList.jsp?category=科技" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        
        <!-- 第二排 -->
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">🎬</div>
                    <h5 class="category-title">娱乐新闻</h5>
                    <a href="pages/newsList.jsp?category=娱乐" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">💰</div>
                    <h5 class="category-title">财经新闻</h5>
                    <a href="pages/newsList.jsp?category=财经" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">🎖️</div>
                    <h5 class="category-title">军事新闻</h5>
                    <a href="pages/newsList.jsp?category=军事" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">👥</div>
                    <h5 class="category-title">社会新闻</h5>
                    <a href="pages/newsList.jsp?category=社会" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>

        <!-- 第三排（居中显示最后两个） -->
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">📈</div>
                    <h5 class="category-title">股市新闻</h5>
                    <a href="pages/newsList.jsp?category=股市" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card category-card text-center">
                <div class="card-body">
                    <div class="category-icon">🏛</div>
                    <h5 class="category-title">美股新闻</h5>
                    <a href="pages/newsList.jsp?category=美股" class="btn btn-outline-primary">浏览</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 修改热门标签云部分 -->
<section class="container my-5">
    <h2 class="text-center mb-4">热门分类</h2>
    <div class="tag-cloud p-4 bg-light rounded">
        <a href="pages/newsList.jsp?category=国内" class="tag-item">国内<span class="tag-count">
            <%= newsService.getNewsByCategory("国内").size() %>
        </span></a>
        <a href="pages/newsList.jsp?category=国际" class="tag-item">国际<span class="tag-count">
            <%= newsService.getNewsByCategory("国际").size() %>
        </span></a>
        <a href="pages/newsList.jsp?category=科技" class="tag-item">科技<span class="tag-count">
            <%= newsService.getNewsByCategory("科技").size() %>
        </span></a>
        <a href="pages/newsList.jsp?category=财经" class="tag-item">财经<span class="tag-count">
            <%= newsService.getNewsByCategory("财经").size() %>
        </span></a>
        <a href="pages/newsList.jsp?category=体育" class="tag-item">体育<span class="tag-count">
            <%= newsService.getNewsByCategory("体育").size() %>
        </span></a>
        <a href="pages/newsList.jsp?category=娱乐" class="tag-item">娱乐<span class="tag-count">
            <%= newsService.getNewsByCategory("娱乐").size() %>
        </span></a>
    </div>
</section>

<!-- 修改最新新闻部分 -->
<section class="latest-news">
    <div class="container">
        <h2 class="text-center mb-5">最新新闻</h2>
        <div class="row">
            <% 
                List<News> latestNews = null;
                try {
                    // 使用随机新闻替代最新新闻
                    latestNews = newsService.getRandomNews(4);
                } catch (Exception e) {
                    e.printStackTrace();
                    latestNews = new ArrayList<>();
                }
                
                if (latestNews != null) {
                    for (News news : latestNews) {
            %>
            <div class="col-md-6 mb-4">
                <div class="card news-card h-100">
                    <div class="row g-0">
                        <div class="col-md-4">
                            <img src="<%= news.getImage() %>" class="img-fluid rounded-start h-100" 
                                 alt="新闻图片" style="object-fit: cover;"
                                 onerror="this.src='images/default.jpg'">
                        </div>
                        <div class="col-md-8">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= news.getId() %>" 
                                       class="text-decoration-none text-dark">
                                        <%= news.getTitle() %>
                                    </a>
                                </h5>
                                <p class="card-text">
                                    <%= news.getDescription().length() > 100 ? 
                                        news.getDescription().substring(0, 100) + "..." : 
                                        news.getDescription() %>
                                </p>
                                <p class="card-text">
                                    <small class="text-muted">
                                        <span class="me-2"><i class="bi bi-calendar"></i> <%= news.getPublishTime() %></span>
                                        <span class="me-2"><i class="bi bi-tag"></i> <%= news.getCategory() %></span>
                                        <span><i class="bi bi-eye"></i> <%= news.getViews() %></span>
                                    </small>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</section>

<!-- 在最新新闻部分添加实时统计 -->
<div class="stats-bar bg-dark text-white py-3 mb-4">
    <div class="container">
        <div class="row text-center">
            <div class="col-md-3">
                <div class="stat-item">
                    <h3 class="stat-number">
                        <% try { %>
                            <%= newsService.getTotalNewsCount() %>
                        <% } catch (Exception e) { %>
                            0
                        <% } %>
                    </h3>
                    <p class="stat-label">总文章数</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-item">
                    <h3 class="stat-number">
                        <% try { %>
                            <%= newsService.getTodayNewsCount() %>
                        <% } catch (Exception e) { %>
                            0
                        <% } %>
                    </h3>
                    <p class="stat-label">今日更新</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-item">
                    <h3 class="stat-number">
                        <% try { %>
                            <%= newsService.getTotalViews() %>
                        <% } catch (Exception e) { %>
                            0
                        <% } %>
                    </h3>
                    <p class="stat-label">总阅读量</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-item">
                    <h3 class="stat-number">
                        <% try { %>
                            <%= newsService.getOnlineUsers() %>
                        <% } catch (Exception e) { %>
                            0
                        <% } %>
                    </h3>
                    <p class="stat-label">在线用户</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 添加返回顶部按钮 -->
<button id="backToTop" class="back-to-top">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- 第二个广告位 - 分类卡片后，页脚前 -->
<div class="ad-container mb-4">
    <jsp:include page="pages/_ad.jsp">
        <jsp:param name="position" value="index_bottom"/>
        <jsp:param name="template" value="inFeed"/>
    </jsp:include>
</div>

<!-- 第三个广告位 - 固定在页面底部 -->
<div class="ad-container">
    <jsp:include page="pages/_ad.jsp">
        <jsp:param name="position" value="index_float_bottom"/>
        <jsp:param name="template" value="bottomBanner"/>
    </jsp:include>
</div>

<!-- 页脚 -->
<jsp:include page="pages/common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/userTracker.js"></script>
<script>
    // 添加滚动动画
    document.addEventListener('DOMContentLoaded', function() {
        const animateElements = document.querySelectorAll('.category-card, .news-card');
        
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

    // 添加平滑滚动
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });

    // 返回顶部按钮逻辑
    const backToTopButton = document.getElementById('backToTop');

    window.addEventListener('scroll', () => {
        if (window.pageYOffset > 300) {
            backToTopButton.classList.add('visible');
        } else {
            backToTopButton.classList.remove('visible');
        }
    });

    backToTopButton.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });

    // 更新时间日期
    function updateDateTime() {
        const now = new Date();
        const dateOptions = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
        const timeOptions = { hour: '2-digit', minute: '2-digit', second: '2-digit' };
        
        document.getElementById('currentDate').textContent = now.toLocaleDateString('zh-CN', dateOptions);
        document.getElementById('currentTime').textContent = now.toLocaleTimeString('zh-CN', timeOptions);
    }

    // 初始更新并每秒更新一次
    updateDateTime();
    setInterval(updateDateTime, 1000);

    // 导航栏滚动效果
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // 获取天气信息
    async function getWeather() {
        try {
            const response = await fetch('https://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=Shanghai');
            const data = await response.json();
            document.getElementById('weather').textContent = 
                `上海 ${data.current.temp_c}°C ${data.current.condition.text}`;
        } catch (error) {
            console.error('获取天气信息失败:', error);
        }
    }

    getWeather();

    document.addEventListener('DOMContentLoaded', function() {
        // 首页默认分类为 "home"，标签包含热门分类
        const popularCategories = [
            "国内", "国际", "财经", "科技", "军事", 
            "体育", "娱乐", "社会"
        ].join(',');
        
        UserTracker.sendUserData(${sessionScope.get("userId")},'main', popularCategories);
    });
</script>
</body>
</html>