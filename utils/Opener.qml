pragma Singleton
import Quickshell

Singleton {
    property PersistentProperties properties: PersistentProperties {
        reloadableId: "openerProperties"
        property bool panelRight: false
    }
    function togglePanelRight() {
        properties.panelRight = !properties.panelRight;
    }
}
