import QtQuick
import qs.utils
import qs.components as Components

Rectangle {
    readonly property real padding: 10
    implicitHeight: 22
    radius: 11
    implicitWidth: text.width + 2 * padding
    color: Colors.surface
    Components.Text {
        id: text
        color: Colors.on_surface
        text: Time.time
        anchors.centerIn: parent
    }
}
