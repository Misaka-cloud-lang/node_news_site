package com.example.news_site.dao;

import com.example.news_site.model.Advertisement;
import com.example.news_site.util.DBConnection;
import java.sql.*;
import java.util.*;

public class AdDAO {
    private Connection conn;
    
    public AdDAO() throws SQLException {
        this.conn = DBConnection.getConnection();
    }
    
    // 根据广告类型获取广告列表
    public List<Advertisement> getAdsByType(String type) throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        String sql = "SELECT * FROM advertisements WHERE type = ? AND active = true";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Advertisement ad = new Advertisement();
                ad.setId(rs.getLong("id"));
                ad.setType(rs.getString("type"));
                ad.setContent(rs.getString("content"));
                ad.setImageUrl(rs.getString("image_url"));
                ad.setLinkUrl(rs.getString("link_url"));
                ad.setPosition(rs.getString("position"));
                ad.setActive(rs.getBoolean("active"));
                ads.add(ad);
            }
        }
        return ads;
    }
    
    public Advertisement getRandomAd(String position) throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        String sql = "SELECT * FROM advertisements WHERE position = ? AND active = true";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, position);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Advertisement ad = new Advertisement();
                ad.setId(rs.getLong("id"));
                ad.setType(rs.getString("type"));
                ad.setContent(rs.getString("content"));
                ad.setImageUrl(rs.getString("image_url"));
                ad.setLinkUrl(rs.getString("link_url"));
                ad.setPosition(rs.getString("position"));
                ad.setActive(rs.getBoolean("active"));
                ads.add(ad);
            }
            
            if (!ads.isEmpty()) {
                int randomIndex = new Random().nextInt(ads.size());
                return ads.get(randomIndex);
            }
        }
        return null;
    }

    public void closeConnection() {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
