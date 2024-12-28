<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.dao.NewsDAO" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<%
    News news = null;
    List<News> relatedNews = null;
    String errorMessage = null;
    
    try {
        // 获取新闻ID
        String newsId = request.getParameter("id");
        if (newsId != null) {
            NewsDAO newsDao = new NewsDAO();
            System.out.println("Trying to fetch news with ID: " + newsId); // 调试信息
            news = newsDao.getNewsById(Integer.parseInt(newsId));
            
            if (news != null) {
                System.out.println("Found news: " + news.getTitle()); // 调试信息
            } else {
                System.out.println("No news found with ID: " + newsId); // 调试信息
                errorMessage = "未找到相关新闻或新闻已被删除";
            }
            
            // 获取相关新闻
            if (news != null) {
                relatedNews = newsDao.getNewsByCategory(news.getCategory());
                // 移除当前新闻
                for (int i = 0; i < relatedNews.size(); i++) {
                    if (relatedNews.get(i).getId() == news.getId()) {
                        relatedNews.remove(i);
                        break;
                    }
                }
                // 限制相关新闻数量
                if (relatedNews.size() > 4) {
                    relatedNews = relatedNews.subList(0, 4);
                }
            } else {
                errorMessage = "未找到相关新闻或新闻已被删除";
            }
        } else {
            errorMessage = "新闻ID不能为空";
        }
    } catch (NumberFormatException e) {
        errorMessage = "新闻ID格式错误";
    } catch (Exception e) {
        System.err.println("Error in newsDetail.jsp: " + e.getMessage()); // 调试信息
        e.printStackTrace();
        errorMessage = "系统错误：" + e.getMessage();
    }

    // 如果有错误，显示错误页面
    if (errorMessage != null) {
        request.setAttribute("error", errorMessage);
        request.setAttribute("returnUrl", request.getContextPath() + "/");
%>
        <jsp:forward page="error.jsp"/>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= news.getTitle() %> - USST新闻网</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        /* 确保页面容器占满整个视口高度 */
        html, body {
            height: 100%;
            margin: 0;
        }

        /* 使用 flex 布局来组织页面结构 */
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* 导航栏固定样式 */
        .navbar {
            flex-shrink: 0;
        }

        /* 主要内容区域自动填充剩余空间 */
        .main-content {
            flex: 1 0 auto;
            width: 100%;
            padding-bottom: 2rem;
        }

        /* 页脚固定样式 */
        .footer {
            flex-shrink: 0;
            width: 100%;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
            position: relative; /* 确保页脚在内容之上 */
            z-index: 100;     /* 提高页脚的层级 */
        }

        /* 确保内容不会溢出容器 */
        .news-article {
            overflow-wrap: break-word;
            word-wrap: break-word;
            hyphens: auto;
        }

        /* 图片容器最大高度限制 */
        .image-container {
            max-height: 600px;
            overflow: hidden;
        }

        /* 移除之前可能冲突的样式 */
        .container.mt-4 {
            margin-bottom: 0;
        }

        /* 新闻主体样式 */
        .news-article {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 30px;
        }

        /* 新闻标题样式 */
        .news-title {
            font-size: 2rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 1.5rem;
            line-height: 1.4;
        }

        /* 元信息样式 */
        .news-meta {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            margin-bottom: 15px;
            color: #666;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .meta-item i {
            color: #1e3799;
        }

        /* 新闻图片样式 */
        .news-image {
            width: 100%;
            max-height: 400px;
            object-fit: contain;
            border-radius: 12px;
            margin: 10px 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* 新闻内容样式 */
        .news-content {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #333;
            margin-top: 15px;
        }

        /* 相关新闻卡片样式 */
        .related-news {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
        }

        .related-news h4 {
            color: #1a1a1a;
            margin-bottom: 20px;
            font-weight: 600;
            padding-bottom: 15px;
            border-bottom: 2px solid #1e3799;
        }

        .related-news .card {
            border: none;
            border-radius: 8px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 15px;
        }

        .related-news .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .related-news .card-title {
            font-size: 1rem;
            line-height: 1.4;
        }

        /* 分享按钮样式 */
        .share-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .share-btn {
            padding: 8px 15px;
            border-radius: 20px;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9rem;
            transition: opacity 0.3s ease;
        }

        .share-btn:hover {
            opacity: 0.9;
        }

        .share-btn.weixin { background: #07C160; }
        .share-btn.weibo { background: #E6162D; }
        .share-btn.qq { background: #1DA1F2; }

        /* 标签云样式 */
        .tags-cloud {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
        }
        
        .tag-item {
            display: inline-block;
            padding: 5px 12px;
            margin: 4px;
            border-radius: 15px;
            font-size: 0.9rem;
            color: #fff;
            background: var(--tag-color, #1e3799);
            transition: transform 0.2s;
        }
        
        .tag-item:hover {
            transform: scale(1.05);
        }

        /* 互动区域样式 */
        .interaction-area {
            display: flex;
            gap: 15px;
            margin: 30px 0;
            justify-content: center;
        }

        .interaction-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 10px 20px;
            border-radius: 8px;
            border: 1px solid #eee;
            cursor: pointer;
            transition: all 0.3s;
        }

        .interaction-btn:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
        }

        .interaction-btn i {
            font-size: 1.5rem;
            margin-bottom: 5px;
            color: #1e3799;
        }

        .interaction-count {
            color: #666;
            font-size: 0.9rem;
        }

        /* 热门推荐样式 */
        .hot-news {
            background: linear-gradient(135deg, #1e3799 0%, #0c2461 100%);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            color: white;
        }

        .hot-news h4 {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.2);
        }

        .hot-news .card {
            background: rgba(255,255,255,0.1);
            border: none;
            margin-bottom: 15px;
        }

        .hot-news .card-body {
            padding: 15px;
        }

        .hot-news .card-title a {
            color: white !important;
        }

        .hot-news .text-muted {
            color: rgba(255,255,255,0.7) !important;
        }

        /* 修改图片容器样式 */
        .image-container {
            text-align: center;
            margin: 10px 0;
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 12px;
            min-height: 100px; /* 设置最小高度 */
            position: relative; /* 为加载动画定位 */
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* 图片加载动画 */
        .image-loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #666;
        }

        /* 修改图片样式 */
        .news-image {
            max-width: 100%;
            height: auto;
            max-height: 400px;
            object-fit: contain;
            border-radius: 8px;
            margin: 0; /* 移除margin */
            display: none; /* 默认隐藏 */
        }

        .news-image.loaded {
            display: block; /* 加载完成后显示 */
        }

        /* 图片错误提示样式 */
        .image-error {
            padding: 20px;
            color: #666;
            font-size: 0.9rem;
            display: none;
        }

        /* 添加图片说明样式 */
        .image-caption {
            font-size: 0.9rem;
            color: #666;
            margin-top: 8px;
        }

        /* 确保页面内容最小高度，使页脚保持在底部 */
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 主要内容区域自动填充空间 */
        .main-content {
            flex: 1 0 auto;
            padding-bottom: 3rem; /* 增加内容区域和页脚之间的间距 */
        }

        /* 页脚样式调整 */
        .footer {
            flex-shrink: 0;
            margin-top: auto !important;
        }

        /* 调整内容区域的下边距 */
        .container.mt-4 {
            margin-bottom: 3rem;
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp" />
    
    <main class="main-content">
        <div class="container mt-4">
            <div class="row">
                <!-- 主要内容区 -->
                <div class="col-lg-8">
                    <article class="news-article">
                        <h1 class="news-title"><%= news.getTitle() %></h1>
                        
                        <div class="news-meta">
                            <div class="meta-item">
                                <i class="bi bi-person-circle"></i>
                                <span><%= news.getAuthor() %></span>
                            </div>
                            <div class="meta-item">
                                <i class="bi bi-calendar3"></i>
                                <span><%= news.getPublishTime() %></span>
                            </div>
                            <div class="meta-item">
                                <i class="bi bi-eye"></i>
                                <span><%= news.getViews() %> 阅读</span>
                            </div>
                            <div class="meta-item">
                                <i class="bi bi-tag"></i>
                                <span><%= news.getCategory() %></span>
                            </div>
                        </div>
                        
                        <% if (news.getImage() != null && !news.getImage().isEmpty()) { %>
                            <div class="image-container">
                                <!-- 加载动画 -->
                                <div class="image-loading">
                                    <i class="bi bi-arrow-repeat spin"></i> 图片加载中...
                                </div>
                                
                                <!-- 图片 -->
                                <img src="<%= news.getImage() %>" 
                                     class="news-image" 
                                     alt="<%= news.getTitle() %>"
                                     onload="this.classList.add('loaded'); this.parentElement.querySelector('.image-loading').style.display='none';"
                                     onerror="handleImageError(this)">
                                
                                <!-- 图片说明 -->
                                <div class="image-caption">
                                    图片来源：<%= news.getSource() != null ? news.getSource() : "USST新闻网" %>
                                </div>
                                
                                <!-- 错误提示 -->
                                <div class="image-error">
                                    <i class="bi bi-exclamation-circle"></i> 图片加载失败
                                </div>
                            </div>
                        <% } %>
                        
                        <div class="news-content">
                            <% if (news.getContent() != null && !news.getContent().isEmpty()) { %>
                                <%= news.getContent() %>
                            <% } else { %>
                                <!-- Debug: No content available -->
                                <p class="text-muted">暂无内容</p>
                            <% } %>
                        </div>

                        <!-- 分享按钮 -->
                        <div class="share-buttons">
                            <a href="#" class="share-btn weixin">
                                <i class="bi bi-wechat"></i> 微信
                            </a>
                            <a href="#" class="share-btn weibo">
                                <i class="bi bi-sina-weibo"></i> 微博
                            </a>
                            <a href="#" class="share-btn qq">
                                <i class="bi bi-qq"></i> QQ
                            </a>
                        </div>

                        <!-- 在新闻内容后添加互动区域 -->
                        <div class="interaction-area">
                            <div class="interaction-btn" onclick="updateCount(this, 'likes')">
                                <i class="bi bi-heart"></i>
                                <span class="interaction-count"><%= news.getLikes() + (int)(Math.random() * 50) %></span>
                                <span>点赞</span>
                            </div>
                            <div class="interaction-btn" onclick="updateCount(this, 'collects')">
                                <i class="bi bi-bookmark"></i>
                                <span class="interaction-count"><%= (int)(Math.random() * 30) %></span>
                                <span>收藏</span>
                            </div>
                            <div class="interaction-btn" onclick="updateCount(this, 'shares')">
                                <i class="bi bi-share"></i>
                                <span class="interaction-count"><%= (int)(Math.random() * 20) %></span>
                                <span>分享</span>
                            </div>
                        </div>
                    </article>
                </div>
                
                <!-- 侧边栏 -->
                <div class="col-lg-4">
                    <!-- 相关新闻 -->
                    <% if (relatedNews != null && !relatedNews.isEmpty()) { %>
                        <div class="related-news">
                            <h4><i class="bi bi-newspaper me-2"></i>相关新闻</h4>
                            <% for (News related : relatedNews) { %>
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <a href="${pageContext.request.contextPath}/pages/newsDetail.jsp?id=<%= related.getId() %>" 
                                               class="text-decoration-none text-dark">
                                                <%= related.getTitle() %>
                                            </a>
                                        </h6>
                                        <div class="d-flex justify-content-between align-items-center mt-2">
                                            <small class="text-muted">
                                                <i class="bi bi-calendar me-1"></i>
                                                <%= related.getPublishTime() %>
                                            </small>
                                            <small class="text-muted">
                                                <i class="bi bi-eye me-1"></i>
                                                <%= related.getViews() %>
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>

                    <!-- 在侧边栏添加标签云 -->
                    <div class="tags-cloud mb-4">
                        <h4><i class="bi bi-tags me-2"></i>热门标签</h4>
                        <%
                            String[] tags = {"科技创新", "人工智能", "数字经济", "互联网+", "5G通信", "区块链", "元宇宙", "智能制造"};
                            String[] colors = {"#1e3799", "#8c7ae6", "#e1b12c", "#44bd32", "#40739e", "#c23616", "#273c75", "#e84118"};
                            for(int i = 0; i < tags.length; i++) {
                        %>
                            <a href="#" class="tag-item" style="--tag-color: <%= colors[i] %>">
                                <%= tags[i] %>
                            </a>
                        <% } %>
                    </div>

                    <!-- 添加热门推荐 -->
                    <div class="hot-news">
                        <h4><i class="bi bi-fire me-2"></i>热门推荐</h4>
                        <%
                            // 模拟热门新闻数据
                            for(int i = 0; i < 3; i++) {
                        %>
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">
                                        <a href="#" class="text-decoration-none">
                                            <%= new String[]{"最新科技成果发布会召开", "人工智能领域重大突破", "数字经济发展新动态"}[i] %>
                                        </a>
                                    </h6>
                                    <div class="d-flex justify-content-between align-items-center mt-2">
                                        <small class="text-muted">
                                            <i class="bi bi-fire me-1"></i>
                                            <%= (int)(Math.random() * 1000 + 500) %> 热度
                                        </small>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function updateCount(element, type) {
        let countElement = element.querySelector('.interaction-count');
        let count = parseInt(countElement.textContent);
        countElement.textContent = count + 1;
        
        // 添加动画效果
        element.style.transform = 'scale(1.1)';
        setTimeout(() => element.style.transform = 'scale(1)', 200);
        
        // 显示提示信息
        showToast(type);
    }

    function showToast(type) {
        const messages = {
            'likes': '感谢点赞！',
            'collects': '已添加到收藏！',
            'shares': '分享链接已复制！'
        };
        
        // 创建toast提示
        const toast = document.createElement('div');
        toast.className = 'toast show position-fixed';
        toast.style.bottom = '20px';
        toast.style.right = '20px';
        toast.style.zIndex = '1050';
        toast.innerHTML = `
            <div class="toast-body">
                <i class="bi bi-check-circle-fill text-success me-2"></i>
                ${messages[type]}
            </div>
        `;
        
        document.body.appendChild(toast);
        setTimeout(() => toast.remove(), 2000);
    }

    function handleImageError(img) {
        // 隐藏加载动画
        img.parentElement.querySelector('.image-loading').style.display = 'none';
        
        // 尝试使用默认图片
        img.src = '${pageContext.request.contextPath}/images/default.jpg';
        img.onerror = null; // 防止循环调用
        
        // 如果默认图片也失败，显示错误提示
        img.onload = function() {
            img.classList.add('loaded');
        };
        
        // 显示错误提示
        img.parentElement.querySelector('.image-error').style.display = 'block';
    }

    // 添加加载动画的CSS
    document.head.insertAdjacentHTML('beforeend', `
        <style>
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
            .spin {
                animation: spin 1s linear infinite;
                display: inline-block;
            }
        </style>
    `);
    </script>
</body>
</html>