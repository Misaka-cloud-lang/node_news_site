<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>系统错误</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background-color: #f5f5f5;
        }
        .error-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
        }
        h1 {
            color: #d32f2f;
            margin-bottom: 20px;
        }
        .error-details {
            color: #666;
            margin: 20px 0;
            text-align: left;
            padding: 10px;
            background-color: #f8f8f8;
            border-radius: 4px;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #1976d2;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>系统错误</h1>
        <p>抱歉，系统处理您的请求时出现错误。</p>
        <div class="error-details">
            <p>错误类型：${pageContext.exception.getClass().getName()}</p>
            <p>错误信息：${pageContext.exception.message}</p>
        </div>
        <a href="/" class="back-link">返回首页</a>
    </div>
    <div class="container mt-4">
        <!-- 添加一个小广告 -->
        <div class="mt-4">
            <jsp:include page="_ad.jsp">
                <jsp:param name="position" value="content"/>
                <jsp:param name="size" value="small"/>
            </jsp:include>
        </div>
    </div>
</body>
</html> 