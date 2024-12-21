package com.example.news_site.scheduler;

import com.example.news_site.util.NewsCrawler;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.time.LocalDateTime;
import java.time.Duration;

@WebListener
public class NewsSchedulerTask implements ServletContextListener {
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        
        // 计算距离下一个凌晨3点的时间
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime nextRun = now.withHour(3).withMinute(0).withSecond(0);
        if (now.compareTo(nextRun) > 0) {
            nextRun = nextRun.plusDays(1);
        }
        
        long initialDelay = Duration.between(now, nextRun).toSeconds();
        
        // 设置每24小时执行一次爬虫任务
        scheduler.scheduleAtFixedRate(() -> {
            try {
                System.out.println("开始执行每日新闻更新任务: " + LocalDateTime.now());
                NewsCrawler.fetchNews();
                System.out.println("每日新闻更新任务完成: " + LocalDateTime.now());
            } catch (Exception e) {
                System.err.println("新闻更新任务失败: " + e.getMessage());
                e.printStackTrace();
            }
        }, initialDelay, TimeUnit.DAYS.toSeconds(1), TimeUnit.SECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
} 