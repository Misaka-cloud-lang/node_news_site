package com.example.news_site.util;

import jakarta.servlet.ServletContextListener;
import jakarta.servlet.ServletContextEvent;
import com.example.news_site.service.NewsService;
import com.example.news_site.model.News;
import java.util.Timer;
import java.util.TimerTask;
import java.util.List;
import java.util.Map;
import java.util.Arrays;
import java.util.HashMap;

public class NewsSchedulerTask implements ServletContextListener {
    private Timer timer;
    private NewsService newsService;
    private static final int HOUR = 3600 * 1000; // 1小时的毫秒数

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        newsService = new NewsService();
        timer = new Timer(true);
        
        // 立即执行一次爬取
        System.out.println("系统启动，开始第一次爬取...");
        crawlNews();
        
        // 设置定时任务，每4小时执行一次
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                crawlNews();
            }
        }, HOUR * 4, HOUR * 4); // 4小时后开始，每4小时执行一次
        
        System.out.println("新闻爬取定时任务已启动");
    }

    private void crawlNews() {
        try {
            System.out.println("\n开始执行定时新闻爬取任务...");
            
            // 爬取新闻
            NewsCrawler crawler = new NewsCrawler();
            List<News> sinaNews = crawler.crawlNewsFromSina();
            System.out.println("新浪新闻爬取完成，获取 " + sinaNews.size() + " 条新闻");
            
            // 保存新闻
            int savedCount = 0;
            for (News news : sinaNews) {
                try {
                    if (newsService.addNews(news)) {
                        savedCount++;
                        if (savedCount % 10 == 0) {
                            System.out.println("已保存 " + savedCount + " 条新闻");
                        }
                    }
                } catch (Exception e) {
                    System.err.println("保存新闻失败: " + news.getTitle());
                    e.printStackTrace();
                }
            }
            
            System.out.println("定时爬取完成，共保存 " + savedCount + " 条新闻");
            
        } catch (Exception e) {
            System.err.println("定时任务执行失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel();
        }
    }
}