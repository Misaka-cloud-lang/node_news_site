package com.example.news_site.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.example.news_site.dao.NewsDAO;
import com.example.news_site.model.News;
import com.example.news_site.model.Ad;
import com.example.news_site.service.AdService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


@WebServlet(name = "NewsServlet", urlPatterns = "/news")
public class NewsServlet extends HttpServlet {
    private NewsDAO newsDao;
    private AdService adService;

    @Override
    public void init() throws ServletException {
        try {
            newsDao = new NewsDAO();
            adService = new AdService();
            System.out.println("Servlet initialized successfully.");
        } catch (Exception e) {
            System.err.println("Error during servlet initialization: " + e.getMessage());
            throw new ServletException("Database connection failed!", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String newsId = request.getParameter("id");
        String categoryParam = request.getParameter("category");
        String queryKeyword = request.getParameter("query");

        System.out.println("=== Processing GET Request ===");
        System.out.println("newsId: " + newsId);
        System.out.println("category: " + categoryParam);
        System.out.println("query: " + queryKeyword);

        try {
            List<News> newsList = null;

            // 如果有搜索关键词，执行搜索功能
            if (queryKeyword != null && !queryKeyword.isEmpty()) {
                System.out.println("开始搜索，关键词: " + queryKeyword);
                newsList = newsDao.searchNews(queryKeyword);
                
                // 打印搜索结果
                System.out.println("搜索完成，找到 " + (newsList != null ? newsList.size() : 0) + " 条结果");
                if (newsList != null && !newsList.isEmpty()) {
                    System.out.println("第一条结果: " + newsList.get(0).getTitle());
                }
                
                request.setAttribute("query", queryKeyword);
                request.setAttribute("newsList", newsList);
                
                System.out.println("准备转发到搜索结果页面...");
                request.getRequestDispatcher("/pages/searchResults.jsp").forward(request, response);
                System.out.println("转发完成");
                return;
            }

            // 如果有新闻ID，显示新闻详情
            if (newsId != null) {
                News news = newsDao.getNewsById(Integer.parseInt(newsId));
                if (news != null) {
                    request.setAttribute("news", news);
                    request.getRequestDispatcher("/pages/newsDetail.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "新闻未找到！");
                    request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                }
                return;
            }

            // 如果有分类参数，获取分类新闻
            if (categoryParam != null && !categoryParam.isEmpty()) {
                newsList = newsDao.getNewsByCategory(categoryParam);
            } else {
                newsList = newsDao.getAllNews();
            }

            // 获取广告
            List<Ad> ads = adService.getAds();
            Ad randomAd = adService.getRandomAd(ads);

            // 设置请求属性
            request.setAttribute("newsList", newsList);
            request.setAttribute("randomAd", randomAd);

            // 转发到新闻列表页面
            request.getRequestDispatcher("/pages/newsList.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("发生错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "服务器错误：" + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
}