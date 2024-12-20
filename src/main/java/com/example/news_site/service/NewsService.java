package com.example.news_site.service;

import com.example.news_site.dao.NewsDAO;
import com.example.news_site.model.News;

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
}
