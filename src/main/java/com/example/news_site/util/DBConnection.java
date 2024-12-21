package com.example.news_site.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.InputStream;
import java.util.Properties;

public class DBConnection {
    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        try {
            Properties prop = new Properties();
            InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            prop.load(input);

            driver = prop.getProperty("jdbc.driver");
            url = prop.getProperty("jdbc.url");
            username = prop.getProperty("jdbc.username");
            password = prop.getProperty("jdbc.password");

            Class.forName(driver);
            System.out.println("数据库配置加载成功！");
            System.out.println("URL: " + url);
            System.out.println("Username: " + username);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(url, username, password);
            System.out.println("数据库连接成功！");
            return conn;
        } catch (Exception e) {
            System.out.println("数据库连接失败：" + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
