package com.example.news_site.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.news_site.service.NewsService;
import com.example.news_site.model.News;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/test-crawler")
public class TestCrawlerServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            NewsService newsService = new NewsService();
            
            // 先打印当前新闻数量
            Map<String, Integer> beforeCounts = newsService.getNewsCategoryCount();
            System.out.println("爬取前各分类新闻数量：");
            beforeCounts.forEach((category, count) -> 
                System.out.println(category + ": " + count + "条"));
            
            // 删除非HTTP图片的新闻
            newsService.getNewsDAO().printAllImagePaths();
            List<News> defaultImageNews = newsService.getNewsDAO().getNewsWithDefaultImages();
            System.out.println("将要删除的新闻数量: " + defaultImageNews.size());
            newsService.getNewsDAO().deleteNewsWithoutImages();
            
            // 爬取新闻（不删除原有新闻）
            newsService.testCrawlNews();
            
            // 打印爬取后的新闻数量
            Map<String, Integer> afterCounts = newsService.getNewsCategoryCount();
            System.out.println("\n爬取后各分类新闻数量：");
            afterCounts.forEach((category, count) -> 
                System.out.println(category + ": " + count + "条"));
            
            response.getWriter().write("新闻爬取测试已完成，请查看控制台输出！");
        } catch (Exception e) {
            response.getWriter().write("爬取测试失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
} 