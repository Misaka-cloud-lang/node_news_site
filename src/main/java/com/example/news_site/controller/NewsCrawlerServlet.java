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

@WebServlet("/crawl-now")
public class NewsCrawlerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            NewsDAO newsDAO = new NewsDAO();
            NewsCrawler crawler = new NewsCrawler(newsDAO);
            NewsService newsService = new NewsService();
            
            List<News> newsList = crawler.crawlAllNews();
            
            if (newsList != null && !newsList.isEmpty()) {
                newsService.insertNewsList(newsList);
                out.println("<h3>爬取完成！共获取 " + newsList.size() + " 条新闻</h3>");
            } else {
                out.println("<h3>未获取到新闻</h3>");
            }
            
            out.println("<a href='javascript:history.back()'>返回上一页</a>");
            
        } catch (Exception e) {
            out.println("<h3 style='color:red'>爬取失败：" + e.getMessage() + "</h3>");
            e.printStackTrace(new PrintWriter(out));
        }
    }
} 