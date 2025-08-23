pragma Singleton
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root
    NotificationServer {
        id: notifServer
        imageSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        actionsSupported: true
        onNotification: notif => {
            notif.tracked = true;
            root.notification(notif);
        }
    }
    property alias notifications: notifServer.trackedNotifications
    signal notification(Notification notification)
}
