package com.example.demo11.websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

import java.io.IOException;

@ServerEndpoint("/notifications")
public class NotificationWebSocket {
    private Session session;

    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        NotificationManager.getInstance().addClient(this);
    }

    @OnClose
    public void onClose() {
        NotificationManager.getInstance().removeClient(this);
    }

    public void sendNotification(String message) throws IOException {
        if (session != null && session.isOpen()) {
            session.getBasicRemote().sendText(message);
        }
    }
}
