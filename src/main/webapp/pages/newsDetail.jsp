<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>新闻详情</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<!-- 头部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">usst在线新闻网站</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item"><a class="nav-link" href="index.jsp">首页</a></li>
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

<!-- 其他页面内容 -->
<div class="container mt-4">
  <div class="row">
    <!-- 新闻详情部分 -->
    <div class="col-md-9">
      <h2 class="mb-4">${news.title}</h2>
      <p><strong>分类：</strong>${news.category}</p>
      <p><strong>描述：</strong>${news.description}</p>

      <!-- 显示新闻图片 -->
      <img src="${news.image != null && !news.image.isEmpty() ? news.image : 'images/default.jpg'}" class="img-fluid" alt="新闻图片">
    </div>

    <!-- 广告栏部分 -->
    <div class="col-md-3">
      <div class="mb-4 p-3 bg-light border text-center">
        <p class="fw-bold">广告位 1</p>
        <p>广告内容</p>
        <img src="images/ad1.jpg" alt="广告图片" class="img-fluid">
      </div>
      <div class="p-3 bg-light border text-center">
        <p class="fw-bold">广告位 2</p>
        <p>另一种广告形式</p>
        <img src="images/ad2.jpg" alt="广告图片" class="img-fluid">
      </div>
    </div>
  </div>
</div>


<!-- 底部 -->
<footer class="bg-light py-3 mt-5 text-center">
  <p>&copy; 2024 上海理工大学. 版权所有.</p>
</footer>



<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
