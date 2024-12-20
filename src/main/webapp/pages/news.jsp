<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${category} 新闻</title>

  <!-- 引入 Bootstrap CSS 和 JS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <!-- 自定义样式 -->
  <style>
    .news-card {
      margin-bottom: 20px;
    }
    footer {
      background-color: #f8f9fa;
      padding: 20px;
      text-align: center;
    }
  </style>
</head>
<body>

<!-- 头部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">usst在线新闻网站</a>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item"><a class="nav-link" href="news?category=国内">国内</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=国际">国际</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=经济">经济</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=科技">科技</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=娱乐">娱乐</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=体育">体育</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=教育">教育</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=健康">健康</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=文化">文化</a></li>
        <li class="nav-item"><a class="nav-link" href="news?category=军事">军事</a></li>
      </ul>
      <form class="d-flex ms-auto" action="news" method="get">
        <input class="form-control me-2" type="text" name="query" placeholder="搜索新闻" required>
        <button class="btn btn-outline-light" type="submit">搜索</button>
      </form>
    </div>
  </div>
</nav>

<!-- 新闻分类展示 -->
<div class="container mt-4">
  <h4>新闻分类: ${category}</h4>
  <div class="row">
    <c:forEach var="newsItem" items="${newsList}">
      <div class="col-md-4">
        <div class="card news-card">
          <img src="${newsItem.imageUrl != null && !newsItem.imageUrl.isEmpty() ? newsItem.imageUrl : 'images/default.jpg'}"
               class="card-img-top" alt="新闻图片">
          <div class="card-body">
            <h5 class="card-title">${newsItem.title}</h5>
            <p class="card-text text-truncate">${newsItem.summary}</p>
            <c:if test="${newsItem.id != null}">
              <a href="news?id=${newsItem.id}" class="btn btn-primary">查看详情</a>
            </c:if>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<!-- 分页功能 -->
<div class="container mt-4">
  <nav>
    <ul class="pagination justify-content-center">
      <c:if test="${page > 1}">
        <li class="page-item">
          <a class="page-link" href="news?category=${category}&page=1" aria-label="First">
            <span aria-hidden="true">&laquo;&laquo;</span>
          </a>
        </li>
        <li class="page-item">
          <a class="page-link" href="news?category=${category}&page=${page - 1}" aria-label="Previous">
            <span aria-hidden="true">&laquo;</span>
          </a>
        </li>
      </c:if>
      <c:forEach var="i" begin="1" end="${totalPages}">
        <li class="page-item ${i == page ? 'active' : ''}">
          <a class="page-link" href="news?category=${category}&page=${i}">${i}</a>
        </li>
      </c:forEach>
      <c:if test="${page < totalPages}">
        <li class="page-item">
          <a class="page-link" href="news?category=${category}&page=${page + 1}" aria-label="Next">
            <span aria-hidden="true">&raquo;</span>
          </a>
        </li>
        <li class="page-item">
          <a class="page-link" href="news?category=${category}&page=${totalPages}" aria-label="Last">
            <span aria-hidden="true">&raquo;&raquo;</span>
          </a>
        </li>
      </c:if>
    </ul>
  </nav>
</div>

<!-- 底部 -->
<footer class="mt-5">
  <p>&copy; 2024 上海大学. 版权所有.</p>
</footer>

</body>
</html>
