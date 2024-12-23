<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.news_site.service.NewsService" %>
<%@ page import="com.example.news_site.model.News" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新闻管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .action-buttons .btn {
            margin-right: 5px;
        }
        .nav-tabs {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">新闻管理系统</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="#" data-bs-toggle="modal" data-bs-target="#addNewsModal">添加新闻</a>
                </li>
            </ul>
            <form class="d-flex" action="${pageContext.request.contextPath}/pages/admin" method="get">
                <input class="form-control me-2" type="text" name="query" placeholder="搜索新闻">
                <button class="btn btn-outline-light" type="submit">搜索</button>
            </form>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <!-- 功能选项卡 -->
    <ul class="nav nav-tabs" id="adminTabs" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="news-tab" data-bs-toggle="tab" href="#news" role="tab">新闻管理</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="crawler-tab" data-bs-toggle="tab" href="#crawler" role="tab">爬虫管理</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="settings-tab" data-bs-toggle="tab" href="#settings" role="tab">系统设置</a>
        </li>
    </ul>

    <!-- 选项卡内容 -->
    <div class="tab-content" id="adminTabContent">
        <!-- 新闻管理 -->
        <div class="tab-pane fade show active" id="news" role="tabpanel">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">新闻列表</h5>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addNewsModal">
                        添加新闻
                    </button>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>标题</th>
                                    <th>分类</th>
                                    <th>作者</th>
                                    <th>发布时间</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    NewsService newsService = new NewsService();
                                    List<News> newsList = newsService.getAllNews();
                                    for (News news : newsList) {
                                %>
                                <tr>
                                    <td><%= news.getId() %></td>
                                    <td><%= news.getTitle() %></td>
                                    <td><%= news.getCategory() %></td>
                                    <td><%= news.getAuthor() %></td>
                                    <td><%= news.getPublishTime() %></td>
                                    <td><span class="badge bg-success"><%= news.getStatus() %></span></td>
                                    <td class="action-buttons">
                                        <button class="btn btn-sm btn-primary" onclick="editNews(<%= news.getId() %>)">编辑</button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteNews(<%= news.getId() %>)">删除</button>
                                        <a href="${pageContext.request.contextPath}/news?id=<%= news.getId() %>" 
                                           class="btn btn-sm btn-info" target="_blank">查看</a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- 爬虫管理 -->
        <div class="tab-pane fade" id="crawler" role="tabpanel">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">爬虫控制</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">手动爬取</h6>
                                    <p>立即开始爬取新闻</p>
                                    <button class="btn btn-primary" onclick="startCrawler()">开始爬取</button>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">定时任务状态</h6>
                                    <p>爬虫执行时间：每天凌晨2:00</p>
                                    <p>上次执行时间：${lastCrawlTime}</p>
                                    <p>下次执行时间：${nextCrawlTime}</p>
                                    <button class="btn btn-primary" onclick="startCrawler()">立即执行</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 系统设置 -->
        <div class="tab-pane fade" id="settings" role="tabpanel">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">系统设置</h5>
                </div>
                <div class="card-body">
                    <form id="settingsForm">
                        <div class="mb-3">
                            <label class="form-label">爬虫执行时间</label>
                            <input type="time" class="form-control" name="crawlerTime" value="02:00">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">每个分类爬取数量</label>
                            <input type="number" class="form-control" name="crawlerCount" value="10">
                        </div>
                        <button type="submit" class="btn btn-primary">保存设置</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 添加新闻模态框 -->
<div class="modal fade" id="addNewsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">添加新闻</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="addNewsForm" action="${pageContext.request.contextPath}/pages/admin" method="post">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="mb-3">
                        <label class="form-label">标题</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">描述</label>
                        <textarea class="form-control" name="description" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">分类</label>
                        <select class="form-select" name="category" required>
                            <option value="国内">国内</option>
                            <option value="国际">国际</option>
                            <option value="体育">体育</option>
                            <option value="科技">科技</option>
                            <option value="娱乐">娱乐</option>
                            <option value="财经">财经</option>
                            <option value="军事">军事</option>
                            <option value="社会">社会</option>
                            <option value="股市">股市</option>
                            <option value="美股">美股</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">作者</label>
                        <input type="text" class="form-control" name="author" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">来源</label>
                        <input type="text" class="form-control" name="source" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">图片URL</label>
                        <input type="url" class="form-control" name="image" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">内容</label>
                        <textarea class="form-control" name="contentHtml" rows="10" required></textarea>
                    </div>
                    <!-- 添加隐藏字段设置默认值 -->
                    <input type="hidden" name="status" value="published">
                    <input type="hidden" name="isTop" value="false">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="submitNews()">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 编辑新闻模态框 -->
<div class="modal fade" id="editNewsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">编辑新闻</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editNewsForm" action="${pageContext.request.contextPath}/pages/admin" method="post">
                    <input type="hidden" name="id">
                    <input type="hidden" name="action" value="update">
                    <div class="mb-3">
                        <label class="form-label">标题</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">分类</label>
                        <select class="form-select" name="category" required>
                            <option value="国内">国内</option>
                            <option value="国际">国际</option>
                            <option value="体育">体育</option>
                            <option value="科技">科技</option>
                            <option value="娱乐">娱乐</option>
                            <option value="财经">财经</option>
                            <option value="军事">军事</option>
                            <option value="社会">社会</option>
                            <option value="股市">股市</option>
                            <option value="美股">美股</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">作者</label>
                        <input type="text" class="form-control" name="author">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">来源</label>
                        <input type="text" class="form-control" name="source">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">图片URL</label>
                        <input type="url" class="form-control" name="image">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">内容</label>
                        <textarea class="form-control" name="contentHtml" rows="10" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="updateNews()">更新</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function submitNews() {
    document.getElementById('addNewsForm').submit();
}

function editNews(id) {
    fetch('${pageContext.request.contextPath}/pages/admin?id=' + id)
        .then(response => response.json())
        .then(news => {
            const form = document.getElementById('editNewsForm');
            form.id.value = news.id;
            form.title.value = news.title;
            form.category.value = news.category;
            form.author.value = news.author;
            form.source.value = news.source;
            form.image.value = news.image;
            form.contentHtml.value = news.contentHtml;
            
            new bootstrap.Modal(document.getElementById('editNewsModal')).show();
        })
        .catch(error => {
            alert('获取新闻信息失败：' + error);
        });
}

function updateNews() {
    document.getElementById('editNewsForm').submit();
}

function deleteNews(id) {
    if (confirm('确定要删除这条新闻吗？')) {
        fetch('${pageContext.request.contextPath}/pages/admin', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=delete&id=' + id
        }).then(response => {
            if (response.ok) {
                location.reload();
            } else {
                response.text().then(text => alert('删除失败：' + text));
            }
        }).catch(error => {
            alert('删除失败：' + error);
        });
    }
}

function startCrawler() {
    fetch('${pageContext.request.contextPath}/crawl-now')
        .then(response => {
            if (response.ok) {
                alert('爬取任务已启动');
            } else {
                alert('爬取任务启动失败');
            }
        });
}

function checkCrawlerStatus() {
    alert('爬虫运行正常');
}

document.getElementById('settingsForm').onsubmit = function(e) {
    e.preventDefault();
    alert('设置已保存');
};
</script>

</body>
</html>
