package com.example.news_site.controller;

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

public class NewsServlet extends HttpServlet {
    private NewsDAO newsDao;
    private AdService adService;

    @Override
    public void init() throws ServletException {
        try {
            // 初始化 DAO 和服务对象
            newsDao = new NewsDAO();
            adService = new AdService();  // 广告服务
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

        String newsId = request.getParameter("id");  // 获取新闻ID
        String categoryParam = request.getParameter("category");  // 获取分类
        String queryKeyword = request.getParameter("query");  // 获取搜索关键词

        if (newsId != null) {
            // 处理新闻详情页面
            try {
                // 打印调试信息：接收到的新闻ID
                System.out.println("Received request for news details with ID: " + newsId);

                // 获取新闻详情
                News news = newsDao.getNewsById(Integer.parseInt(newsId));
                if (news != null) {
                    request.setAttribute("news", news);  // 将新闻对象传递给JSP页面
                    System.out.println("News found with ID: " + newsId);  // 调试日志
                    // 转发到新闻详情页面
                    request.getRequestDispatcher("/pages/newsDetail.jsp").forward(request, response);
                } else {
                    System.out.println("News not found for ID: " + newsId);  // 错误日志
                    request.setAttribute("error", "新闻未找到！");
                    request.getRequestDispatcher("/pages/error.jsp").forward(request, response);  // 转发到错误页面
                }
            } catch (SQLException e) {
                System.err.println("Database error while fetching news by ID: " + e.getMessage());
                request.setAttribute("error", "数据库连接失败，请稍后重试！");
                e.printStackTrace();
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("Unexpected error while fetching news details: " + e.getMessage());
                request.setAttribute("error", "新闻详情加载失败，请稍后重试！");
                e.printStackTrace();
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            }
        } else {
            // 处理新闻列表页面
            System.out.println("=== Processing GET Request for News List ===");
            try {
                List<News> newsList = null;

                // 如果有搜索关键词，执行搜索功能
                if (queryKeyword != null && !queryKeyword.isEmpty()) {
                    System.out.println("Searching news by keyword: " + queryKeyword);
                    newsList = newsDao.searchNews(queryKeyword);  // 搜索新闻
                } else if (categoryParam != null && !categoryParam.isEmpty()) {
                    // 按分类获取新闻
                    System.out.println("Fetching news by category: " + categoryParam);
                    newsList = newsDao.getNewsByCategoryName(categoryParam);  // 获取指定分类的新闻
                } else {
                    // 如果没有指定分类或关键词，默认获取所有新闻
                    System.out.println("No category or keyword provided, fetching all news.");
                    newsList = newsDao.getAllNews();  // 获取所有新闻
                }

                // 打印新闻列表的结果
                if (newsList != null && !newsList.isEmpty()) {
                    System.out.println("Fetched news count: " + newsList.size());
                } else {
                    System.out.println("No news found for the given parameters.");
                }

                // 获取广告列表并随机选一个广告
                List<Ad> ads = adService.getAds();  // 获取所有广告
                Ad randomAd = adService.getRandomAd(ads);  // 获取随机广告

                if (randomAd != null) {
                    System.out.println("Random Ad selected: " + randomAd.getContent());
                } else {
                    System.out.println("No ads available.");
                }

                // 设置新闻列表和广告作为请求属性
                request.setAttribute("newsList", newsList);
                request.setAttribute("randomAd", randomAd);

                // 转发到新闻列表展示页面
                System.out.println("Forwarding to newsList.jsp.");
                request.getRequestDispatcher("/pages/newsList.jsp").forward(request, response);

            } catch (SQLException e) {
                // 数据库相关错误处理
                System.err.println("Database error while fetching news list: " + e.getMessage());
                request.setAttribute("error", "数据库连接失败，请稍后重试！");
                e.printStackTrace();
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            } catch (Exception e) {
                // 其他错误处理
                System.err.println("Unexpected error: " + e.getMessage());
                request.setAttribute("error", "新闻加载失败，请稍后重试！");
                e.printStackTrace();
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            }
        }
    }
}
