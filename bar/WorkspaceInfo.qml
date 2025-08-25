import QtQuick
import QtQml
import Quickshell.Hyprland
import qs.utils
import qs.components as Components
import Quickshell.Io
import Quickshell.Services.Pipewire

Components.Rectangle {
    id: root
    readonly property real padding: 5
    implicitHeight: 22
    implicitWidth: text.width + padding * 4 + (logo.visible ? logo.width : 0)
    color: Colors.surface
    visible: text.text != "undefined"

    Connections {
        target: Hyprland
        function onRawEvent(evt: HyprlandEvent) {
            if (evt.name.endsWith("v2")) {
                infoProcess.running = true;
            }
        }
    }

    function deleteBefore(origin: string, search: string): string {
        const index = origin.indexOf(search);
        return (index == -1) ? origin : origin.substring(index + search.length);
    }

    function deleteAfter(origin: string, search: string): string {
        const index = origin.indexOf(search);
        return (index == -1) ? origin : origin.substring(0, index);
    }

    function update(window) {
        let title = "";
        let sourceImg = "";
        if (window.class == "vesktop")
            title = "\uf1ff" + "  " + deleteBefore(window.title, "Discord |");
        else if (window.class == "brave-browser") {
            title = deleteAfter(window.title, "- Brave").trim();
            sourceImg = Utils.importAsset("brave.png");
        } else if (window.class == "Alacritty" && window.title.startsWith("nvim")) {
            title = '<font color="#599735">\uf36f</font>' + "&nbsp;";
            title += deleteBefore(window.title, "nvim");
        } else if (window.class == "Alacritty") {
            // change max for your login name if you're on arch linux
            title = deleteBefore(window.title, "max@archlinux:");
            sourceImg = Utils.importAsset("alacritty.png");
        } else {
            title = window.title;
        }

        text.text = Utils.elispsalize(title, 40);
        logo.source = sourceImg;
    }

    Process {
        id: infoProcess
        running: true
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.update(JSON.parse(this.text));
            }
        }
    }

    Image {
        id: logo
        visible: source != ""
        source: ""
        width: 15
        height: width
        anchors.leftMargin: 10
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Components.Text {
        id: text
        anchors.left: logo.visible ? logo.right : parent.left
        anchors.leftMargin: 10 / (logo.visible ? 2 : 1)
        anchors.verticalCenter: parent.verticalCenter
        color: Colors.on_surface

        PwObjectTracker {
            objects: [Pipewire.defaultAudioSink]
        }
    }
}
