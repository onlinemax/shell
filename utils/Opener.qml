pragma Singleton
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root
    PersistentProperties {
        id: properties
        property bool panelRight: false
        property bool entries: false
        reloadableId: "openerProperties"
    }
    property alias panelRight: properties.panelRight
    property alias entries: properties.entries

    function togglePanelRight() {
        properties.panelRight = !properties.panelRight;
    }
    function toggleEntries() {
        properties.entries = !properties.entries;
    }

    GlobalShortcut {
        appid: "shell"
        name: "openentries"
        onPressed: {
            root.toggleEntries();
        }
    }
}
