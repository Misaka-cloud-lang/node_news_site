package com.example.news_site.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.news_site.util.NewsCrawler;
import java.io.IOException;

@WebServlet("/crawl-now")
public class NewsCrawlerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 检查管理员权限
        if (request.getSession().getAttribute("isAdmin") == null || 
            !(Boolean)request.getSession().getAttribute("isAdmin")) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.setContentType("text/html;charset=UTF-8");
        try {
            NewsCrawler.fetchNews();
            response.getWriter().write("新闻数据更新完成！");
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.getWriter().write("更新失败：" + e.getMessage());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
} 