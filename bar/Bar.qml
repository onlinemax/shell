import Quickshell

Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
        required property ShellScreen modelData
        screen: modelData
        color: "transparent"
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 25

        Workspaces {
            id: workspaces
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
        }
        WorkspaceInfo {
            anchors.left: workspaces.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 2
        }

        TimeWidget {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        SysTray {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: utilities.left
            anchors.rightMargin: 10
        }
        Utilities {
            id: utilities
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }
    }
}
