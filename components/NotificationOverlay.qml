import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.utils

ColumnLayout {
    id: colLayout
    implicitWidth: 200
    required property real screenWidth
    required property real barHeight
    anchors.right: parent.right
    anchors.topMargin: barHeight + 10
    anchors.rightMargin: 10
    anchors.top: parent.top
    Connections {
        target: NotificationManager
        function onNotification(notif) {
            const url = Quickshell.shellDir + "/components/NotificationWidget.qml";
            const component = Qt.createComponent(url);
            if (component.status == Component.Error) {
                console.error("Error loading component:", component.errorString());
                return;
            }
            const object = component.createObject(colLayout, {
                notification: notif
            });

            object.x = colLayout.screenWidth - (object?.width ?? 0);
            object.y = 25;
        }
    }
}
