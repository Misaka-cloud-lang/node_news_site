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
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Debug log to check the fetched data
                    System.out.println("Found news: " + rs.getString("title"));
                    return new News(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getString("category"),
                            rs.getString("image")
                    );
                } else {
                    // Debug log if no news found
                    System.out.println("No news found for ID: " + id);
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
        String sql = "SELECT * FROM news WHERE title LIKE ? OR description LIKE ?";  // 更新为 description

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
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
        }
        return newsList;
    }

    // 根据分类ID获取新闻
    public List<News> getNewsByCategory(int categoryId) throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE category = ?";  // 更新为 category

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, String.valueOf(categoryId));  // 假设 category 是字符串类型

            try (ResultSet rs = ps.executeQuery()) {
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
        }
        return newsList;
    }

    public List<News> getNewsByCategoryName(String categoryParam) throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = """
    
                SELECT n.id, n.title, n.description, n.category, n.image
    FROM news n
    JOIN category c ON n.category = c.name
    WHERE c.name = ?
    """;

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, categoryParam);

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

        // 调试输出
        System.out.println("Executing SQL: " + sql);
        System.out.println("Category parameter: " + categoryParam);
        System.out.println("News count fetched: " + newsList.size());

        return newsList;
    }
}
