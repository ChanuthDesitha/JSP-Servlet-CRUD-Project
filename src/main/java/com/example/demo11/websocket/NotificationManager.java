package com.example.demo11.websocket;

import com.example.demo11.dao.NotificationDAO;

import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

public class NotificationManager {
    private static final NotificationManager INSTANCE = new NotificationManager();
    private final Set<NotificationWebSocket> clients = new CopyOnWriteArraySet<>();

    private NotificationManager() {}

    public static NotificationManager getInstance() {
        return INSTANCE;
    }

    public void addClient(NotificationWebSocket client) {
        clients.add(client);
    }

    public void removeClient(NotificationWebSocket client) {
        clients.remove(client);
    }

    public void broadcastNotification(String message) {
        for (NotificationWebSocket client : clients) {
            try {
                client.sendNotification(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void broadcastNotificationCount() {
        int unreadCount = new NotificationDAO().getUnreadNotificationCount();
        broadcastNotification("Unread Notifications: " + unreadCount);
    }
}
