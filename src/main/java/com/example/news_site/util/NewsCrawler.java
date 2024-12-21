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
import java.util.Date;
import java.util.Collections;

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
                "https://news.sina.com.cn/china/"
            ));
            
            // 国际新闻源
            categoryUrls.put("国际", Arrays.asList(
                "https://news.sina.com.cn/world/"
            ));
            
            // 经济新闻源
            categoryUrls.put("经济", Arrays.asList(
                "https://finance.sina.com.cn/china/",
                "https://finance.sina.com.cn/stock/"
            ));
            
            // 科技新闻源
            categoryUrls.put("科技", Arrays.asList(
                "https://tech.sina.com.cn/",
                "https://tech.sina.com.cn/it/"
            ));
            
            // 娱乐新闻源
            categoryUrls.put("娱乐", Arrays.asList(
                "https://ent.sina.com.cn/",
                "https://ent.sina.com.cn/star/"
            ));
            
            // 体育新闻源
            categoryUrls.put("体育", Arrays.asList(
                "https://sports.sina.com.cn/",
                "https://sports.sina.com.cn/nba/"
            ));
            
            // 教育新闻源
            categoryUrls.put("教育", Arrays.asList(
                "https://edu.sina.com.cn/",
                "https://edu.sina.com.cn/gaokao/"
            ));
            
            // 健康新闻源
            categoryUrls.put("健康", Arrays.asList(
                "https://health.sina.com.cn/",
                "https://health.sina.com.cn/news/"
            ));
            
            // 文化新闻源
            categoryUrls.put("文化", Arrays.asList(
                "https://cul.sina.com.cn/",
                "https://cul.sina.com.cn/art/"
            ));
            
            // 军事新闻源
            categoryUrls.put("军事", Arrays.asList(
                "https://mil.sina.com.cn/",
                "https://mil.sina.com.cn/china/"
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
                        newsElements.addAll(doc.select(".main-content .news-item"));  // 主要内容区的新闻
                        newsElements.addAll(doc.select(".feed-card-item"));  // 新闻卡片
                        newsElements.addAll(doc.select(".news-box"));  // 新闻盒子
                        newsElements.addAll(doc.select(".news-list li"));  // 新闻列表项
                        
                        for (Element element : newsElements) {
                            // 再次检查限制
                            if (categoryCount.get(category) >= MAX_NEWS_PER_CATEGORY) {
                                break;
                            }

                            String title = getTitle(element);
                            String description = getDescription(element);
                            String image = getImage(element);
                            
                            if (!title.isEmpty() && !description.isEmpty()) {
                                News news = new News();
                                news.setTitle(title);
                                news.setDescription(description);
                                news.setCategory(category);
                                
                                // 图片处理
                                if (image.isEmpty() || image.equals("/images/default.jpg")) {
                                    // 根据分类设置默认图片
                                    switch (category) {
                                        case "国内": image = "/images/domestic_default.jpg"; break;
                                        case "国际": image = "/images/international_default.jpg"; break;
                                        case "经济": image = "/images/finance_default.jpg"; break;
                                        case "科技": image = "/images/tech_default.jpg"; break;
                                        case "娱乐": image = "/images/entertainment_default.jpg"; break;
                                        case "体育": image = "/images/sports_default.jpg"; break;
                                        case "教育": image = "/images/education_default.jpg"; break;
                                        case "健康": image = "/images/health_default.jpg"; break;
                                        case "文化": image = "/images/culture_default.jpg"; break;
                                        case "军事": image = "/images/military_default.jpg"; break;
                                        default: image = "/images/default.jpg";
                                    }
                                }
                                news.setImage(image);
                                
                                // 作者和来源
                                news.setAuthor(getDefaultAuthor(category));
                                news.setSource("新浪新闻");
                                
                                // 时间处理
                                news.setPublishTime(new Date());
                                news.setUpdateTime(new Date());
                                
                                // 统计信息
                                news.setViews(0);
                                news.setLikes(0);
                                
                                // 内容处理
                                String summary = description.length() > 200 ? description.substring(0, 200) : description;
                                news.setSummary(summary);
                                news.setContentHtml("<article class=\"news-content\"><p>" + description + "</p></article>");
                                
                                // 标签处理
                                news.setTags(getDefaultTags(category));
                                
                                // 其他属性
                                news.setStatus("published");
                                news.setTop(false);
                                news.setRelatedImages("[\"" + image + "\"]");
                                
                                // 检查新闻是否有效
                                if (isValidNews(news)) {
                                    System.out.println("准备添加新闻: " + title);
                                    System.out.println("分类: " + category);
                                    System.out.println("图片URL: " + image);
                                    System.out.println("内容长度: " + description.length());
                                    
                                    if (!isDuplicateNews(newsList, title)) {
                                        newsList.add(news);
                                        categoryCount.put(category, categoryCount.get(category) + 1);
                                        System.out.println("成功添加新闻：" + title + 
                                            " (当前数量: " + categoryCount.get(category) + ")");
                                    } else {
                                        System.out.println("跳过重复新闻：" + title);
                                    }
                                } else {
                                    System.out.println("新闻验证失败：" + title);
                                }
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

    // 修改标题处理方法
    private String getTitle(Element element) {
        String title = "";
        String[] selectors = {
            ".news-title", "h1", "h2", ".title a", 
            ".card-title", ".list-title"
        };
        
        for (String selector : selectors) {
            Element titleElement = element.select(selector).first();
            if (titleElement != null) {
                title = titleElement.text();
                if (!title.isEmpty() && title.length() > 10) {  // 标题长度至少10个字符
                    if (title.length() > 50) {
                        title = title.substring(0, 47) + "...";
                    }
                    break;
                }
            }
        }
        return title;
    }

    // 修改描述选择器
    private String getDescription(Element element) {
        String description = "";
        String[] selectors = {
            ".news-content", ".article-content", 
            ".content-text", ".card-content"
        };
        
        for (String selector : selectors) {
            Element descElement = element.select(selector).first();
            if (descElement != null) {
                description = descElement.text();
                if (!description.isEmpty() && description.length() > 50) {  // 内容长度至少50个字符
                    break;
                }
            }
        }
        return description;
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

    public static void fetchNews() throws Exception {
        NewsCrawler crawler = new NewsCrawler();
        NewsService newsService = new NewsService();
        
        System.out.println("开始爬取新闻...");
        
        // 只爬取新浪新闻
        List<News> sinaNews = crawler.crawlNewsFromSina();
        System.out.println("新浪新闻爬取完成，获取 " + sinaNews.size() + " 条新闻");
        
        // 删除旧新闻
        System.out.println("开始清理旧新闻...");
        newsService.deleteHalfNews();
        System.out.println("旧新闻清理完成");
        
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
        
        System.out.println("新闻爬取完成，共保存 " + savedCount + " 条新闻");
    }

    // 添加获取默认作者的方法
    private String getDefaultAuthor(String category) {
        switch (category) {
            case "健康": return "健康频道记者";
            case "科技": return "科技频道记者";
            case "体育": return "体育频道记者";
            case "娱乐": return "娱乐频道记者";
            case "国内": return "时政记者";
            case "国际": return "国际记者";
            case "经济": return "财经记者";
            case "教育": return "教育记者";
            case "文化": return "文化记者";
            case "军事": return "军事记者";
            default: return "新闻记者";
        }
    }

    // 添加获取默认标签的方法
    private String getDefaultTags(String category) {
        switch (category) {
            case "健康": return "养生,医疗,健康生活";
            case "科技": return "科技新闻,创新,数码";
            case "体育": return "体育新闻,赛事,运动";
            case "娱乐": return "明星,影视,音乐";
            case "国内": return "时政,社会,民生";
            case "国际": return "国际新闻,外交,全球";
            case "经济": return "财经,金融,商业";
            case "教育": return "教育,考试,升学";
            case "文化": return "文化,艺术,传统";
            case "军事": return "军事,国防,装备";
            default: return "新闻,热点";
        }
    }

    // 添加获取默认来源的方法
    private String getDefaultSource(String category) {
        switch (category) {
            case "健康": return "健康时报";
            case "科技": return "科技日报";
            case "体育": return "体育新闻";
            case "娱乐": return "娱乐周刊";
            case "国内": return "人民日报";
            case "国际": return "环球时报";
            case "经济": return "经济观察报";
            case "教育": return "中国教育报";
            case "文化": return "文化日报";
            case "军事": return "军事新闻";
            default: return "新闻中心";
        }
    }

    // 添加检查重复新闻的方法
    private boolean isDuplicateNews(List<News> newsList, String title) {
        return newsList.stream().anyMatch(news -> news.getTitle().equals(title));
    }

    // 添加新闻验证方法
    private boolean isValidNews(News news) {
        // 1. 标题检查
        if (news.getTitle() == null || news.getTitle().length() < 5) {
            return false;
        }

        // 2. 内容检查
        if (news.getDescription() == null || news.getDescription().length() < 20) {
            return false;
        }

        // 3. 分类检查
        if (news.getCategory() == null || news.getCategory().isEmpty()) {
            return false;
        }

        // 4. 图片检查
        if (news.getImage() == null || 
            (!news.getImage().startsWith("http://") && 
             !news.getImage().startsWith("https://") && 
             !news.getImage().startsWith("/images/"))) {
            return false;
        }

        // 5. 来源检查
        if (news.getSource() == null || news.getSource().isEmpty()) {
            return false;
        }

        // 6. 作者检查
        if (news.getAuthor() == null || news.getAuthor().isEmpty()) {
            return false;
        }

        // 7. 标签检查
        if (news.getTags() == null || news.getTags().isEmpty()) {
            return false;
        }

        // 8. 内容HTML检查
        if (news.getContentHtml() == null || news.getContentHtml().isEmpty()) {
            return false;
        }

        // 9. 摘要检查
        if (news.getSummary() == null || news.getSummary().isEmpty()) {
            return false;
        }

        // 10. 时间检查
        if (news.getPublishTime() == null) {
            return false;
        }

        return true;
    }
}
