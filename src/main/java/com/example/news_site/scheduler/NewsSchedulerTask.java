package com.example.news_site.scheduler;

import com.example.news_site.util.NewsCrawler;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Date;

public class NewsSchedulerTask {
    private static final long PERIOD = 1000 * 60 * 60; // 1小时

    public void startScheduler() {
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                try {
                    NewsCrawler.fetchNews();
                    System.out.println("新闻抓取完成：" + new Date());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, 0, PERIOD);
    }
} 