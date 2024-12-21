package com.example.news_site.model;

public class Advertisement {
    // 广告类型常量
    public static final String TYPE_BANNER = "BANNER";           // 横幅广告
    public static final String TYPE_LOGO = "LOGO";              // Logo广告
    public static final String TYPE_SCROLL_TEXT = "SCROLL_TEXT"; // 滚动文字
    public static final String TYPE_POPUP = "POPUP";            // 弹出窗口
    public static final String TYPE_FLOATING = "FLOATING";       // 浮动广告
    public static final String TYPE_LARGE_IMAGE = "LARGE_IMAGE"; // 大幅图片
    public static final String TYPE_VIDEO = "VIDEO";            // 视频广告
    public static final String TYPE_CAROUSEL = "CAROUSEL";       // 轮播广告
    public static final String TYPE_INTERSTITIAL = "INTERSTITIAL"; // 插页广告
    public static final String TYPE_STICKY = "STICKY";          // 粘性广告
    public static final String TYPE_EXPANDABLE = "EXPANDABLE";   // 可展开广告
    public static final String TYPE_OVERLAY = "OVERLAY";        // 覆盖广告
    
    // 广告位置常量
    public static final String POSITION_HEADER = "header";     // 头部
    public static final String POSITION_SIDEBAR = "sidebar";   // 侧边栏
    public static final String POSITION_CONTENT = "content";   // 内容区
    public static final String POSITION_FOOTER = "footer";     // 底部
    public static final String POSITION_BETWEEN = "between";   // 新闻之间
    public static final String POSITION_OVERLAY = "overlay";   // 覆盖层
    public static final String POSITION_CORNER = "corner";     // 角落

    private Long id;
    private String type;        // BANNER, POPUP, FLOATING, SCROLL_TEXT, LOGO
    private String content;     // 广告内容
    private String imageUrl;    // 图片URL
    private String linkUrl;     // 点击跳转链接
    private String position;    // 广告位置：header, sidebar, footer, content
    private boolean active;     // 是否启用

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
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

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    // 可选：添加构造函数
    public Advertisement() {
    }

    public Advertisement(Long id, String type, String content, String imageUrl, String linkUrl, String position, boolean active) {
        this.id = id;
        this.type = type;
        this.content = content;
        this.imageUrl = imageUrl;
        this.linkUrl = linkUrl;
        this.position = position;
        this.active = active;
    }
} 