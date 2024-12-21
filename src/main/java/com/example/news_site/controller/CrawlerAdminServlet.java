package com.example.news_site.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.news_site.service.NewsService;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/crawler")
public class CrawlerAdminServlet extends HttpServlet {
    private NewsService newsService;

    @Override
    public void init() throws ServletException {
        newsService = new NewsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取爬虫状态信息
        Map<String, Integer> categoryCount = newsService.getNewsCategoryCount();
        request.setAttribute("categoryCount", categoryCount);
        request.setAttribute("lastCrawlTime", newsService.getLastCrawlTime());
        request.setAttribute("totalNews", newsService.getTotalNewsCount());
        
        request.getRequestDispatcher("/admin/crawler.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String[] categories = request.getParameterValues("categories");
        
        try {
            if (categories != null) {
                if (Arrays.asList(categories).contains("all")) {
                    // 爬取所有分类
                    newsService.testCrawlNews();
                } else {
                    // 爬取选定分类
                    newsService.crawlSelectedCategories(Arrays.asList(categories));
                }
                response.sendRedirect(request.getContextPath() + "/admin/crawler?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/crawler?error=请选择要爬取的分类");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/crawler?error=" + e.getMessage());
        }
    }
} 