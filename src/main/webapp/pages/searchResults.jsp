<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>新闻搜索结果</title>
</head>
<body>
<h1>搜索结果</h1>

<c:if test="${not empty searchResults}">
  <ul>
    <c:forEach var="news" items="${searchResults}">
      <li>
        <a href="newsDetail?id=${news.id}">${news.title}</a>
        <p>${news.content}</p>
      </li>
    </c:forEach>
  </ul>
</c:if>

<c:if test="${empty searchResults}">
  <p>没有找到匹配的新闻。</p>
</c:if>

<br>
<a href="index.jsp">返回首页</a>
</body>
</html>
