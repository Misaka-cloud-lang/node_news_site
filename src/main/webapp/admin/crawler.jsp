<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>新闻爬虫管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>新闻爬虫管理</h2>
        
        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">手动爬取新闻</h5>
                <form action="${pageContext.request.contextPath}/admin/crawler" method="post">
                    <div class="mb-3">
                        <label class="form-label">选择要爬取的分类：</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="categories" value="all" checked>
                            <label class="form-check-label">全部分类</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="categories" value="国内">
                            <label class="form-check-label">国内</label>
                        </div>
                        <!-- 其他分类... -->
                    </div>
                    <button type="submit" class="btn btn-primary">开始爬取</button>
                </form>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">爬虫状态</h5>
                <p>上次爬取时间：${lastCrawlTime}</p>
                <p>爬取新闻总数：${totalNews}</p>
                <p>各分类新闻数量：</p>
                <ul>
                    <li>国内：${categoryCount['国内']}</li>
                    <li>国际：${categoryCount['国际']}</li>
                    <!-- 其他分类... -->
                </ul>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 