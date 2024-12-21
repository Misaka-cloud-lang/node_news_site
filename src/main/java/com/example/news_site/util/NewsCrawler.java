package com.example.news_site.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import com.example.news_site.model.News;
import com.example.news_site.service.NewsService;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class NewsCrawler {
    private static final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36";
    
    // 关键词到分类的映射
    private static final Map<String, String> CATEGORY_KEYWORDS = new HashMap<>();
    static {
        // 国内新闻关键词
        CATEGORY_KEYWORDS.put("政府", "国内");
        CATEGORY_KEYWORDS.put("中国", "国内");
        CATEGORY_KEYWORDS.put("国务院", "国内");
        CATEGORY_KEYWORDS.put("两会", "国内");
        
        // 国际新闻关键词
        CATEGORY_KEYWORDS.put("美国", "国际");
        CATEGORY_KEYWORDS.put("日本", "国际");
        CATEGORY_KEYWORDS.put("俄罗斯", "国际");
        CATEGORY_KEYWORDS.put("联合国", "国际");
        
        // 经济新闻关键词
        CATEGORY_KEYWORDS.put("股市", "经济");
        CATEGORY_KEYWORDS.put("经济", "经济");
        CATEGORY_KEYWORDS.put("金融", "经济");
        CATEGORY_KEYWORDS.put("基金", "经济");
        
        // 科技新闻关键词
        CATEGORY_KEYWORDS.put("科技", "科技");
        CATEGORY_KEYWORDS.put("互联网", "科技");
        CATEGORY_KEYWORDS.put("人工智能", "科技");
        CATEGORY_KEYWORDS.put("数字", "科技");
        
        // 娱乐新闻关键词
        CATEGORY_KEYWORDS.put("明星", "娱乐");
        CATEGORY_KEYWORDS.put("电影", "娱乐");
        CATEGORY_KEYWORDS.put("综艺", "娱乐");
        CATEGORY_KEYWORDS.put("演员", "娱乐");
        
        // 体育新闻关键词
        CATEGORY_KEYWORDS.put("足球", "体育");
        CATEGORY_KEYWORDS.put("篮球", "体育");
        CATEGORY_KEYWORDS.put("体育", "体育");
        CATEGORY_KEYWORDS.put("奥运", "体育");
        
        // 教育新闻关键词
        CATEGORY_KEYWORDS.put("教育", "教育");
        CATEGORY_KEYWORDS.put("高考", "教育");
        CATEGORY_KEYWORDS.put("学校", "教育");
        CATEGORY_KEYWORDS.put("考试", "教育");
        
        // 健康新闻关键词
        CATEGORY_KEYWORDS.put("健康", "健康");
        CATEGORY_KEYWORDS.put("医疗", "健康");
        CATEGORY_KEYWORDS.put("疫情", "健康");
        CATEGORY_KEYWORDS.put("医院", "健康");
        
        // 文化新闻关键词
        CATEGORY_KEYWORDS.put("文化", "文化");
        CATEGORY_KEYWORDS.put("艺术", "文化");
        CATEGORY_KEYWORDS.put("传统", "文化");
        CATEGORY_KEYWORDS.put("非遗", "文化");
        
        // 军事新闻关键词
        CATEGORY_KEYWORDS.put("军事", "军事");
        CATEGORY_KEYWORDS.put("国防", "军事");
        CATEGORY_KEYWORDS.put("军队", "军事");
        CATEGORY_KEYWORDS.put("武器", "军事");
    }

    // 根据内容判断分类
    private String determineCategory(String title, String description) {
        String content = (title + " " + description).toLowerCase();
        for (Map.Entry<String, String> entry : CATEGORY_KEYWORDS.entrySet()) {
            if (content.contains(entry.getKey())) {
                return entry.getValue();
            }
        }
        return "其他"; // 默认分类
    }

    public List<News> crawlNewsFromSina() {
        List<News> newsList = new ArrayList<>();
        try {
            // 抓取新浪各个分类的新闻
            Map<String, String> categoryUrls = new HashMap<>();
            categoryUrls.put("国内", "https://news.sina.com.cn/china/");
            categoryUrls.put("国际", "https://news.sina.com.cn/world/");
            categoryUrls.put("经济", "https://finance.sina.com.cn/");
            categoryUrls.put("科技", "https://tech.sina.com.cn/");
            categoryUrls.put("娱乐", "https://ent.sina.com.cn/");
            categoryUrls.put("体育", "https://sports.sina.com.cn/");
            categoryUrls.put("教育", "https://edu.sina.com.cn/");
            categoryUrls.put("健康", "https://health.sina.com.cn/");
            categoryUrls.put("文化", "https://cul.sina.com.cn/");
            categoryUrls.put("军事", "https://mil.sina.com.cn/");

            for (Map.Entry<String, String> entry : categoryUrls.entrySet()) {
                String category = entry.getKey();
                String url = entry.getValue();
                
                Document doc = Jsoup.connect(url)
                        .userAgent(USER_AGENT)
                        .timeout(5000)
                        .get();
                
                Elements newsElements = doc.select("div.news-item");
                for (Element element : newsElements) {
                    String title = element.select("h2").text();
                    String description = element.select("p").text();
                    if (description.isEmpty()) {
                        description = title;
                    }
                    
                    String image = element.select("img").attr("src");
                    if (image.isEmpty()) {
                        image = "/images/default.jpg";
                    }
                    
                    if (!title.isEmpty()) {
                        News news = new News(0, title, description, category, image);
                        newsList.add(news);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newsList;
    }

    public List<News> crawlNewsFromCCTV() {
        List<News> newsList = new ArrayList<>();
        try {
            // CCTV新闻分类URL
            Map<String, String> categoryUrls = new HashMap<>();
            categoryUrls.put("国内", "https://news.cctv.com/china/");
            categoryUrls.put("国际", "https://news.cctv.com/world/");
            categoryUrls.put("经济", "https://news.cctv.com/finance/");
            categoryUrls.put("科技", "https://news.cctv.com/tech/");
            categoryUrls.put("娱乐", "https://news.cctv.com/ent/");
            categoryUrls.put("体育", "https://sports.cctv.com/");
            categoryUrls.put("教育", "https://news.cctv.com/edu/");
            categoryUrls.put("健康", "https://news.cctv.com/health/");
            categoryUrls.put("文化", "https://news.cctv.com/culture/");
            categoryUrls.put("军事", "https://news.cctv.com/military/");

            for (Map.Entry<String, String> entry : categoryUrls.entrySet()) {
                String category = entry.getKey();
                String url = entry.getValue();
                
                Document doc = Jsoup.connect(url)
                        .userAgent(USER_AGENT)
                        .timeout(5000)
                        .get();
                
                Elements newsElements = doc.select("div.news_item");
                for (Element element : newsElements) {
                    String title = element.select(".title_main").text();
                    String description = element.select(".brief").text();
                    if (description.isEmpty()) {
                        description = title;
                    }
                    
                    String image = element.select("img").attr("src");
                    if (image.isEmpty()) {
                        image = "/images/default.jpg";
                    }
                    
                    if (!title.isEmpty()) {
                        News news = new News(0, title, description, category, image);
                        newsList.add(news);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newsList;
    }

    public static void fetchNews() throws Exception {
        NewsCrawler crawler = new NewsCrawler();
        List<News> sinaNews = crawler.crawlNewsFromSina();
        List<News> cctvNews = crawler.crawlNewsFromCCTV();
        
        // 保存到数据库
        NewsService newsService = new NewsService();
        
        // 保存新浪新闻
        System.out.println("开始保存新浪新闻，共" + sinaNews.size() + "条");
        for (News news : sinaNews) {
            newsService.addNews(news);
        }
        
        // 保存央视新闻
        System.out.println("开始保存央视新闻，共" + cctvNews.size() + "条");
        for (News news : cctvNews) {
            newsService.addNews(news);
        }
        
        System.out.println("新闻抓取完成，共保存" + (sinaNews.size() + cctvNews.size()) + "条新闻");
    }
}
