package com.example.demo11.dao;

import com.example.demo11.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public int getUnreadNotificationCount() {
        int count = 0;
        String query = "SELECT COUNT(*) FROM notifications WHERE is_read = 0";
        try (Connection con = DBConnection.getConnection();  // Using the DBConnection utility
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error: " + e.getMessage());
        }
        return count;
    }

    public List<String> getUnreadNotifications() {
        List<String> notifications = new ArrayList<>();
        String query = "SELECT message FROM notifications WHERE is_read = 0 ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                notifications.add(rs.getString("message"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    public void markAllAsRead() {
        String query = "UPDATE notifications SET is_read = 1 WHERE is_read = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addNotification(String message) {
        String query = "INSERT INTO notifications (message) VALUES (?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, message);

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            if (rowsAffected == 0) {
                System.out.println(" No rows inserted!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error: " + e.getMessage());
        }
    }

    public static void UpdateNotification(int Id) {
        String message = "Update UserID: " + Id;

        String query = "INSERT INTO notifications (message) VALUES (?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, message);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}