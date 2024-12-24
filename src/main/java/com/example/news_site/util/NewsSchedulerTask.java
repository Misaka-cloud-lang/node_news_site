package com.example.news_site.util;

import com.example.news_site.dao.NewsDAO;
import com.example.news_site.model.News;
import com.example.news_site.service.NewsService;
import com.example.news_site.util.NewsCrawler;

import jakarta.servlet.ServletContextListener;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.annotation.WebListener;
import java.util.List;
import java.util.Timer;
import java.util.Calendar;
import java.util.Date;

@WebListener
public class NewsSchedulerTask implements ServletContextListener {
    private Timer timer;
    private NewsService newsService;
    private static final String[] CATEGORIES = {
        "国内", "国际", "体育", "科技", "娱乐", 
        "财经", "军事", "社会", "股市", "美股"
    };

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        newsService = new NewsService();
        timer = new Timer(true);
        
        // 设置每天凌晨2点执行
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 2);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        
        // 如果当前时间已过今天的执行时间，则设置为明天
        Date firstTime = calendar.getTime();
        if (firstTime.before(new Date())) {
            calendar.add(Calendar.DATE, 1);
            firstTime = calendar.getTime();
        }
        
        // 设置定时任务每24小时执行一次
        timer.scheduleAtFixedRate(new java.util.TimerTask() {
            @Override
            public void run() {
                try {
                    System.out.println("开始每日定时爬取新闻任务...");
                    
                    NewsDAO newsDAO = new NewsDAO();
                    NewsCrawler crawler = new NewsCrawler(newsDAO);
                    List<News> allNews = crawler.crawlAllNews();  // 现在每个分类会爬取10条
                    
                    if (!allNews.isEmpty()) {
                        System.out.println("爬取完成，共获取 " + allNews.size() + " 条新闻");
                        
                        // 清理旧新闻，保留最新的100条
                        for (String category : CATEGORIES) {
                            newsService.deleteExcessNewsByCategory(category, 100);
                        }
                    }
                    
                    System.out.println("每日定时爬取任务完成");
                    
                } catch (Exception e) {
                    System.err.println("定时任务执行失败: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }, firstTime, 24 * 60 * 60 * 1000); // 24小时间隔
        
        System.out.println("新闻爬虫时任务已启动，将于每天" + calendar.get(Calendar.HOUR_OF_DAY) + 
                          "点" + calendar.get(Calendar.MINUTE) + "分执行");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel();
        }
    }
}