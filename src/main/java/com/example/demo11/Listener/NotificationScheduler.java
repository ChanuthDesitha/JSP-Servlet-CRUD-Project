package com.example.demo11.Listener;

import com.example.demo11.websocket.NotificationManager;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Timer;
import java.util.TimerTask;

@WebListener
public class NotificationScheduler implements ServletContextListener {

    private final Timer timer = new Timer(true);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                NotificationManager.getInstance().broadcastNotificationCount();
            }
        }, 0, 1000);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        timer.cancel();
    }
}