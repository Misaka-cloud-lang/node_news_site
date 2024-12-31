package com.example.news_site.dao;

import java.sql.PreparedStatement;
import java.util.List;

public class UserID_DAO {
    private final java.sql.Connection connection;

    public UserID_DAO(java.sql.Connection connection) {
        this.connection = connection;
    }

    public List<Integer> getAllUserIDs() {
        List<Integer> userIDs = new java.util.ArrayList<>();
        String sql = "SELECT id FROM user";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             java.sql.ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                userIDs.add(resultSet.getInt("id"));
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return userIDs;
    }

    public int minFreeID(List<Integer> userIDs) {
        for (int id = 1; true; id++) {
            if (!userIDs.contains(id)) {
                return id;
            }
        }
    }

    public int minFreeID() {
        return minFreeID(getAllUserIDs());
    }

    public boolean registerNewID(int id) {
        String validateExistingID = "SELECT id FROM user WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(validateExistingID)) {
            statement.setInt(1, id);
            try (java.sql.ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return false;
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        String addSQL = "INSERT INTO user (id) VALUES (?)";
        try (PreparedStatement statement = connection.prepareStatement(addSQL)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
