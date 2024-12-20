package com.example.news_site.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class NewsCrawler {
    public static void fetchNews() throws Exception {
        Document doc = Jsoup.connect("https://example-news-site.com").get();
        System.out.println(doc.title());
        // TODO: Parse HTML and store news in database
    }
}
