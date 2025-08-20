import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Image {
    id: root
    required property string inputAsset
    required property string color
    required property string option

    function getOutputAsset(): string {
        return `${inputAsset.replace(".svg", "")}_${color.replace(/#/g, "")}.svg`;
    }
    function updateSource() {
        const command = `${Quickshell.shellDir}/programs/svg-color.sh`;
        Quickshell.execDetached([command, inputAsset, getOutputAsset(), color, option]);
        this.source = Utils.importGeneratedAsset(getOutputAsset());
    }

    onInputAssetChanged: updateSource()
    onColorChanged: updateSource()
    onOptionChanged: updateSource()
    Component.onCompleted: updateSource()
}
