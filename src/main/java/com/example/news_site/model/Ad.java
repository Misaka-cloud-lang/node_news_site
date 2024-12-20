package com.example.news_site.model;

public class Ad {
    private int id;
    private String type;
    private String content;
    private String imageUrl;

    // 构造器、getter 和 setter 方法
    public Ad(int id, String type, String content, String imageUrl) {
        this.id = id;
        this.type = type;
        this.content = content;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
