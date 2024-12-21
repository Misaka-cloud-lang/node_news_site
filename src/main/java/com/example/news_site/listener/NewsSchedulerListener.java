package com.example.news_site.listener;

import com.example.news_site.scheduler.NewsSchedulerTask;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class NewsSchedulerListener implements ServletContextListener {
    private NewsSchedulerTask schedulerTask;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        schedulerTask = new NewsSchedulerTask();
        schedulerTask.startScheduler();
        System.out.println("新闻抓取定时任务已启动");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 清理资源
    }
} 