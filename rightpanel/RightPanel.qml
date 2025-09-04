import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.utils
import qs.components as Components

WrapperRectangle {
    id: root
    required property real parentHeight
    required property real parentWidth
    required property real barHeight
    x: Opener.panelRight ? parentWidth - width - PanelAppeareance.margin.medium : parentWidth
    y: barHeight + PanelAppeareance.margin.medium
    implicitWidth: PanelAppeareance.sideSize.big
    implicitHeight: parentHeight - barHeight - 2 * PanelAppeareance.margin.medium
    color: Colors.surface
    radius: PanelAppeareance.margin.medium
    visible: root.x != root.parentWidth
    margin: PanelAppeareance.margin.little

    ColumnLayout {
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Components.Text {
                text: "Side Panel"
                color: Colors.on_surface
                font.pointSize: 14
            }
            Item {
                Layout.fillWidth: true
            }
            Components.IconButton {
                size: Components.IconButton.Size.XS
                colorMaterial: Components.IconButton.Color.Standard
                icon: Components.ImageColor {
                    inputAsset: "close.svg"
                }
                onClicked: Opener.togglePanelRight()
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.topMargin: -15
            color: Colors.outline
        }
        MediaPlayer {
            Layout.fillWidth: true
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
