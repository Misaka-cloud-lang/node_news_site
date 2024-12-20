package com.example.news_site.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // 数据库配置
    private static final String URL = "jdbc:mysql://localhost:3306/news_1217?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "Deng2846240558";

    /**
     * 获取数据库连接
     * @return 数据库连接对象
     * @throws SQLException 如果连接失败
     */
    public static Connection getConnection() throws SQLException {
        try {
            // 显式加载MySQL JDBC驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver successfully loaded!");

            // 获取数据库连接
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            // 如果无法加载驱动，抛出异常
            throw new SQLException("MySQL JDBC Driver not found.", e);
        } catch (SQLException e) {
            // 捕获并打印SQL异常
            throw new SQLException("数据库连接失败: " + e.getMessage(), e);
        }
    }
}
