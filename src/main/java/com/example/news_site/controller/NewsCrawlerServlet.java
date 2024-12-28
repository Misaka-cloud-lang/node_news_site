package com.example.news_site.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.news_site.util.NewsCrawler;
import com.example.news_site.service.NewsService;
import com.example.news_site.dao.NewsDAO;
import com.example.news_site.model.News;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/crawl")
public class NewsCrawlerServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // 创建必要的对象
            NewsDAO newsDAO = new NewsDAO();
            NewsCrawler crawler = new NewsCrawler(newsDAO);
            NewsService newsService = new NewsService();
            
            // 爬取新闻
            List<News> newsList = crawler.crawlAllNews();
            
            // 保存新闻
            if (newsList != null && !newsList.isEmpty()) {
                newsService.insertNewsList(newsList);
                request.setAttribute("message", "爬取成功：获取 " + newsList.size() + " 条新闻");
            } else {
                request.setAttribute("message", "未获取到新闻");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "爬取失败：" + e.getMessage());
            e.printStackTrace();
        }
        
        // 重定向回管理页面
        response.sendRedirect(request.getContextPath() + "/pages/admin.jsp");
    }
} 