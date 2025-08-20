import QtQuick
import qs.utils

Rectangle {
    readonly property real padding: 10
    implicitHeight: 22
    radius: 11
    implicitWidth: text.width + 2 * padding
    color: Colors.surface
    Text {
        id: text
        color: Colors.on_surface
        text: Time.time
        anchors.centerIn: parent
    }
}
