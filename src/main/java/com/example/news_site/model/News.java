package com.example.news_site.model;

import java.util.Date;

public class News {

    private int id;
    private String title;
    private String description;
    private String category;
    private String image;
    private String author;
    private String source;
    private Date publishTime;
    private Date updateTime;
    private int views;
    private int likes;
    private String tags;
    private String summary;
    private String contentHtml;
    private String relatedImages;
    private boolean isTop;
    private String status;

    // 构造函数
    public News() {}

    public News(int id, String title, String description, String category, String image,
                String author, String source, String tags, String summary, String contentHtml) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.category = category;
        this.image = image;
        this.author = author;
        this.source = source;
        this.tags = tags;
        this.summary = summary;
        this.contentHtml = contentHtml;
    }

    // Getter 和 Setter 方法
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public Date getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(Date publishTime) {
        this.publishTime = publishTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getContentHtml() {
        return contentHtml;
    }

    public void setContentHtml(String contentHtml) {
        this.contentHtml = contentHtml;
    }

    public String getRelatedImages() {
        return relatedImages;
    }

    public void setRelatedImages(String relatedImages) {
        this.relatedImages = relatedImages;
    }

    public boolean isTop() {
        return isTop;
    }

    public void setTop(boolean top) {
        isTop = top;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "News{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", category='" + category + '\'' +
                ", image='" + image + '\'' +
                ", author='" + author + '\'' +
                ", source='" + source + '\'' +
                ", publishTime=" + publishTime +
                ", updateTime=" + updateTime +
                ", views=" + views +
                ", likes=" + likes +
                ", tags='" + tags + '\'' +
                ", summary='" + summary + '\'' +
                ", contentHtml='" + contentHtml + '\'' +
                ", relatedImages='" + relatedImages + '\'' +
                ", isTop=" + isTop +
                ", status='" + status + '\'' +
                '}';
    }
}
