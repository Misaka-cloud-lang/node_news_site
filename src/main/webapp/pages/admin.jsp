<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>新闻后台管理</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        form {
            margin-bottom: 20px;
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"],
        textarea,
        input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .form-container {
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<h1>新闻后台管理</h1>

<!-- 添加新闻表单 -->
<div class="form-container">
    <form action="AdminServlet?action=addNews" method="post">
        <fieldset>
            <legend>添加新闻</legend>
            <label for="addNewsTitle">新闻标题:</label>
            <input type="text" id="addNewsTitle" name="title" required><br>
            <label for="addNewsContent">新闻内容:</label>
            <textarea id="addNewsContent" name="content" required></textarea><br>
            <label for="addNewsCategoryId">新闻分类ID:</label>
            <input type="number" id="addNewsCategoryId" name="categoryId" required><br>
            <input type="submit" value="添加新闻">
        </fieldset>
    </form>
</div>

<!-- 编辑新闻表单 -->
<div class="form-container">
    <form action="AdminServlet?action=editNews" method="post">
        <fieldset>
            <legend>编辑新闻</legend>
            <label for="editNewsId">新闻ID:</label>
            <input type="number" id="editNewsId" name="newsId" required><br>
            <label for="editNewsTitle">新闻标题:</label>
            <input type="text" id="editNewsTitle" name="title" required><br>
            <label for="editNewsContent">新闻内容:</label>
            <textarea id="editNewsContent" name="content" required></textarea><br>
            <label for="editNewsCategoryId">新闻分类ID:</label>
            <input type="number" id="editNewsCategoryId" name="categoryId" required><br>
            <input type="submit" value="编辑新闻">
        </fieldset>
    </form>
</div>

<!-- 删除新闻表单 -->
<div class="form-container">
    <form action="AdminServlet?action=deleteNews" method="post">
        <fieldset>
            <legend>删除新闻</legend>
            <label for="deleteNewsId">新闻ID:</label>
            <input type="number" id="deleteNewsId" name="newsId" required><br>
            <input type="submit" value="删除新闻">
        </fieldset>
    </form>
</div>

<!-- 添加新闻分类表单 -->
<div class="form-container">
    <form action="AdminServlet?action=addCategory" method="post">
        <fieldset>
            <legend>添加新闻分类</legend>
            <label for="addCategoryName">新闻分类名称:</label>
            <input type="text" id="addCategoryName" name="categoryName" required><br>
            <input type="submit" value="添加新闻分类">
        </fieldset>
    </form>
</div>

<!-- 编辑新闻分类表单 -->
<div class="form-container">
    <form action="AdminServlet?action=editCategory" method="post">
        <fieldset>
            <legend>编辑新闻分类</legend>
            <label for="editCategoryId">新闻分类ID:</label>
            <input type="number" id="editCategoryId" name="categoryId" required><br>
            <label for="editCategoryName">新闻分类名称:</label>
            <input type="text" id="editCategoryName" name="categoryName" required><br>
            <input type="submit" value="编辑新闻分类">
        </fieldset>
    </form>
</div>

<!-- 删除新闻分类表单 -->
<div class="form-container">
    <form action="AdminServlet?action=deleteCategory" method="post">
        <fieldset>
            <legend>删除新闻分类</legend>
            <label for="deleteCategoryId">新闻分类ID:</label>
            <input type="number" id="deleteCategoryId" name="categoryId" required><br>
            <input type="submit" value="删除新闻分类">
        </fieldset>
    </form>
</div>

</body>
</html>
