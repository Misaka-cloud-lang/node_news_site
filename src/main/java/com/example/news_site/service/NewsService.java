package com.example.news_site.service;

import com.example.news_site.dao.NewsDAO;
import com.example.news_site.model.News;
import com.example.news_site.util.NewsCrawler;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
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
        this.newsCrawler = new NewsCrawler();
    }

    // 添加 getNewsDAO 方法
    public NewsDAO getNewsDAO() {
        return newsDAO;
    }

    // 添加新闻
    public boolean addNews(News news) {
        try {
            // 1. 标题验证
            if (news.getTitle() == null || 
                news.getTitle().isEmpty() || 
                news.getTitle().length() < 10 ||  // 标题至少10个字符
                news.getTitle().contains("登录") ||
                news.getTitle().contains("注册") ||
                news.getTitle().contains("账号") ||
                news.getTitle().contains("首页") ||
                news.getTitle().contains("排行")) {
                return false;
            }

            // 2. 图片URL验证
            String imageUrl = news.getImage();
            if (imageUrl == null || 
                imageUrl.isEmpty() || 
                imageUrl.equals("null") || 
                (!imageUrl.startsWith("http://") && !imageUrl.startsWith("https://"))) {
                return false;
            }

            // 3. 内容验证
            if (news.getDescription() == null || 
                news.getDescription().length() < 50) {  // 内容至少50个字符
                return false;
            }

            // 4. 截断过长的标题
            if (news.getTitle().length() > 450) {
                news.setTitle(news.getTitle().substring(0, 450));
            }
            
            // 5. 检查是否已存在相同标题的新闻
            List<News> existingNews = getNewsByCategory(news.getCategory());
            for (News existing : existingNews) {
                if (existing.getTitle().equals(news.getTitle())) {
                    return false;
                }
            }
            
            return newsDAO.addNews(news);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 获取所有新闻
    public List<News> getAllNews() {
        try {
            return newsDAO.getAllNews();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 根据ID获取新闻
    public News getNewsById(int id) {
        try {
            return newsDAO.getNewsById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 更新新闻
    public boolean updateNews(News news) {
        try {
            newsDAO.updateNews(news);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除新闻
    public boolean deleteNews(int id) {
        try {
            newsDAO.deleteNews(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
        try {
            return newsDAO.searchNews(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
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

    public void testCrawlNews() {
        try {
            System.out.println("开始测试爬取新闻...");
            
            // 为每个分类设置目标数量
            Map<String, Integer> targetCounts = new HashMap<>();
            targetCounts.put("经济", 6);
            targetCounts.put("文化", 54);
            targetCounts.put("娱乐", 141);
            targetCounts.put("体育", 122);
            targetCounts.put("教育", 24);
            targetCounts.put("健康", 156);
            targetCounts.put("国内", 100); // 其他分类保持默认
            targetCounts.put("国际", 100);
            targetCounts.put("科技", 100);
            targetCounts.put("军事", 100);
            
            // 遍历所有分类
            for (String category : targetCounts.keySet()) {
                try {
                    System.out.println("\n处理分类: " + category);
                    int targetCount = targetCounts.get(category);
                    int currentCount = getNewsTotalByCategory(category);
                    
                    if (currentCount >= targetCount) {
                        System.out.println(category + " 已达到目标数量，跳过爬取");
                        continue;
                    }
                    
                    // 计算需要爬取的数量
                    int needCount = targetCount - currentCount;
                    
                    // 爬取新闻
                    System.out.println("开始爬取 " + category + " 分类的新闻...");
                    List<News> newsList = crawlNewsByCategory(category, needCount * 2);
                    
                    // 保存新闻
                    int savedCount = 0;
                    for (News news : newsList) {
                        if (savedCount >= needCount) {
                            break;
                        }
                        if (addNews(news)) {
                            savedCount++;
                        }
                    }
                    
                    System.out.println(category + " 处理完成，新增 " + savedCount + " 条新闻");
                    
                } catch (Exception e) {
                    System.err.println("处理分类 " + category + " 时出错: " + e.getMessage());
                }
            }
            
            System.out.println("\n新闻爬取完成！");
            
        } catch (Exception e) {
            System.err.println("爬取测试失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    public void crawlSelectedCategories(List<String> categories) {
        try {
            System.out.println("开始爬取选定分类的新闻...");
            
            // 爬取新浪新闻
            List<News> sinaNews = newsCrawler.crawlNewsFromSina();
            
            for (String category : categories) {
                System.out.println("开始处理 " + category + " 分类的新闻...");
                
                // 过滤出当前分类的新闻
                List<News> categoryNews = new ArrayList<>();
                for (News news : sinaNews) {
                    if (news.getCategory().equals(category)) {
                        categoryNews.add(news);
                    }
                }
                
                System.out.println(category + " 分类过滤完成，共获取 " + categoryNews.size() + " 条新闻");
                
                // 保存新闻
                for (News news : categoryNews) {
                    try {
                        addNews(news);
                        System.out.println("成功保存新闻：" + news.getTitle());
                    } catch (Exception e) {
                        System.err.println("保存新闻失败：" + news.getTitle());
                    }
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
    public List<News> crawlNewsByCategory(String category, int maxCount) {
        List<News> categoryNews = new ArrayList<>();
        Set<String> existingTitles = new HashSet<>();  // 用于存储已有的标题
        
        try {
            // 先获取数据库中该分类的所有新闻标题
            List<News> existingNews = getNewsByCategory(category);
            for (News news : existingNews) {
                existingTitles.add(news.getTitle());
            }
            
            // 爬取新浪新闻
            List<News> sinaNews = newsCrawler.crawlNewsFromSina();
            
            // 过滤出指定分类的新闻，并去重
            for (News news : sinaNews) {
                if (categoryNews.size() >= maxCount) {
                    break;
                }
                if (news.getCategory().equals(category) && 
                    !existingTitles.contains(news.getTitle())) {
                    categoryNews.add(news);
                    existingTitles.add(news.getTitle());
                }
            }
            
            System.out.println(category + " 分类获取到 " + categoryNews.size() + 
                " 条新闻（去重后）");
                
        } catch (Exception e) {
            System.err.println("爬取 " + category + " 分类新闻失败: " + e.getMessage());
        }
        
        return categoryNews;
    }

    // 修改 updateNewsByCategory 方法
    public void updateNewsByCategory(String category) {
        try {
            // 获取当前分类的新闻数量
            int currentCount = getNewsCategoryCount().getOrDefault(category, 0);
            System.out.println(category + " 当前新闻数: " + currentCount);
            
            // 如果数量不足100，则爬取新闻
            if (currentCount < 100) {
                System.out.println(category + " 数量不足 100，当前: " + currentCount + "，准备重试...");
                
                // 爬取新闻
                NewsCrawler crawler = new NewsCrawler();
                List<News> sinaNews = crawler.crawlNewsFromSina();
                
                // 过滤出当前分类的新闻
                List<News> categoryNews = new ArrayList<>();
                for (News news : sinaNews) {
                    if (news.getCategory().equals(category)) {
                        categoryNews.add(news);
                    }
                }
                
                // 保存新闻
                for (News news : categoryNews) {
                    addNews(news);
                }
                
                System.out.println(category + " 更新完成，新增 " + categoryNews.size() + " 条新闻");
            }
        } catch (Exception e) {
            System.err.println("更新" + category + "新闻失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
