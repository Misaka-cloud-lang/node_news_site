package com.example.news_site.dao;

import com.example.news_site.model.News;
import com.example.news_site.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.net.URLEncoder;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class NewsDAO {

    private DBConnection dbConnection;

    public NewsDAO() {
        this.dbConnection = new DBConnection();
    }

    // 添加新闻
    public boolean addNews(News news) {
        String sql = "INSERT INTO news (title, description, category, image, author, source, " +
                     "tags, summary, content_html, related_images, is_top, status, publish_time) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            System.out.println("Preparing to insert news into database...");
            
            stmt.setString(1, news.getTitle());
            stmt.setString(2, news.getDescription());
            stmt.setString(3, news.getCategory());
            stmt.setString(4, news.getImage());
            stmt.setString(5, news.getAuthor());
            stmt.setString(6, news.getSource());
            stmt.setString(7, news.getTags());
            stmt.setString(8, news.getSummary());
            stmt.setString(9, news.getContentHtml());
            stmt.setString(10, news.getRelatedImages());
            stmt.setBoolean(11, news.isTop());
            stmt.setString(12, news.getStatus());
            
            // 处理时间戳转换
            java.util.Date publishDate = news.getPublishTime();
            if (publishDate != null) {
                stmt.setTimestamp(13, new java.sql.Timestamp(publishDate.getTime()));
            } else {
                stmt.setTimestamp(13, new java.sql.Timestamp(System.currentTimeMillis()));
            }
            
            System.out.println("Executing SQL insert...");
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Insert result: " + rowsAffected + " rows affected");
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding news: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }

    // 获取所有新闻
    public List<News> getAllNews() {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY is_top DESC, publish_time DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newsList;
    }

    // 根据ID获取新闻
    public News getNewsById(int id) {
        News news = null;
        String sql = "SELECT * FROM news WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                news = new News();
                news.setId(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setDescription(rs.getString("description"));
                news.setContent(rs.getString("content_html"));
                news.setImage(rs.getString("image"));
                news.setCategory(rs.getString("category"));
                news.setAuthor(rs.getString("author"));
                news.setSource(rs.getString("source"));
                news.setPublishTime(rs.getTimestamp("publish_time"));
                news.setViews(rs.getInt("views"));
                news.setLikes(rs.getInt("likes"));
                
                // 更新浏览量
                updateViews(id);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting news by ID: " + id);
            System.err.println("SQL Error: " + e.getMessage());
        }
        
        return news;
    }

    // 更新浏览量的方法
    private void updateViews(int id) {
        String sql = "UPDATE news SET views = views + 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 根据新闻分类返回同的颜色
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
    public boolean updateNews(News news) {
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

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除新闻
    public boolean deleteNews(int id) {
        String sql = "DELETE FROM news WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 搜索新闻
    public List<News> searchNews(String keyword) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE title LIKE ? OR content_html LIKE ? " +
                    "ORDER BY is_top DESC, publish_time DESC";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                newsList.add(mapResultSetToNews(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
        String sql = "SELECT * FROM news WHERE category = ? ORDER BY is_top DESC, publish_time DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            
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

    // 获取分类新闻总数
    public int getNewsTotalByCategory(String category) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM news WHERE category = ?";
        
        try (Connection conn = dbConnection.getConnection();
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
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
            System.out.println("数据库新闻已清空");
        }
    }

    public void deleteHalfNews() throws SQLException {
        // 先获取总数
        String countSql = "SELECT COUNT(*) as total FROM news";
        int totalCount = 0;
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(countSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalCount = rs.getInt("total");
            }
        }
        
        if (totalCount > 0) {
            // 删除较旧的一半新闻（ID较小的）
            String deleteSql = "DELETE FROM news WHERE id IN (SELECT id FROM news ORDER BY id ASC LIMIT ?)";
            try (Connection conn = dbConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                int halfCount = totalCount / 2;
                ps.setInt(1, halfCount);
                int deletedCount = ps.executeUpdate();
                System.out.println("已删除 " + deletedCount + " 条较旧新闻，剩余 " + (totalCount - deletedCount) + " 条");
            }
        }
    }

    // 删除没有图片或使用默认图片的新闻
    public void deleteNewsWithoutImages() throws SQLException {
        String sql = "DELETE FROM news WHERE " +
                     "image IS NULL OR " +                    // 空值
                     "image = '' OR " +                       // 空字符串
                     "image = 'null' OR " +                   // 字符串'null'
                     "(image NOT LIKE 'http://%' AND " +      // 不是以http://开头
                     "image NOT LIKE 'https://%')";           // 不是以https://开头
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int deletedCount = ps.executeUpdate();
            System.out.println("成功删除 " + deletedCount + " 条非HTTP图片的新闻");
        }
    }

    // 查询将删除的新闻（用于预览）
    public List<News> getNewsWithDefaultImages() throws SQLException {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE " +
                     "image IS NULL OR " +
                     "image = '' OR " +
                     "image = 'null' OR " +
                     "(image NOT LIKE 'http://%' AND " +
                     "image NOT LIKE 'https://%')";
        
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
        System.out.println("找到 " + newsList.size() + " 条非HTTP图片的新闻");
        return newsList;
    }

    // 打印所有图片路径（用于检查）
    public void printAllImagePaths() throws SQLException {
        String sql = "SELECT id, title, image FROM news ORDER BY id";
        
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
        
            System.out.println("\n所有新闻图片路径：");
            System.out.println("ID\t图片路径\t标题");
            System.out.println("----------------------------------------");
            while (rs.next()) {
                System.out.println(
                    rs.getInt("id") + "\t" +
                    rs.getString("image") + "\t" +
                    rs.getString("title")
                );
            }
            System.out.println("----------------------------------------\n");
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

    public void deleteExcessNewsByCategory(String category, int keepCount) throws SQLException {
        String sql = "DELETE n1 FROM news n1 " +
                     "LEFT JOIN (SELECT id FROM news WHERE category = ? " +
                     "ORDER BY publish_time DESC LIMIT ?) n2 " +
                     "ON n1.id = n2.id " +
                     "WHERE n1.category = ? AND n2.id IS NULL";
                     
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ps.setInt(2, keepCount);
            ps.setString(3, category);
            ps.executeUpdate();
        }
    }

    public void truncateNewsTable() throws SQLException {
        String sql = "TRUNCATE TABLE news";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
            System.out.println("新闻表已清空");
        }
    }

    // 添加批量插入���法
    public int batchAddNews(List<News> newsList) throws SQLException {
        if (newsList == null || newsList.isEmpty()) {
            return 0;
        }

        System.out.println("准备插入 " + newsList.size() + " 条新闻");
        
        // 获取所有新闻标题
        List<String> titles = new ArrayList<>();
        for (News news : newsList) {
            titles.add(news.getTitle());
        }
        
        // 构建 IN 查询的占位符
        String placeholders = String.join(",", Collections.nCopies(titles.size(), "?"));
        String checkSql = "SELECT title FROM news WHERE title IN (" + placeholders + ")";
        
        try (Connection conn = dbConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            // 检查已存在的新闻
            Set<String> existingTitles = new HashSet<>();
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                for (int i = 0; i < titles.size(); i++) {
                    checkStmt.setString(i + 1, titles.get(i));
                }
                ResultSet rs = checkStmt.executeQuery();
                while (rs.next()) {
                    existingTitles.add(rs.getString("title"));
                }
            }
            
            System.out.println("��据库中已存在 " + existingTitles.size() + " 条新闻");
            
            // 过滤出需要插入的新闻
            List<News> newNewsList = new ArrayList<>();
            for (News news : newsList) {
                if (!existingTitles.contains(news.getTitle())) {
                    newNewsList.add(news);
                }
            }
            
            System.out.println("实际需要插入 " + newNewsList.size() + " 条新闻");
            
            if (!newNewsList.isEmpty()) {
                String sql = "INSERT INTO news (title, description, category, image, author, " +
                            "source, publish_time, update_time, views, likes, tags, summary, " +
                            "content_html, related_images, is_top, status) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                            
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    for (News news : newNewsList) {
                        stmt.setString(1, news.getTitle());
                        stmt.setString(2, news.getDescription());
                        stmt.setString(3, news.getCategory());
                        stmt.setString(4, news.getImage());
                        stmt.setString(5, news.getAuthor());
                        stmt.setString(6, news.getSource());
                        stmt.setTimestamp(7, new java.sql.Timestamp(news.getPublishTime().getTime()));
                        stmt.setTimestamp(8, new java.sql.Timestamp(news.getUpdateTime().getTime()));
                        stmt.setInt(9, news.getViews());
                        stmt.setInt(10, news.getLikes());
                        stmt.setString(11, news.getTags());
                        stmt.setString(12, news.getSummary());
                        stmt.setString(13, news.getContentHtml());
                        stmt.setString(14, news.getRelatedImages());
                        stmt.setBoolean(15, news.isTop());
                        stmt.setString(16, news.getStatus());
                        
                        stmt.addBatch();
                    }
                    
                    int[] results = stmt.executeBatch();
                    conn.commit();
                    
                    int successCount = 0;
                    for (int result : results) {
                        if (result > 0) {
                            successCount++;
                        }
                    }
                    
                    System.out.println("成功插入 " + successCount + " 条新闻");
                    return successCount;
                }
            }
            
            return 0;
        } catch (SQLException e) {
            System.err.println("批量插入新闻失败: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // 添加 getNewsByTitles 方法
    public List<News> getNewsByTitles(List<String> titles) throws SQLException {
        List<News> newsList = new ArrayList<>();
        if (titles == null || titles.isEmpty()) {
            return newsList;
        }

        // 构建 IN 查询的占位符
        String placeholders = String.join(",", Collections.nCopies(titles.size(), "?"));
        String sql = "SELECT * FROM news WHERE title IN (" + placeholders + ")";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // 设置所有标题参数
            for (int i = 0; i < titles.size(); i++) {
                stmt.setString(i + 1, titles.get(i));
            }

            ResultSet rs = stmt.executeQuery();
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

    private News mapResultSetToNews(ResultSet rs) throws SQLException {
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