import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import qs.utils
import qs.components

WrapperRectangle {
    id: root
    required property real parentHeight
    required property real parentWidth
    required property real barHeight
    x: Opener.properties.panelRight ? parentWidth - width - PanelAppeareance.margin.medium : parentWidth
    y: barHeight + PanelAppeareance.margin.medium
    implicitWidth: PanelAppeareance.sideSize.big
    implicitHeight: parentHeight - barHeight - 2 * PanelAppeareance.margin.medium
    color: Colors.surface
    radius: PanelAppeareance.margin.medium
    visible: root.x != root.parentWidth
    margin: PanelAppeareance.margin.little

    ColumnLayout {
        WrapperRectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            margin: 10
            color: Colors.surface_container
            RowLayout {
                spacing: 10
                Item {
                    Layout.fillWidth: true
                }
                ToggleIconButton {
                    size: IconButton.Size.XS
                    colorMaterial: IconButton.Color.Filled
                    widthMaterial: IconButton.Width.Narrow
                    toggleIcon: ImageColor {
                        inputAsset: "wifi_4.svg"
                    }
                    untoggleIcon: ImageColor {
                        inputAsset: "nowifi.svg"
                    }
                }
                ToggleIconButton {
                    colorMaterial: IconButton.Color.Filled
                    widthMaterial: IconButton.Width.Narrow

                    size: IconButton.Size.XS
                    toggleIcon: ImageColor {
                        inputAsset: "bluetooth.svg"
                    }
                    untoggleIcon: ImageColor {
                        inputAsset: "bluetooth_off.svg"
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }

    Behavior on x {
        NumberAnimation {
            duration: 300
        }
    }
}
