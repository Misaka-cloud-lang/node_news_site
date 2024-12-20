<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>编辑新闻</title>

  <!-- 引入 Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

  <!-- 引入外部 CSS -->
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- 头部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">usst在线新闻网站</a>
  </div>
</nav>

<!-- 编辑新闻内容 -->
<div class="container mt-4">
  <div class="row">
    <div class="col-md-9">
      <h2 class="mb-4">编辑新闻</h2>

      <form action="editNewsServlet" method="post">
        <input type="hidden" name="id" value="${news.id}">
        <div class="mb-3">
          <label for="title" class="form-label">标题</label>
          <input type="text" class="form-control" id="title" name="title" value="${news.title}" required>
        </div>
        <div class="mb-3">
          <label for="category" class="form-label">分类</label>
          <select class="form-select" id="category" name="category" required>
            <option value="国内" ${news.category == '国内' ? 'selected' : ''}>国内</option>
            <option value="国际" ${news.category == '国际' ? 'selected' : ''}>国际</option>
            <option value="经济" ${news.category == '经济' ? 'selected' : ''}>经济</option>
            <option value="科技" ${news.category == '科技' ? 'selected' : ''}>科技</option>
            <option value="娱乐" ${news.category == '娱乐' ? 'selected' : ''}>娱乐</option>
            <option value="体育" ${news.category == '体育' ? 'selected' : ''}>体育</option>
            <option value="教育" ${news.category == '教育' ? 'selected' : ''}>教育</option>
            <option value="健康" ${news.category == '健康' ? 'selected' : ''}>健康</option>
            <option value="文化" ${news.category == '文化' ? 'selected' : ''}>文化</option>
            <option value="军事" ${news.category == '军事' ? 'selected' : ''}>军事</option>
          </select>
        </div>
        <div class="mb-3">
          <label for="content" class="form-label">内容</label>
          <textarea class="form-control" id="content" name="content" rows="5" required>${news.content}</textarea>
        </div>
        <div class="mb-3">
          <label for="image" class="form-label">图片 URL</label>
          <input type="text" class="form-control" id="image" name="image" value="${news.image}" required>
        </div>
        <button type="submit" class="btn btn-primary">保存</button>
      </form>
    </div>

    <!-- 广告栏（通过 jsp:include 引入广告模板）-->
    <jsp:include page="/pages/_ad.jsp" />
  </div>
</div>

<!-- 底部 -->
<footer class="bg-light py-3 mt-5 text-center">
  <p>&copy; 2024 上海理工大学. 版权所有.</p>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
