package com.example.news_site.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.json.JSONObject;
import org.json.JSONArray;
import com.example.news_site.model.News;
import com.example.news_site.dao.NewsDAO;
import java.util.*;

public class NewsCrawler {
    private NewsDAO newsDAO;
    private static final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36";
    
    // 新浪新闻 API 接口
    private static final Map<String, String> NEWS_APIS = new HashMap<>() {{
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

    public NewsCrawler(NewsDAO newsDAO) {
        this.newsDAO = newsDAO;
    }

    private String fetchHtml(String url) {
        try {
            return Jsoup.connect(url)
                    .userAgent(USER_AGENT)
                    .header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
                    .header("Accept-Language", "zh-CN,zh;q=0.9,en;q=0.8")
                    .header("Connection", "keep-alive")
                    .header("Referer", "https://www.sina.com.cn/")
                    .ignoreContentType(true)
                    .timeout(10000)
                    .execute()
                    .body();
        } catch (Exception e) {
            System.err.println("获取页面失败: " + url + ", 错误: " + e.getMessage());
            return null;
        }
    }

    private Map<String, String> parseNewsContent(String url) {
        String html = fetchHtml(url);
        if (html == null) return null;

        try {
            Document doc = Jsoup.parse(html);
            Element article = doc.selectFirst("#artibody, .article-content");
            if (article == null) return null;

            String image = "";
            Element imgElem = article.selectFirst("img");
            if (imgElem != null) {
                image = imgElem.attr("src");
                if (!image.startsWith("http")) {
                    image = image.startsWith("//") ? "https:" + image : "";
                }
            }

            String author = "";
            String source = "";
            Element info = doc.selectFirst(".article-info");
            if (info != null) {
                Element authorElem = info.selectFirst(".author");
                Element sourceElem = info.selectFirst(".source");
                author = authorElem != null ? authorElem.text().trim() : "";
                source = sourceElem != null ? sourceElem.text().trim() : "";
            }

            Map<String, String> content = new HashMap<>();
            content.put("content_html", article.toString());
            content.put("description", article.text().substring(0, Math.min(200, article.text().length())));
            content.put("image", image);
            content.put("related_images", "");
            content.put("author", author);
            content.put("source", source);

            return content;
        } catch (Exception e) {
            System.err.println("解析文章内容失败: " + url + ", 错误: " + e.getMessage());
            return null;
        }
    }

    public List<News> crawlNewsFromSina(String category) {
        List<News> newsList = new ArrayList<>();
        String apiUrl = NEWS_APIS.get(category);
        
        if (apiUrl == null) {
            System.err.println("未找到分类: " + category);
            return newsList;
        }

        System.out.println("正在爬取分类: " + category);
        System.out.println("正在处理URL: " + apiUrl);

        String html = fetchHtml(apiUrl);
        if (html == null) return newsList;

        try {
            JSONObject json = new JSONObject(html);
            if (json.has("result") && json.getJSONObject("result").has("data")) {
                JSONArray data = json.getJSONObject("result").getJSONArray("data");

                for (int i = 0; i < data.length() && newsList.size() < 10; i++) {
                    JSONObject item = data.getJSONObject(i);
                    String title = item.optString("title", "");
                    String link = item.optString("url", "");
                    String summary = item.optString("summary", "");
                    String mediaName = item.optString("media_name", "");

                    if (title.isEmpty() || link.isEmpty()) continue;

                    Map<String, String> contentData = parseNewsContent(link);
                    if (contentData == null) continue;

                    if (!isValidNews(title, contentData.get("content_html"))) {
                        System.out.println("新闻未通过过滤: " + title);
                        continue;
                    }

                    News news = new News();
                    news.setTitle(title);
                    news.setDescription(summary.isEmpty() ? contentData.get("description") : summary);
                    news.setCategory(category);
                    news.setImage(contentData.get("image"));
                    news.setAuthor(contentData.get("author"));
                    news.setSource(mediaName.isEmpty() ? contentData.get("source") : mediaName);
                    news.setPublishTime(new Date());
                    news.setUpdateTime(new Date());
                    news.setViews(0);
                    news.setLikes(0);
                    news.setTags(category);
                    news.setContentHtml(contentData.get("content_html"));
                    news.setStatus("published");

                    System.out.println("找到新闻: " + title);
                    newsList.add(news);
                    Thread.sleep(1000);
                }

                if (!newsList.isEmpty()) {
                    System.out.println("准备插入 " + newsList.size() + " 条新闻");
                    newsDAO.batchAddNews(newsList);
                }
            }
        } catch (Exception e) {
            System.err.println("解析新闻失败: " + e.getMessage());
        }

        return newsList;
    }

    private boolean isValidNews(String title, String content) {
        try {
            // 标题长度检查
            if (title == null || title.length() < 5 || title.length() > 100) {
                return false;
            }

            // 内容长度检查
            if (content == null || content.length() < 50) {
                return false;
            }

            // 广告关键词过滤
            String[] adKeywords = {
                "广告", "推广", "特惠", "优惠", "活动", 
                "点击", "下载", "APP", "客户端", "折扣",
                "促销", "抢购", "秒杀", "立即购买", "免费",
                "低价", "特价", "优享", "限时", "独家"
            };
            
            for (String keyword : adKeywords) {
                if (title.contains(keyword)) {
                    System.out.println("标题包含广告关键词: " + keyword + ", 标题: " + title);
                    return false;
                }
            }

            // 垃圾内容关键词过滤
            String[] spamKeywords = {
                "赌博", "博彩", "成人", "情色", "色情",
                "约炮", "一夜情", "代开发票", "假",
                "办证", "vpn", "翻墙", "私服", "外挂"
            };
            
            for (String keyword : spamKeywords) {
                if (title.contains(keyword) || content.contains(keyword)) {
                    System.out.println("内容包含垃圾关键词: " + keyword);
                    return false;
                }
            }

            // 标题重复词检查
            String[] words = title.split("");
            Set<String> uniqueWords = new HashSet<>();
            int duplicateCount = 0;
            for (String word : words) {
                if (!uniqueWords.add(word)) {
                    duplicateCount++;
                }
            }
            if (duplicateCount > title.length() * 0.5) {
                System.out.println("标题重复词过多: " + title);
                return false;
            }

            return true;
        } catch (Exception e) {
            System.out.println("验证新闻时发生错误: " + e.getMessage());
            return false;
        }
    }

    // 在 NewsCrawler 类中添加 crawlAllNews 方法
    public List<News> crawlAllNews() {
        List<News> allNews = new ArrayList<>();
        
        for (String category : NEWS_APIS.keySet()) {
            try {
                List<News> categoryNews = crawlNewsFromSina(category);
                if (categoryNews != null && !categoryNews.isEmpty()) {
                    allNews.addAll(categoryNews);
                }
                // 每个分类爬取后休息5秒
                Thread.sleep(5000);
            } catch (Exception e) {
                System.err.println("爬取分类 " + category + " 失败: " + e.getMessage());
            }
        }
        
        System.out.println("所有分类爬取完成，共获取 " + allNews.size() + " 条新闻");
        return allNews;
    }
}
