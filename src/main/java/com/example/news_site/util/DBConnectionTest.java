package com.example.news_site.util;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTest {

    public static void main(String[] args) {
        try {
            // 尝试获取数据库连接
            Connection connection = DBConnection.getConnection();

            // 检查连接是否有效
            if (connection != null && !connection.isClosed()) {
                System.out.println("Connection Successful!");
            } else {
                System.out.println("Connection Failed!");
            }

            // 关闭连接
            connection.close();
        } catch (SQLException e) {
            System.out.println("数据库连接失败: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unknown Error occurred:\n" + e.getMessage());
        }
    }
}
