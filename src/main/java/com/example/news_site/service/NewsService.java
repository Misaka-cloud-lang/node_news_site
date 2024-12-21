package com.example.news_site.service;

import com.example.news_site.dao.NewsDAO;
import com.example.news_site.model.News;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NewsService {
    private NewsDAO newsDAO;

    public NewsService() {
        this.newsDAO = new NewsDAO();
    }

    // 添加新闻
    public boolean addNews(News news) {
        try {
            newsDAO.addNews(news);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 获取所有新闻
    public List<News> getAllNews() {
        try {
            return newsDAO.getAllNews();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 根据ID获取新闻
    public News getNewsById(int id) {
        try {
            return newsDAO.getNewsById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 更新新闻
    public boolean updateNews(News news) {
        try {
            newsDAO.updateNews(news);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除新闻
    public boolean deleteNews(int id) {
        try {
            newsDAO.deleteNews(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<News> getNewsByCategory(String category) {
        try {
            return newsDAO.getNewsByCategory(category);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public int getNewsTotalByCategory(String category) {
        try {
            return newsDAO.getNewsTotalByCategory(category);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // 添加搜索方法
    public List<News> searchNews(String keyword) {
        try {
            return newsDAO.searchNews(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void deleteAllNews() {
        try {
            newsDAO.deleteAllNews();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteHalfNews() {
        try {
            newsDAO.deleteHalfNews();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
