package com.example.news_site.service;

import com.example.news_site.dao.AdDAO;
import com.example.news_site.model.Advertisement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class AdService {
    private AdDAO adDAO;

    public AdService() throws SQLException {
        adDAO = new AdDAO();
    }

    // 获取头部广告（Logo、Banner、轮播）
    public List<Advertisement> getHeaderAds() throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_LOGO));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_BANNER));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_CAROUSEL));
        return ads;
    }

    // 获取侧边栏广告（浮动、弹窗、粘性）
    public List<Advertisement> getSidebarAds() throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_FLOATING));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_POPUP));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_STICKY));
        return ads;
    }

    // 获取内容区广告（大图、滚动文字、视频）
    public List<Advertisement> getContentAds() throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_LARGE_IMAGE));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_SCROLL_TEXT));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_VIDEO));
        return ads;
    }

    // 获取新闻之间的广告
    public List<Advertisement> getBetweenAds() throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_BANNER));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_INTERSTITIAL));
        return ads;
    }

    // 获取覆盖广告
    public List<Advertisement> getOverlayAds() throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_OVERLAY));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_EXPANDABLE));
        return ads;
    }

    // 获取角落广告
    public List<Advertisement> getCornerAds() throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_FLOATING));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_STICKY));
        return ads;
    }

    // 获取底部广告
    public List<Advertisement> getFooterAds() throws SQLException {
        List<Advertisement> ads = new ArrayList<>();
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_BANNER));
        ads.addAll(adDAO.getAdsByType(Advertisement.TYPE_SCROLL_TEXT));
        return ads;
    }

    // 随机获取广告
    public Advertisement getRandomAd(List<Advertisement> ads) {
        if (ads == null || ads.isEmpty()) {
            return null;
        }
        int randomIndex = new Random().nextInt(ads.size());
        return ads.get(randomIndex);
    }

    // 关闭资源
    public void close() {
        if (adDAO != null) {
            adDAO.closeConnection();
        }
    }
}
