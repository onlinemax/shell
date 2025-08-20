import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.utils

WrapperRectangle {
    id: root
    readonly property real padding: 5
    implicitHeight: 22
    radius: 11
    color: Colors.surface
    leftMargin: 10
    rightMargin: 10
    RowLayout {
        id: layout
        spacing: 5
        implicitWidth: children.length * 15 + (children.length - 1) * spacing
        Repeater {
            model: SystemTray.items.values
            delegate: WrapperRectangle {
                id: wrapper
                required property SystemTrayItem modelData
                margin: 2
                radius: 9
                color: "transparent"
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
                child: IconImage {
                    id: icon
                    source: wrapper.modelData.icon
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: () => {
                            wrapper.modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
