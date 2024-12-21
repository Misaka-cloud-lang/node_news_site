package com.example.news_site.dao;

import com.example.news_site.model.News;
import com.example.news_site.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsDAO {

    private DBConnection dbConnection;

    public NewsDAO() {
        this.dbConnection = new DBConnection();
    }

    // 添加新闻
    public void addNews(News news) throws SQLException {
        String sql = "INSERT INTO news (title, description, category, image) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, news.getTitle());
            pstmt.setString(2, news.getDescription());
            pstmt.setString(3, news.getCategory());
            pstmt.setString(4, news.getImage());
            
            // 添加日志
            System.out.println("正在保存新闻: " + news.getTitle());
            System.out.println("分类: " + news.getCategory());
            
            int result = pstmt.executeUpdate();
            System.out.println("保存结果: " + (result > 0 ? "成功" : "失败"));
        }
    }

    // 获取所有新闻
    public List<News> getAllNews() throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                News news = new News(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),  // 更新为 description
                        rs.getString("category"),     // 更新为 category
                        rs.getString("image")        // 更新为 image
                );
                newsList.add(news);
            }
        }
        return newsList;
    }

    // 根据ID获取新闻
    public News getNewsById(int id) throws SQLException {
        String sql = "SELECT * FROM news WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new News(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("category"),
                        rs.getString("image")
                    );
                }
            }
        }
        return null;
    }


    // 更新新闻
    public void updateNews(News news) throws SQLException {
        String sql = "UPDATE news SET title = ?, description = ?, category = ?, image = ? WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, news.getTitle());
            ps.setString(2, news.getDescription());  // 更新为 description
            ps.setString(3, news.getCategory());    // 更新为 category
            ps.setString(4, news.getImage());       // 更新为 image
            ps.setInt(5, news.getId());

            ps.executeUpdate();
        }
    }

    // 删除新闻
    public void deleteNews(int id) throws SQLException {
        String sql = "DELETE FROM news WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // 搜索新闻 (根据关键字搜索标题或内容)
    public List<News> searchNews(String keyword) throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE title LIKE ? OR description LIKE ? ORDER BY id DESC";

        System.out.println("执行搜索SQL: " + sql);
        System.out.println("搜索关键词: " + keyword);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            System.out.println("实际搜索模式: " + searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News news = new News(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("category"),
                        rs.getString("image")
                    );
                    newsList.add(news);
                    System.out.println("找到匹配新闻: " + news.getTitle());
                }
            }
        }
        
        System.out.println("搜索完成，共找到 " + newsList.size() + " 条结果");
        return newsList;
    }

    // 根据分类ID获取新闻
    /*
    public List<News> getNewsByCategory(int categoryId) throws SQLException {
        // ... 删除这个方法
    }
    */

    // 根据分类获取新闻
    public List<News> getNewsByCategory(String category) throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE category = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News news = new News(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("category"),
                        rs.getString("image")
                    );
                    newsList.add(news);
                }
            }
        }
        return newsList;
    }

    // 获取分类新闻总数
    public int getNewsTotalByCategory(String category) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM news WHERE category = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    public void deleteAllNews() throws SQLException {
        String sql = "DELETE FROM news";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
            System.out.println("数据库新闻已清空");
        }
    }

    public void deleteHalfNews() throws SQLException {
        // 先获取总数
        String countSql = "SELECT COUNT(*) as total FROM news";
        int totalCount = 0;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(countSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalCount = rs.getInt("total");
            }
        }
        
        if (totalCount > 0) {
            // 删除较旧的一半新闻（ID较小的）
            String deleteSql = "DELETE FROM news WHERE id IN (SELECT id FROM news ORDER BY id ASC LIMIT ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                int halfCount = totalCount / 2;
                ps.setInt(1, halfCount);
                int deletedCount = ps.executeUpdate();
                System.out.println("已删除 " + deletedCount + " 条较旧新闻，剩余 " + (totalCount - deletedCount) + " 条");
            }
        }
    }
}
