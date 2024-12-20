package com.example.news_site.service;

import com.example.news_site.dao.CategoryDAO;
import com.example.news_site.model.Category;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class CategoryService {
    private CategoryDAO categoryDAO;

    public CategoryService(Connection connection) {
        this.categoryDAO = new CategoryDAO(connection);
    }

    // 获取所有分类
    public List<Category> getAllCategories() throws SQLException {
        return categoryDAO.getAllCategories();
    }

    // 根据ID获取分类
    public Category getCategoryById(int id) throws SQLException {
        return categoryDAO.getCategoryById(id);
    }

    // 添加分类
    public void addCategory(Category category) throws SQLException {
        categoryDAO.addCategory(category);
    }

    // 更新分类
    public void updateCategory(Category category) throws SQLException {
        categoryDAO.updateCategory(category);
    }

    // 删除分类
    public void deleteCategory(int id) throws SQLException {
        categoryDAO.deleteCategory(id);
    }
}
