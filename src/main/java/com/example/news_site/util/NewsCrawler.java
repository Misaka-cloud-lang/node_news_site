package com.example.news_site.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.json.JSONObject;
import org.json.JSONArray;
import com.example.news_site.model.News;
import com.example.news_site.dao.NewsDAO;
import java.util.*;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class NewsCrawler {
    private static final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36";
    private NewsDAO newsDAO;
    
    // 添加构造函数，接收 NewsDAO 实例
    public NewsCrawler(NewsDAO newsDAO) {
        this.newsDAO = newsDAO;
    }
    
    // 新浪新闻 API 接口
    private static final Map<String, String> NEWS_APIS = new LinkedHashMap<>() {{
        put("国内", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2510&k=&num=50&page=1");
        put("国际", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2511&k=&num=50&page=1");
        put("体育", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2512&k=&num=50&page=1");
        put("科技", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2515&k=&num=50&page=1");
        put("娱乐", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2513&k=&num=50&page=1");
        put("财经", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2516&k=&num=50&page=1");
        put("军事", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2514&k=&num=50&page=1");
        put("社会", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2669&k=&num=50&page=1");
        put("股市", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2517&k=&num=50&page=1");
        put("美股", "https://feed.mix.sina.com.cn/api/roll/get?pageid=153&lid=2518&k=&num=50&page=1");
    }};

    // LID 到分类的映射
    private static final Map<String, String> LID_CATEGORY_MAP = new LinkedHashMap<>() {{
        put("2510", "国内");
        put("2511", "国际");
        put("2512", "体育");
        put("2515", "科技");
        put("2513", "娱乐");
        put("2516", "财经");
        put("2514", "军事");
        put("2669", "社会");
        put("2517", "股市");
        put("2518", "美股");
    }};

    public List<News> crawlNewsFromSina() {
        List<News> allNews = new ArrayList<>();
        
        for (Map.Entry<String, String> entry : NEWS_APIS.entrySet()) {
            String category = entry.getKey();
            String apiUrl = entry.getValue();
            List<News> categoryNews = new ArrayList<>();
            int newsCount = 0;
            
            System.out.println("正在爬取分类: " + category);
            System.out.println("正在处理URL: " + apiUrl);
            
            try {
                Document doc = Jsoup.connect(apiUrl)
                        .userAgent(USER_AGENT)
                        .ignoreContentType(true)
                        .timeout(10000)
                        .get();
                
                JSONObject json = new JSONObject(doc.text());
                if (json.has("result") && json.getJSONObject("result").has("data")) {
                    JSONArray data = json.getJSONObject("result").getJSONArray("data");
                    
                    for (int i = 0; i < data.length(); i++) {
                        if (newsCount >= 20) {
                            break;
                        }
                        
                        try {
                            JSONObject item = data.getJSONObject(i);
                            String newsUrl = item.getString("url");
                            
                            // 检查分类是否匹配
                            String urlLid = getUrlParameter(apiUrl, "lid");
                            if (!category.equals(LID_CATEGORY_MAP.get(urlLid))) {
                                System.out.println("分类不匹配: 期望分类=" + category + 
                                    ", URL lid=" + urlLid + ", 标题=" + item.getString("title"));
                                continue;
                            }
                            
                            // 获取新闻详情
                            Map<String, String> content = parseNewsContent(newsUrl);
                            if (content == null) {
                                continue;
                            }
                            
                            News news = new News();
                            news.setTitle(item.getString("title"));
                            news.setDescription(content.get("description"));
                            news.setCategory(category);
                            news.setImage(content.get("image"));
                            news.setAuthor(content.get("author"));
                            news.setSource(item.optString("media_name", content.get("source")));
                            news.setPublishTime(new Date());
                            news.setUpdateTime(new Date());
                            news.setViews(0);
                            news.setLikes(0);
                            news.setTags(category);
                            news.setSummary(content.get("description").substring(0, 
                                Math.min(100, content.get("description").length())));
                            news.setContentHtml(content.get("content_html"));
                            news.setRelatedImages(content.get("related_images"));
                            news.setTop(false);
                            news.setStatus("published");
                            
                            System.out.println("找到新闻: " + news.getTitle());
                            categoryNews.add(news);  // 添加到当前分类列表
                            newsCount++;
                            
                            Thread.sleep((long)(Math.random() * 1000 + 1000));
                            
                        } catch (Exception e) {
                            System.out.println("解析新闻项失败: " + e.getMessage());
                        }
                    }
                } else {
                    System.out.println("API返回数据格式不正确");
                }
                
                // 当前分类爬取完成后，立即检查并插入数据库
                if (!categoryNews.isEmpty()) {
                    System.out.println("准备插入 " + categoryNews.size() + " 条" + category + "新闻");
                    
                    // 获取所有标题
                    List<String> titles = new ArrayList<>();
                    for (News news : categoryNews) {
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
                    for (News news : categoryNews) {
                        if (!existingTitles.contains(news.getTitle())) {
                            newNewsList.add(news);
                        }
                    }
                    
                    System.out.println("实际需要插入 " + newNewsList.size() + " 条新闻");
                    
                    // 批量插入新闻
                    if (!newNewsList.isEmpty()) {
                        int successCount = newsDAO.batchAddNews(newNewsList);
                        System.out.println("成功插入 " + successCount + " 条" + category + "新闻");
                    }
                    
                    // 添加到总列表
                    allNews.addAll(newNewsList);
                }
                
                System.out.println("当前已获取 " + newsCount + " 条" + category + "新闻");
                
            } catch (Exception e) {
                System.out.println("爬取" + category + "失败: " + e.getMessage());
            }
            
            System.out.println("完成" + category + "分类，共获取 " + newsCount + " 条新闻");
        }
        
        return allNews;
    }
    
    private Map<String, String> parseNewsContent(String url) {
        try {
            Document doc = Jsoup.connect(url)
                    .userAgent(USER_AGENT)
                    .timeout(10000)
                    .get();
            
            Element article = doc.selectFirst("#artibody, .article-content");
            if (article == null) {
                return null;
            }
            
            String image = "";
            Element imgElem = article.selectFirst("img");
            if (imgElem != null) {
                image = imgElem.attr("src");
                if (!image.startsWith("http")) {
                    image = "https:" + image;
                }
            }
            
            String author = "";
            String source = "";
            Element info = doc.selectFirst(".article-info");
            if (info != null) {
                Element authorElem = info.selectFirst(".author");
                author = authorElem != null ? authorElem.text() : "";
                Element sourceElem = info.selectFirst(".source");
                source = sourceElem != null ? sourceElem.text() : "";
            }
            
            Map<String, String> content = new HashMap<>();
            content.put("content_html", article.html());
            content.put("description", article.text().substring(0, 
                Math.min(200, article.text().length())));
            content.put("image", image);
            content.put("related_images", "");
            content.put("author", author);
            content.put("source", source);
            
            return content;
            
        } catch (Exception e) {
            System.out.println("解析文章内容失败: " + url + ", 错误: " + e.getMessage());
            return null;
        }
    }
    
    private String getUrlParameter(String url, String name) {
        try {
            String query = new URL(url).getQuery();
            String[] pairs = query.split("&");
            for (String pair : pairs) {
                String[] parts = pair.split("=");
                if (parts[0].equals(name)) {
                    return parts[1];
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public List<News> crawlAllNews() {
        return crawlNewsFromSina();  // 直接调用现有的方法，它已经会爬取所有分类
    }

    public List<News> crawlNewsFromSina(String category) {
        List<News> allNews = crawlNewsFromSina();
        List<News> categoryNews = new ArrayList<>();
        
        // 从所有新闻中筛选出指定分类的新闻
        for (News news : allNews) {
            if (news.getCategory().equals(category)) {
                categoryNews.add(news);
            }
        }
        
        return categoryNews;
    }
}
