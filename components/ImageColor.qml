import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Image {
    id: root
    required property string inputAsset
    property string color: "white"
    property string option: "stroke"

    function getOutputAsset(): string {
        return `${inputAsset.replace(".svg", "")}_${color.replace(/#/g, "")}.svg`;
    }
    function updateSource() {
        commandProcess.running = true;
    }
    Process {
        id: commandProcess
        running: true
        readonly property string commandUrl: `${Quickshell.shellDir}/programs/svg-color.sh`
        command: [commandUrl, root.inputAsset, root.getOutputAsset(), root.color, root.option]
        stdout: StdioCollector {
            onStreamFinished: root.source = Utils.importGeneratedAsset(root.getOutputAsset())
        }
    }

    onInputAssetChanged: updateSource()
    onColorChanged: updateSource()
    onOptionChanged: updateSource()
}
