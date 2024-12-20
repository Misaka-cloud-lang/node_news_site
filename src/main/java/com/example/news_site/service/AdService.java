package com.example.news_site.service;

import com.example.news_site.model.Ad;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class AdService {

    private List<Ad> adList;

    public AdService() {
        adList = new ArrayList<>();
        // 使用本地图片路径作为广告图片
        adList.add(new Ad(1, "banner", "欢迎访问我们的新闻网站！", "images/banner1.jpg"));
        adList.add(new Ad(2, "floating", "点击查看最新新闻！", "images/floating1.jpg"));
        adList.add(new Ad(3, "popup", "查看热搜新闻！", "images/popup1.jpg"));
        adList.add(new Ad(4, "banner", "特价广告位，欢迎合作！", "images/banner2.jpg"));
    }

    public List<Ad> getAds() {
        return adList;
    }

    public Ad getRandomAd(List<Ad> ads) {
        Random random = new Random();
        return ads.get(random.nextInt(ads.size()));  // 随机选择一个广告
    }
}
