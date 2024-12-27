package com.example.news_site.service;

import com.example.news_site.dao.NewsDAO;
import com.example.news_site.model.News;
import com.example.news_site.util.NewsCrawler;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class NewsService {
    private NewsDAO newsDAO;
    private NewsCrawler newsCrawler;

    public NewsService() {
        this.newsDAO = new NewsDAO();
        this.newsCrawler = new NewsCrawler(newsDAO);
    }

    // 添加 getNewsDAO 方法
    public NewsDAO getNewsDAO() {
        return newsDAO;
    }

    // 添加新闻
    public boolean addNews(News news) {
        return newsDAO.addNews(news);
    }

    // 获取所有新闻
    public List<News> getAllNews() {
        return newsDAO.getAllNews();
    }

    // 根据ID获取新闻
    public News getNewsById(int id) {
        return newsDAO.getNewsById(id);
    }

    // 更新新闻
    public boolean updateNews(News news) {
        return newsDAO.updateNews(news);
    }

    // 删除新闻
    public boolean deleteNews(int id) {
        return newsDAO.deleteNews(id);
    }

    public List<News> getNewsByCategory(String category) {
        try {
            return newsDAO.getNewsByCategory(category);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public int getNewsTotalByCategory(String category) {
        try {
            return newsDAO.getNewsTotalByCategory(category);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // 添加搜索方法
    public List<News> searchNews(String keyword) {
        return newsDAO.searchNews(keyword);
    }

    public void deleteAllNews() {
        try {
            newsDAO.deleteAllNews();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteHalfNews() {
        try {
            newsDAO.deleteHalfNews();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void crawlSelectedCategories(List<String> categories) {
        try {
            System.out.println("开始爬取选定分类的新闻...");
            
            for (String category : categories) {
                System.out.println("开始处理 " + category + " 分类的新闻...");
                
                // 爬取指定分类的新闻
                List<News> categoryNews = newsCrawler.crawlNewsFromSina(category);
                
                System.out.println(category + " 分类爬取完成，共获取 " + categoryNews.size() + " 条新闻");
                
                // 保存新闻
                if (!categoryNews.isEmpty()) {
                    insertNewsList(categoryNews);
                }
            }
            
            System.out.println("所选分类爬取完成！");
        } catch (Exception e) {
            System.err.println("爬取失败：" + e.getMessage());
            throw e;
        }
    }

    // 获取各分类新闻数量
    public Map<String, Integer> getNewsCategoryCount() {
        Map<String, Integer> counts = new HashMap<>();
        try {
            List<News> allNews = getAllNews();
            for (News news : allNews) {
                counts.merge(news.getCategory(), 1, Integer::sum);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    // 获取上次爬取时间
    public String getLastCrawlTime() {
        // 从数据库或配置文件获取
        return "未实现";
    }

    // 获取总新闻数
    public int getTotalNewsCount() {
        try {
            return getAllNews().size();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // 删除分类中多余的新闻，保留最新的n条
    public void deleteExcessNewsByCategory(String category, int keepCount) {
        try {
            newsDAO.deleteExcessNewsByCategory(category, keepCount);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 修改 crawlNewsByCategory 方法
    public List<News> crawlNewsByCategory(String category, int limit) {
        try {
            // 默认爬取10条
            return newsCrawler.crawlNewsFromSina(category);
        } catch (Exception e) {
            System.err.println("爬取分类新闻失败: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // 修改 updateNewsByCategory 方法
    public void updateNewsByCategory(String category) {
        try {
            // 获取当前分类的新闻数量
            int currentCount = getNewsCategoryCount().getOrDefault(category, 0);
            System.out.println(category + " 当前新闻数: " + currentCount);
            
            // 如果数量不足100，则爬取新闻
            if (currentCount < 100) {
                System.out.println(category + " 数量不足 100，当前: " + currentCount + "，准备爬取...");
                
                // 爬取新闻 - 每次爬取10条
                List<News> categoryNews = newsCrawler.crawlNewsFromSina(category);
                
                // 保存新闻
                if (!categoryNews.isEmpty()) {
                    insertNewsList(categoryNews);
                    System.out.println(category + " 更新完成，新增 " + categoryNews.size() + " 条新闻");
                }
            }
        } catch (Exception e) {
            System.err.println("更新" + category + "新闻失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 修改 getCategoryColor 方法
    private String getCategoryColor(String category) {
        switch (category) {
            case "国内": return "FF4D4F";
            case "国际": return "2681FF";
            case "体育": return "FA8C16";
            case "科技": return "722ED1";
            case "娱乐": return "F759AB";
            case "财经": return "52C41A";
            case "军事": return "FA541C";
            case "社会": return "13C2C2";
            case "股市": return "1890FF";
            case "美股": return "EB2F96";
            default: return "666666";
        }
    }

    // 添加批量插入新闻的方法
    public void insertNewsList(List<News> newsList) {
        try {
            if (newsList == null || newsList.isEmpty()) {
                return;
            }

            System.out.println("准备插入 " + newsList.size() + " 条新闻");
            
            // 获所有标题
            List<String> titles = new ArrayList<>();
            for (News news : newsList) {
                titles.add(news.getTitle());
            }
            
            // 检查已存在的新闻
            List<News> existingNews = newsDAO.getNewsByTitles(titles);
            Set<String> existingTitles = new HashSet<>();
            for (News news : existingNews) {
                existingTitles.add(news.getTitle());
            }
            
            System.out.println("数据库中已存在 " + existingTitles.size() + " 条新闻");
            
            // 过滤出需要插入的新闻
            List<News> newNewsList = new ArrayList<>();
            for (News news : newsList) {
                if (!existingTitles.contains(news.getTitle())) {
                    newNewsList.add(news);
                }
            }
            
            System.out.println("实际需要插入 " + newNewsList.size() + " 条新闻");
            
            // 批量插入新闻
            if (!newNewsList.isEmpty()) {
                int successCount = newsDAO.batchAddNews(newNewsList);
                System.out.println("成功插入 " + successCount + " 条新闻");
            }
            
        } catch (Exception e) {
            System.err.println("批量插入新闻失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 添加 isValidNews 方法
    private boolean isValidNews(News news) {
        try {
            // 标题验证
            if (news.getTitle() == null || 
                news.getTitle().length() < 10 || 
                news.getTitle().length() > 100) {
                System.out.println("标题无效: " + news.getTitle());
                return false;
            }

            // 内容验证
            if (news.getDescription() == null || 
                news.getDescription().length() < 20) {  // 降低最小长度要求
                System.out.println("内容无效: 长度=" + 
                    (news.getDescription() != null ? news.getDescription().length() : 0));
                return false;
            }

            // 图片验证
            if (news.getImage() == null || 
                news.getImage().isEmpty() || 
                !news.getImage().startsWith("http")) {
                System.out.println("图片无效: " + news.getImage());
                return false;
            }

            // 关键词过滤
            String[] excludeKeywords = {
                "广告", "推广", "特惠", "优惠", "活动", 
                "点击", "下载", "APP", "客户端"
            };
            
            for (String keyword : excludeKeywords) {
                if (news.getTitle().contains(keyword)) {
                    System.out.println("标题包含广告关键词: " + keyword);
                    return false;
                }
            }

            return true;
        } catch (Exception e) {
            System.out.println("验证新闻时发生错误: " + e.getMessage());
            return false;
        }
    }

    // 修改 testCrawlNews 方法
    public void testCrawlNews() {
        try {
            System.out.println("开始测试爬取新闻...");
            NewsCrawler crawler = new NewsCrawler(newsDAO);
            List<News> newsList = crawler.crawlAllNews();  // 使用 crawlAllNews
            
            if (!newsList.isEmpty()) {
                System.out.println("爬取完成，共获取 " + newsList.size() + " 条新闻");
                insertNewsList(newsList);
            } else {
                System.out.println("没有爬取到新闻");
            }
        } catch (Exception e) {
            System.err.println("爬取失败：" + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("爬取失败", e);
        }
    }
}
