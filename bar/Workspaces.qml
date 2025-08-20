import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.components
import qs.utils

Rectangle {
    id: root
    readonly property real padding: 10
    color: Colors.surface
    implicitHeight: 22
    radius: 10
    implicitWidth: layout.width + padding * 2
    function getWorkspaces() {
        let max = 1;
        const accum = [];
        let focusedWindow = -1;
        let urgentWindows = new Set();
        Hyprland.workspaces.values.forEach(workspace => {
            max = Math.max(max, workspace.id);
            focusedWindow = workspace.focused ? workspace.id : focusedWindow;
            if (workspace.urgent)
                urgentWindows.add(workspace.id);
        });

        for (let i = 1; i <= max; i++) {
            accum.push({
                focused: focusedWindow == i,
                id: i,
                urgent: urgentWindows.has(i)
            });
        }
        return accum;
    }

    RowLayout {
        id: layout
        spacing: 10
        anchors.centerIn: parent
        Repeater {
            model: root.getWorkspaces()
            HyprlandWorkspaceButton {
                required property var modelData
                workspaceId: modelData.id
                focused: modelData.focused
                urgent: modelData.urgent
            }
        }
    }

    WheelHandler {
        onWheel: evt => {
            console.log("Are you scrolling");
        }
    }
}
