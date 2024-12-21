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
import java.util.Arrays;

public class NewsCrawler {
    private static final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36";
    private static final int MAX_NEWS_PER_CATEGORY = 1000; // 添加每个分类的最大新闻数限制
    
    // 关键词到分类的映射
    private static final Map<String, String> CATEGORY_KEYWORDS = new HashMap<>();
    static {
        // 国内新闻关键词
        CATEGORY_KEYWORDS.put("政府", "国内");
        CATEGORY_KEYWORDS.put("中国", "国内");
        CATEGORY_KEYWORDS.put("国务院", "国内");
        CATEGORY_KEYWORDS.put("两会", "国内");
        CATEGORY_KEYWORDS.put("人大", "国内");
        CATEGORY_KEYWORDS.put("政协", "国内");
        CATEGORY_KEYWORDS.put("省", "国内");
        CATEGORY_KEYWORDS.put("市", "国内");
        
        // 国际新闻关键词
        CATEGORY_KEYWORDS.put("美国", "国际");
        CATEGORY_KEYWORDS.put("日本", "国际");
        CATEGORY_KEYWORDS.put("俄罗斯", "国际");
        CATEGORY_KEYWORDS.put("联合国", "国际");
        CATEGORY_KEYWORDS.put("欧盟", "国际");
        CATEGORY_KEYWORDS.put("北约", "国际");
        CATEGORY_KEYWORDS.put("国际", "国际");
        CATEGORY_KEYWORDS.put("外交", "国际");
        
        // 经济新闻关键词
        CATEGORY_KEYWORDS.put("股市", "经济");
        CATEGORY_KEYWORDS.put("经济", "经济");
        CATEGORY_KEYWORDS.put("金融", "经济");
        CATEGORY_KEYWORDS.put("基金", "经济");
        CATEGORY_KEYWORDS.put("GDP", "经济");
        CATEGORY_KEYWORDS.put("通货膨胀", "经济");
        CATEGORY_KEYWORDS.put("房地产", "经济");
        CATEGORY_KEYWORDS.put("贸易", "经济");
        
        // 科技新闻关键词
        CATEGORY_KEYWORDS.put("科技", "科技");
        CATEGORY_KEYWORDS.put("互联网", "科技");
        CATEGORY_KEYWORDS.put("人工智能", "科技");
        CATEGORY_KEYWORDS.put("数字", "科技");
        CATEGORY_KEYWORDS.put("芯片", "科技");
        CATEGORY_KEYWORDS.put("5G", "科技");
        CATEGORY_KEYWORDS.put("量子", "科技");
        CATEGORY_KEYWORDS.put("航天", "科技");
        
        // 娱乐新闻关键词
        CATEGORY_KEYWORDS.put("明星", "娱乐");
        CATEGORY_KEYWORDS.put("电影", "娱乐");
        CATEGORY_KEYWORDS.put("综艺", "娱乐");
        CATEGORY_KEYWORDS.put("演员", "娱乐");
        CATEGORY_KEYWORDS.put("电视剧", "娱乐");
        CATEGORY_KEYWORDS.put("音乐", "娱乐");
        CATEGORY_KEYWORDS.put("演唱会", "娱乐");
        CATEGORY_KEYWORDS.put("艺人", "娱乐");
        
        // 体育新闻关键词
        CATEGORY_KEYWORDS.put("足球", "体育");
        CATEGORY_KEYWORDS.put("篮球", "体育");
        CATEGORY_KEYWORDS.put("体育", "体育");
        CATEGORY_KEYWORDS.put("奥运", "体育");
        CATEGORY_KEYWORDS.put("世界杯", "体育");
        CATEGORY_KEYWORDS.put("NBA", "体育");
        CATEGORY_KEYWORDS.put("CBA", "体育");
        CATEGORY_KEYWORDS.put("联赛", "体育");
        
        // 教育新闻关键词
        CATEGORY_KEYWORDS.put("教育", "教育");
        CATEGORY_KEYWORDS.put("高考", "教育");
        CATEGORY_KEYWORDS.put("学校", "教育");
        CATEGORY_KEYWORDS.put("考试", "教育");
        CATEGORY_KEYWORDS.put("大学", "教育");
        CATEGORY_KEYWORDS.put("研究生", "教育");
        CATEGORY_KEYWORDS.put("留学", "教育");
        CATEGORY_KEYWORDS.put("教师", "教育");
        
        // 健康新闻关键词
        CATEGORY_KEYWORDS.put("健康", "健康");
        CATEGORY_KEYWORDS.put("医疗", "健康");
        CATEGORY_KEYWORDS.put("疫情", "健康");
        CATEGORY_KEYWORDS.put("医院", "健康");
        CATEGORY_KEYWORDS.put("疾病", "健康");
        CATEGORY_KEYWORDS.put("药品", "健康");
        CATEGORY_KEYWORDS.put("养生", "健康");
        CATEGORY_KEYWORDS.put("保健", "健康");
        
        // 文化新闻关键词
        CATEGORY_KEYWORDS.put("文化", "文化");
        CATEGORY_KEYWORDS.put("艺术", "文化");
        CATEGORY_KEYWORDS.put("传统", "文化");
        CATEGORY_KEYWORDS.put("非遗", "文化");
        CATEGORY_KEYWORDS.put("文物", "文化");
        CATEGORY_KEYWORDS.put("博物馆", "文化");
        CATEGORY_KEYWORDS.put("展览", "文化");
        CATEGORY_KEYWORDS.put("文学", "文化");
        
        // 军事新闻关键词
        CATEGORY_KEYWORDS.put("军事", "军事");
        CATEGORY_KEYWORDS.put("国防", "军事");
        CATEGORY_KEYWORDS.put("军队", "军事");
        CATEGORY_KEYWORDS.put("武器", "军事");
        CATEGORY_KEYWORDS.put("导弹", "军事");
        CATEGORY_KEYWORDS.put("战斗机", "军事");
        CATEGORY_KEYWORDS.put("航母", "军事");
        CATEGORY_KEYWORDS.put("部队", "军事");
        CATEGORY_KEYWORDS.put("战争", "军事");
        CATEGORY_KEYWORDS.put("军演", "军事");
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
            // 为每个分类添加多个URL源
            Map<String, List<String>> categoryUrls = new HashMap<>();
            
            // 国内新闻源
            categoryUrls.put("国内", Arrays.asList(
                "https://news.sina.com.cn/china/",
                "https://news.sina.com.cn/gov/",
                "https://news.sina.com.cn/society/",
                "https://news.sina.com.cn/roll/#pageid=153&lid=2510&k=&num=50&page=1",
                "https://news.qq.com/china_index.shtml",
                "https://china.huanqiu.com/"
            ));
            
            // 国际新闻源
            categoryUrls.put("国际", Arrays.asList(
                "https://news.sina.com.cn/world/",
                "https://news.sina.com.cn/gjzx/",
                "https://news.sina.com.cn/w/",
                "https://world.huanqiu.com/",
                "https://news.qq.com/world_index.shtml"
            ));
            
            // 经济新闻源
            categoryUrls.put("经济", Arrays.asList(
                "https://finance.sina.com.cn/china/",
                "https://finance.sina.com.cn/stock/",
                "https://finance.sina.com.cn/roll/",
                "https://finance.qq.com/",
                "https://business.sohu.com/",
                "https://money.163.com/"
            ));
            
            // 科技新闻源
            categoryUrls.put("科技", Arrays.asList(
                "https://tech.sina.com.cn/",
                "https://tech.sina.com.cn/internet/",
                "https://tech.sina.com.cn/it/"
            ));
            
            // 娱乐新闻源
            categoryUrls.put("娱乐", Arrays.asList(
                "https://ent.sina.com.cn/",
                "https://ent.sina.com.cn/star/",
                "https://ent.sina.com.cn/movie/",
                "https://ent.sina.com.cn/tv/",
                "https://ent.qq.com/",
                "https://ent.163.com/",
                "https://www.yule.com.cn/",
                "https://ent.ifeng.com/"
            ));
            
            // 体育新闻源
            categoryUrls.put("体育", Arrays.asList(
                "https://sports.sina.com.cn/",
                "https://sports.sina.com.cn/basketball/",
                "https://sports.sina.com.cn/football/",
                "https://sports.qq.com/",
                "https://sports.163.com/",
                "https://sports.sohu.com/",
                "https://sports.ifeng.com/",
                "https://www.hupu.com/"
            ));
            
            // 教育新闻源
            categoryUrls.put("教育", Arrays.asList(
                "https://edu.sina.com.cn/",
                "https://edu.sina.com.cn/gaokao/",
                "https://edu.sina.com.cn/l/",
                "https://edu.qq.com/",
                "https://edu.163.com/",
                "https://learning.sohu.com/",
                "https://edu.ifeng.com/",
                "https://www.eol.cn/"
            ));
            
            // 健康新闻源
            categoryUrls.put("健康", Arrays.asList(
                "https://health.sina.com.cn/",
                "https://health.sina.com.cn/news/",
                "https://health.sina.com.cn/healthcare/",
                "https://health.qq.com/",
                "https://jiankang.163.com/",
                "https://health.sohu.com/",
                "https://fashion.ifeng.com/health/",
                "https://www.39.net/"
            ));
            
            // 文化新闻源
            categoryUrls.put("文化", Arrays.asList(
                "https://cul.sina.com.cn/",
                "https://cul.sina.com.cn/art/",
                "https://book.sina.com.cn/",
                "https://cul.qq.com/",
                "https://culture.163.com/",
                "https://culture.sohu.com/",
                "https://culture.ifeng.com/",
                "https://art.china.cn/"
            ));
            
            // 军事新闻源
            categoryUrls.put("军事", Arrays.asList(
                "https://mil.sina.com.cn/",
                "https://mil.sina.com.cn/china/",
                "https://mil.sina.com.cn/world/",
                "https://mil.sina.com.cn/roll/",
                "https://mil.sina.com.cn/dgby/",
                "https://mil.sina.com.cn/jssd/",
                "https://mil.sina.com.cn/jmxf/",
                "https://mil.sina.com.cn/gtj/",
                "https://mil.huanqiu.com/",
                "https://mil.news.sina.com.cn/",
                "https://military.china.com/",
                "https://mil.qq.com/"
            ));

            // 添加计数器Map
            Map<String, Integer> categoryCount = new HashMap<>();
            
            // 遍历每个分类的所有URL
            for (Map.Entry<String, List<String>> entry : categoryUrls.entrySet()) {
                String category = entry.getKey();
                List<String> urls = entry.getValue();
                categoryCount.put(category, 0); // 初始化计数器
                
                for (String url : urls) {
                    // 检查是否达到限制
                    if (categoryCount.get(category) >= MAX_NEWS_PER_CATEGORY) {
                        System.out.println(category + "新闻已达到" + MAX_NEWS_PER_CATEGORY + "条限制");
                        break;
                    }

                    try {
                        Document doc = Jsoup.connect(url)
                                .userAgent(USER_AGENT)
                                .timeout(5000)
                                .get();
                        
                        // 使用多个选择器来增加抓取成功率
                        Elements newsElements = new Elements();
                        newsElements.addAll(doc.select(".news-item"));
                        newsElements.addAll(doc.select(".news-box"));
                        newsElements.addAll(doc.select("article"));
                        newsElements.addAll(doc.select(".item"));
                        newsElements.addAll(doc.select("[class*=news]"));
                        newsElements.addAll(doc.select("[class*=article]"));
                        
                        for (Element element : newsElements) {
                            // 再次检查限制
                            if (categoryCount.get(category) >= MAX_NEWS_PER_CATEGORY) {
                                break;
                            }

                            String title = getTitle(element);
                            String description = getDescription(element);
                            String image = getImage(element);
                            
                            if (!title.isEmpty() && !description.isEmpty()) {
                                News news = new News(0, title, description, category, image);
                                newsList.add(news);
                                categoryCount.put(category, categoryCount.get(category) + 1);
                                System.out.println("找到" + category + "新闻：" + title + 
                                    " (当前数量: " + categoryCount.get(category) + ")");
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("抓取URL失败: " + url + ", 错误: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("抓取新浪新闻失败: " + e.getMessage());
            e.printStackTrace();
        }
        return newsList;
    }

    // 辅助方法：获取标题
    private String getTitle(Element element) {
        String title = "";
        // 尝试多个选择器
        String[] selectors = {
            "h1", "h2", "h3", ".title", ".headline", "a", "[class*=title]"
        };
        
        for (String selector : selectors) {
            title = element.select(selector).text();
            if (!title.isEmpty()) break;
        }
        return title;
    }

    // 辅助方法：获取描述
    private String getDescription(Element element) {
        String description = "";
        // 尝试多个选择器
        String[] selectors = {
            "p", ".desc", ".summary", ".brief", ".content", "[class*=desc]", "[class*=text]"
        };
        
        for (String selector : selectors) {
            description = element.select(selector).text();
            if (!description.isEmpty()) break;
        }
        return description.isEmpty() ? getTitle(element) : description;
    }

    // 辅助方法：获取图片
    private String getImage(Element element) {
        String image = "";
        // 尝试多个选择器和属性
        String[] selectors = {"img", ".img", ".image", "[class*=img]"};
        String[] attributes = {"src", "data-src", "data-original"};
        
        for (String selector : selectors) {
            Element imgElement = element.select(selector).first();
            if (imgElement != null) {
                for (String attr : attributes) {
                    image = imgElement.attr(attr);
                    if (!image.isEmpty()) break;
                }
            }
            if (!image.isEmpty()) break;
        }
        return image.isEmpty() ? "/images/default.jpg" : image;
    }

    public List<News> crawlNewsFromCCTV() {
        List<News> newsList = new ArrayList<>();
        try {
            Map<String, String> categoryUrls = new HashMap<>();
            categoryUrls.put("国内", "https://news.cctv.com/china/");
            categoryUrls.put("国际", "https://news.cctv.com/world/");
            categoryUrls.put("经济", "https://news.cctv.com/finance/");
            categoryUrls.put("科技", "https://news.cctv.com/tech/");
            categoryUrls.put("娱乐", "https://ent.cctv.com/");
            categoryUrls.put("体育", "https://sports.cctv.com/");
            categoryUrls.put("教育", "https://jy.cctv.com/");
            categoryUrls.put("健康", "https://health.cctv.com/");
            categoryUrls.put("文化", "https://culture.cctv.com/");
            categoryUrls.put("军事", "https://military.cctv.com/");

            // 添加计数器Map
            Map<String, Integer> categoryCount = new HashMap<>();
            for (String category : categoryUrls.keySet()) {
                categoryCount.put(category, 0);
            }

            for (Map.Entry<String, String> entry : categoryUrls.entrySet()) {
                String category = entry.getKey();
                String url = entry.getValue();
                
                // 检查是否达到限制
                if (categoryCount.get(category) >= MAX_NEWS_PER_CATEGORY) {
                    continue;
                }

                Document doc = Jsoup.connect(url)
                        .userAgent(USER_AGENT)
                        .timeout(5000)
                        .get();
                
                Elements newsElements = doc.select(".con_item, .image_list_item, .text_list_item");
                
                for (Element element : newsElements) {
                    // 检查是否达到限制
                    if (categoryCount.get(category) >= MAX_NEWS_PER_CATEGORY) {
                        break;
                    }

                    String title = "";
                    String description = "";
                    String image = "";

                    // 获取标题
                    Element titleElement = element.select(".title_main, h3").first();
                    if (titleElement != null) {
                        title = titleElement.text();
                    }

                    // 获取描述
                    Element descElement = element.select(".brief, .des").first();
                    if (descElement != null) {
                        description = descElement.text();
                    } else {
                        description = title;
                    }

                    // 获取图片
                    Element imgElement = element.select("img").first();
                    if (imgElement != null) {
                        image = imgElement.attr("src");
                        if (image.isEmpty()) {
                            image = imgElement.attr("data-src");
                        }
                    }
                    if (image.isEmpty()) {
                        image = "/images/default.jpg";
                    }

                    if (!title.isEmpty()) {
                        News news = new News(0, title, description, category, image);
                        newsList.add(news);
                        categoryCount.put(category, categoryCount.get(category) + 1);
                        System.out.println("找到新闻 - 分类: " + category + ", 标题: " + title + 
                            " (当前数量: " + categoryCount.get(category) + ")");
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("抓取央视新闻失败: " + e.getMessage());
            e.printStackTrace();
        }
        return newsList;
    }

    public static void fetchNews() throws Exception {
        NewsCrawler crawler = new NewsCrawler();
        NewsService newsService = new NewsService();
        
        // 删除一半旧新闻
        System.out.println("开始清理旧新闻...");
        newsService.deleteHalfNews();
        System.out.println("旧新闻清理完成");
        
        // 爬取新新闻
        List<News> sinaNews = crawler.crawlNewsFromSina();
        List<News> cctvNews = crawler.crawlNewsFromCCTV();
        
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
        
        System.out.println("新闻更新完成，共保存" + (sinaNews.size() + cctvNews.size()) + "条新闻");
    }
}
