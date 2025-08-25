import QtQuick
import Quickshell.Hyprland
import qs.utils
import qs.components as Components

Rectangle {
    id: root
    required property int workspaceId
    required property bool focused
    required property bool urgent
    implicitHeight: 18
    implicitWidth: 18

    border.color: focused ? Colors.primary : Colors.outline_variant
    border.width: 1

    radius: 9
    color: focused ? Colors.primary_container : urgent ? Colors.error : 'transparent'
    Components.Text {
        text: root.workspaceId
        anchors.centerIn: parent
        color: root.focused ? Colors.on_primary_container : root.urgent ? Colors.on_error : Colors.on_surface
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch(`workspace ${root.workspaceId}`)
    }
}
