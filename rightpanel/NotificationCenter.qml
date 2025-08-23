import QtQuick
import QtQuick.Layouts
import qs.utils
import Quickshell.Services.Notifications
import Quickshell

Rectangle {
    color: Colors.surface_container

    ColumnLayout {
        Repeater {
            model: NotificationManager.notifications
            Rectangle {
                required property Notification modelData
                Image {
                    source: Quickshell.iconPath(parent.modelData.appIcon)
                    width: 15
                    height: 15
                }
            }
        }
    }
}
