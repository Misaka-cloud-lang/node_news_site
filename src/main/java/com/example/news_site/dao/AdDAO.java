package com.example.news_site.dao;

import com.example.news_site.model.Ad;
import com.example.news_site.util.DBConnection;  // 假设你有一个 DBUtil 用来连接数据库

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdDAO {

    // 获取所有广告
    public List<Ad> getAllAds() {
        List<Ad> ads = new ArrayList<>();
        String sql = "SELECT * FROM ads";  // 假设广告存储在名为 `ads` 的表中

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            // 遍历查询结果并将广告存入列表
            while (rs.next()) {
                int id = rs.getInt("id");
                String type = rs.getString("type");
                String content = rs.getString("content");
                String imageUrl = rs.getString("image_url");

                Ad ad = new Ad(id, type, content, imageUrl);
                ads.add(ad);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ads;
    }

    // 根据广告类型获取广告（例如：获取 banner 广告）
    public List<Ad> getAdsByType(String type) {
        List<Ad> ads = new ArrayList<>();
        String sql = "SELECT * FROM ads WHERE type = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, type);  // 设置查询参数
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String content = rs.getString("content");
                    String imageUrl = rs.getString("image_url");

                    Ad ad = new Ad(id, type, content, imageUrl);
                    ads.add(ad);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ads;
    }

    // 获取广告详情，通过广告ID查找广告
    public Ad getAdById(int adId) {
        String sql = "SELECT * FROM ads WHERE id = ?";
        Ad ad = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, adId);  // 设置查询参数

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    String type = rs.getString("type");
                    String content = rs.getString("content");
                    String imageUrl = rs.getString("image_url");

                    ad = new Ad(id, type, content, imageUrl);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ad;
    }
}
