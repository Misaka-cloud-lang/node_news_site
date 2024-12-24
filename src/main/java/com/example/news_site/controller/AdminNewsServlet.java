package com.example.news_site.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.news_site.service.NewsService;
import com.example.news_site.model.News;
import java.io.IOException;
import java.util.Date;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet("/pages/admin")
public class AdminNewsServlet extends HttpServlet {
    private NewsService newsService;

    @Override
    public void init() throws ServletException {
        newsService = new NewsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查是否已登录
        HttpSession session = request.getSession();
        Boolean isLoggedIn = (Boolean) session.getAttribute("adminLoggedIn");
        
        if (isLoggedIn == null || !isLoggedIn) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }
        
        String newsId = request.getParameter("id");
        String query = request.getParameter("query");
        
        if (newsId != null) {
            // 获取单条新闻的详细信息（用于编辑）
            News news = newsService.getNewsById(Integer.parseInt(newsId));
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(convertToJson(news));
        } else if (query != null && !query.trim().isEmpty()) {
            // 处理搜索请求
            List<News> searchResults = newsService.searchNews(query);
            request.setAttribute("newsList", searchResults);
            request.setAttribute("searchQuery", query);
            request.getRequestDispatcher("/pages/admin.jsp").forward(request, response);
        } else {
            // 显示所有新闻
            List<News> allNews = newsService.getAllNews();
            request.setAttribute("newsList", allNews);
            request.getRequestDispatcher("/pages/admin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查是否已登录
        HttpSession session = request.getSession();
        Boolean isLoggedIn = (Boolean) session.getAttribute("adminLoggedIn");
        
        if (isLoggedIn == null || !isLoggedIn) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        System.out.println("Received POST request with action: " + action);
        
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                System.out.println("Deleting news with ID: " + id);
                boolean success = newsService.deleteNews(id);
                System.out.println("Delete result: " + success);
                response.setStatus(success ? 200 : 500);
                if (!success) {
                    response.getWriter().write("删除失败");
                }
            } else if ("update".equals(action)) {
                // 更新新闻
                News news = new News();
                news.setId(Integer.parseInt(request.getParameter("id")));
                news.setTitle(request.getParameter("title"));
                news.setCategory(request.getParameter("category"));
                news.setAuthor(request.getParameter("author"));
                news.setSource(request.getParameter("source"));
                news.setImage(request.getParameter("image"));
                news.setContentHtml(request.getParameter("contentHtml"));
                news.setUpdateTime(new Date());
                
                System.out.println("Updating news with ID: " + request.getParameter("id"));
                
                boolean success = newsService.updateNews(news);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/pages/admin");
                } else {
                    response.sendError(500, "更新失败");
                }
            } else if ("add".equals(action)) {
                // 添加新闻
                News news = new News();
                news.setTitle(request.getParameter("title"));
                news.setDescription(request.getParameter("description"));
                news.setCategory(request.getParameter("category"));
                news.setAuthor(request.getParameter("author"));
                news.setSource(request.getParameter("source"));
                news.setImage(request.getParameter("image"));
                news.setContentHtml(request.getParameter("contentHtml"));
                news.setPublishTime(new Date());
                news.setUpdateTime(new Date());
                news.setViews(0);
                news.setLikes(0);
                news.setStatus("published");
                news.setTop(false);
                
                System.out.println("Adding new news with title: " + news.getTitle());
                System.out.println("Description: " + news.getDescription());
                System.out.println("Category: " + news.getCategory());
                System.out.println("Content length: " + (news.getContentHtml() != null ? news.getContentHtml().length() : 0));
                
                boolean success = newsService.addNews(news);
                System.out.println("Add news result: " + success);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/pages/admin");
                } else {
                    response.sendError(500, "添加失败");
                }
            }
        } catch (Exception e) {
            System.err.println("Error in AdminNewsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(500, "操作失败：" + e.getMessage());
        }
    }

    private String convertToJson(News news) {
        // 简单的JSON转换，实际项目中建议使用JSON库
        return String.format(
            "{\"id\":%d,\"title\":\"%s\",\"category\":\"%s\",\"author\":\"%s\",\"source\":\"%s\",\"image\":\"%s\",\"contentHtml\":\"%s\"}",
            news.getId(), news.getTitle(), news.getCategory(), news.getAuthor(), news.getSource(), news.getImage(),
            news.getContentHtml().replace("\"", "\\\"").replace("\n", "\\n")
        );
    }
} 