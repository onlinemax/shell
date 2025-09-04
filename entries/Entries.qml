pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import qs.utils

PanelWindow {
    id: root
    required property int barHeight
    required property int barWidth
    visible: Opener.entries
    focusable: true
    color: "transparent"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    function closeEntries() {
        searchBar.text = "";
        searchBar.textfieldFocus = false;
        Opener.toggleEntries();
    }

    onVisibleChanged: {
        if (visible) {
            root.focusable = true;
            layout.focus = true;
            searchBar.focus = true;
            searchBar.textfieldFocus = true;
        }
    }
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            const isIn = container.x <= mouseX && mouseX <= container.x + container.width && container.y <= mouseY && mouseY <= container.y + container.width;
            if (!isIn)
                root.closeEntries();
        }
    }

    Rectangle {
        id: container
        color: Colors.surface
        implicitWidth: Math.ceil(root.barWidth / 3)
        implicitHeight: layout.implicitHeight + 2 * 20
        radius: 20
        anchors.centerIn: parent
        focus: true

        Keys.onEscapePressed: {
            root.closeEntries();
        }
        Keys.onTabPressed: view.selectedIndex++
        Keys.onBacktabPressed: view.selectedIndex = Math.max(0, view.selectedIndex - 1)
        Keys.onUpPressed: view.selectedIndex = Math.max(0, view.selectedIndex - 1)
        Keys.onDownPressed: view.selectedIndex++
        Keys.onReturnPressed: {
            view.executeHighlighted();
            root.closeEntries();
        }

        ColumnLayout {
            id: layout
            width: container.width - 2 * 10
            anchors.centerIn: parent
            spacing: 10
            SearchBar {
                id: searchBar
                Layout.preferredHeight: 40
                Layout.fillWidth: true
            }
            EntriesView {
                id: view
                layoutWidth: layout.width
                text: searchBar.text
                Layout.preferredHeight: 300
                Layout.fillWidth: true
                onCloseEntries: {
                    root.closeEntries();
                }
            }
        }
    }
}
