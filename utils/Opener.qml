pragma Singleton
import Quickshell

Singleton {
    property PersistentProperties properties: PersistentProperties {
        reloadableId: "openerProperties"
        property bool panelRight: true
        onReloaded: {
            console.log("We just reload");
        }
    }
    function togglePanelRight() {
        properties.panelRight = !properties.panelRight;
    }
}
