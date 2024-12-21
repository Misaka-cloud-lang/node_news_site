package com.example.news_site.dao;

import com.example.news_site.model.News;
import com.example.news_site.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.net.URLEncoder;

public class NewsDAO {

    private DBConnection dbConnection;

    public NewsDAO() {
        this.dbConnection = new DBConnection();
    }

    // 添加新闻
    public void addNews(News news) throws SQLException {
        String sql = "INSERT INTO news (title, description, category, image, author, source, " +
                     "tags, summary, content_html, related_images, is_top, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, news.getTitle());
            pstmt.setString(2, news.getDescription());
            pstmt.setString(3, news.getCategory());
            pstmt.setString(4, news.getImage());
            pstmt.setString(5, news.getAuthor());
            pstmt.setString(6, news.getSource());
            pstmt.setString(7, news.getTags());
            pstmt.setString(8, news.getSummary());
            pstmt.setString(9, news.getContentHtml());
            pstmt.setString(10, news.getRelatedImages());
            pstmt.setBoolean(11, news.isTop());
            pstmt.setString(12, news.getStatus());
            
            pstmt.executeUpdate();
        }
    }

    // 获取所有新闻
    public List<News> getAllNews() throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY is_top DESC, publish_time DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                News news = new News();
                news.setId(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setDescription(rs.getString("description"));
                news.setCategory(rs.getString("category"));
                news.setImage(rs.getString("image"));
                news.setAuthor(rs.getString("author"));
                news.setSource(rs.getString("source"));
                news.setPublishTime(rs.getTimestamp("publish_time"));
                news.setUpdateTime(rs.getTimestamp("update_time"));
                news.setViews(rs.getInt("views"));
                news.setLikes(rs.getInt("likes"));
                news.setTags(rs.getString("tags"));
                news.setSummary(rs.getString("summary"));
                news.setContentHtml(rs.getString("content_html"));
                news.setRelatedImages(rs.getString("related_images"));
                news.setTop(rs.getBoolean("is_top"));
                news.setStatus(rs.getString("status"));
                newsList.add(news);
            }
        }
        return newsList;
    }

    // 根据ID获取新闻
    public News getNewsById(int id) throws SQLException {
        String sql = "SELECT * FROM news WHERE id = ?";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                News news = new News();
                news.setId(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setDescription(rs.getString("description"));
                news.setCategory(rs.getString("category"));
                news.setImage(rs.getString("image"));
                news.setAuthor(rs.getString("author"));
                news.setSource(rs.getString("source"));
                news.setPublishTime(rs.getTimestamp("publish_time"));
                news.setUpdateTime(rs.getTimestamp("update_time"));
                news.setViews(rs.getInt("views"));
                news.setLikes(rs.getInt("likes"));
                news.setTags(rs.getString("tags"));
                news.setSummary(rs.getString("summary"));
                news.setContentHtml(rs.getString("content_html"));
                news.setRelatedImages(rs.getString("related_images"));
                news.setTop(rs.getBoolean("is_top"));
                news.setStatus(rs.getString("status"));
                return news;
            }
        }
        return null;
    }

    // 根据新闻分类返回不同的颜色
    private String getCategoryColor(String category) {
        switch (category) {
            case "国内": return "FF4D4F";
            case "国际": return "2681FF";
            case "经济": return "52C41A";
            case "科技": return "722ED1";
            case "娱乐": return "F759AB";
            case "体育": return "FA8C16";
            case "教育": return "13C2C2";
            case "健康": return "EB2F96";
            case "文化": return "1890FF";
            case "军事": return "FA541C";
            default: return "666666";
        }
    }

    // 更新新闻
    public void updateNews(News news) throws SQLException {
        String sql = "UPDATE news SET title = ?, description = ?, category = ?, " +
                     "image = ?, author = ?, source = ?, tags = ?, summary = ?, " +
                     "content_html = ?, related_images = ?, is_top = ?, status = ?, " +
                     "update_time = CURRENT_TIMESTAMP WHERE id = ?";
                     
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getDescription());
            ps.setString(3, news.getCategory());
            ps.setString(4, news.getImage());
            ps.setString(5, news.getAuthor());
            ps.setString(6, news.getSource());
            ps.setString(7, news.getTags());
            ps.setString(8, news.getSummary());
            ps.setString(9, news.getContentHtml());
            ps.setString(10, news.getRelatedImages());
            ps.setBoolean(11, news.isTop());
            ps.setString(12, news.getStatus());
            ps.setInt(13, news.getId());

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

    // 搜索新闻
    public List<News> searchNews(String keyword) throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE status = 'published' AND " +
                     "(title LIKE ? OR description LIKE ? OR content_html LIKE ? OR tags LIKE ?) " +
                     "ORDER BY is_top DESC, publish_time DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News news = new News();
                    news.setId(rs.getInt("id"));
                    news.setTitle(rs.getString("title"));
                    news.setDescription(rs.getString("description"));
                    news.setCategory(rs.getString("category"));
                    news.setImage(rs.getString("image"));
                    news.setAuthor(rs.getString("author"));
                    news.setSource(rs.getString("source"));
                    news.setPublishTime(rs.getTimestamp("publish_time"));
                    news.setUpdateTime(rs.getTimestamp("update_time"));
                    news.setViews(rs.getInt("views"));
                    news.setLikes(rs.getInt("likes"));
                    news.setTags(rs.getString("tags"));
                    news.setSummary(rs.getString("summary"));
                    news.setContentHtml(rs.getString("content_html"));
                    news.setRelatedImages(rs.getString("related_images"));
                    news.setTop(rs.getBoolean("is_top"));
                    news.setStatus(rs.getString("status"));
                    newsList.add(news);
                }
            }
        }
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

    // 删除没有图片或使用默认图片���新闻
    public void deleteNewsWithoutImages() throws SQLException {
        String sql = "DELETE FROM news WHERE image = '/images/default.jpg'";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int deletedCount = ps.executeUpdate();
            System.out.println("成功删除 " + deletedCount + " 条默认图片的新闻");
        }
    }

    // 查询使用默认图片的新闻
    public List<News> getNewsWithDefaultImages() throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE image IS NULL OR image = '' OR image = '../images/default.jpg'";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
        
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
        System.out.println("找到 " + newsList.size() + " 条使用默认图片的新闻");
        return newsList;
    }

    // 可以先用这个方法查看有哪些图片路径
    public void printAllImagePaths() throws SQLException {
        String sql = "SELECT DISTINCT image FROM news ORDER BY image";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
        
            System.out.println("所有图片路径：");
            while (rs.next()) {
                String imagePath = rs.getString("image");
                System.out.println(imagePath);
            }
        }
    }

    // 更新浏览量
    public void incrementViews(int newsId) throws SQLException {
        String sql = "UPDATE news SET views = views + 1 WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newsId);
            ps.executeUpdate();
        }
    }

    // 更新点赞数
    public void incrementLikes(int newsId) throws SQLException {
        String sql = "UPDATE news SET likes = likes + 1 WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newsId);
            ps.executeUpdate();
        }
    }

    // 获取热门新闻
    public List<News> getHotNews() throws SQLException {
        String sql = "SELECT * FROM news WHERE status = 'published' " +
                     "ORDER BY views DESC, likes DESC LIMIT 10";
        List<News> newsList = new ArrayList<>();
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                News news = new News();
                news.setId(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setDescription(rs.getString("description"));
                news.setCategory(rs.getString("category"));
                news.setImage(rs.getString("image"));
                news.setAuthor(rs.getString("author"));
                news.setSource(rs.getString("source"));
                news.setPublishTime(rs.getTimestamp("publish_time"));
                news.setUpdateTime(rs.getTimestamp("update_time"));
                news.setViews(rs.getInt("views"));
                news.setLikes(rs.getInt("likes"));
                news.setTags(rs.getString("tags"));
                news.setSummary(rs.getString("summary"));
                news.setContentHtml(rs.getString("content_html"));
                news.setRelatedImages(rs.getString("related_images"));
                news.setTop(rs.getBoolean("is_top"));
                news.setStatus(rs.getString("status"));
                newsList.add(news);
            }
        }
        return newsList;
    }
}
