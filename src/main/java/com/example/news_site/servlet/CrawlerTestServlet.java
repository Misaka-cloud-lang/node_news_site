package com.example.news_site.servlet;

import com.example.news_site.util.NewsCrawler;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/crawl-now")
public class CrawlerTestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        try {
            NewsCrawler.fetchNews();
            response.getWriter().write("新闻抓取完成！请返回首页查看。");
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.getWriter().write("抓取失败：" + e.getMessage());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
} 