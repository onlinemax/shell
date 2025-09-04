pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.utils

ListView {
    id: root
    required property real layoutWidth
    required property string text
    property int selectedIndex: 0
    readonly property var filteredEntries: {
        const entries = Utils.filterDesktopEntries(DesktopEntries.applications.values, text).filter(e => e != null);
        if (calcEntry.entry != null) {
            entries.push(calcEntry.entry);
        }
        return entries;
    }
    function executeHighlighted() {
        filteredEntries[currentIndex].execute();
        root.closeEntries();
    }
    signal closeEntries
    clip: true
    model: filteredEntries
    currentIndex: {
        const index = Math.max(0, Math.min(selectedIndex, filteredEntries.length - 1));
        selectedIndex = index;
        index;
    }
    highlight: Rectangle {
        color: Colors.surface_bright
    }
    CalculatorEntry {
        id: calcEntry
        text: root.text
    }
    delegate: Rectangle {
        id: entryContainer
        required property DesktopEntry modelData
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.layoutWidth - 20
        height: 30
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.closeEntries();
                modelData.execute();
            }
            onEntered: {
                color = Colors.surface_bright;
            }
            onExited: {
                color = 'transparent';
            }
        }
        RowLayout {
            anchors.fill: parent
            spacing: 20
            Image {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                sourceSize.width: 20
                sourceSize.height: 20
                source: Quickshell.iconPath(entryContainer.modelData.icon, "")
            }
            Text {
                text: `${entryContainer.modelData.name} ${entryContainer.modelData.genericName != "" ? `(${entryContainer.modelData.genericName})` : ""}`
                color: Colors.on_surface
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }
}
