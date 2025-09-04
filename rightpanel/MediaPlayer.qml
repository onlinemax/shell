import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import QtQuick.Controls
import qs.utils
import qs.components as Components

ClippingRectangle {
    id: rect
    Layout.preferredHeight: 200
    radius: 25
    color: "transparent"
    border.color: Colors.outline_variant
    border.width: 1
    visible: Mpris.players.values.length != 0
    StackLayout {
        id: layout
        anchors.fill: parent
        Repeater {
            model: Mpris.players
            Item {
                id: container
                required property MprisPlayer modelData
                Component.onCompleted: {
                    img.visible = modelData.trackArtUrl != "";
                    icon.visible = !img.visible;
                    img.source = modelData.trackArtUrl;
                }
                Connections {
                    target: modelData
                    function onTrackArtUrlChanged() {
                        console.log("track changed: ", modelData.trackArtUrl);
                        img.visible = true;
                        img.source = modelData.trackArtUrl;
                        icon.visible = false;
                    }
                }
                Image {
                    id: img
                    anchors.top: parent.top
                    x: 20
                    anchors.topMargin: 10
                    width: parent.width - 40
                    height: sourceSize.width > 0 ? width * sourceSize.height / sourceSize.width : 200
                    cache: false
                    fillMode: Image.PreserveAspectFit
                    visible: true
                }

                Components.ImageColor {
                    id: icon
                    inputAsset: "music_off.svg"
                    color: Colors.on_surface
                    visible: false

                    opacity: 0.1
                    anchors.topMargin: 10
                    sourceSize.width: parent.width - 80
                    width: parent.width - 80
                    x: 40
                    fillMode: Image.PreserveAspectFit
                }

                Slider {
                    id: slider
                    x: 20
                    anchors.top: img.visible ? img.bottom : icon.bottom
                    anchors.topMargin: 20
                    implicitWidth: parent.width - 40
                    implicitHeight: 1
                    contentItem: Rectangle {
                        color: Colors.on_surface
                        implicitHeight: 1
                    }
                    from: 1
                    to: 10
                }
            }
        }
    }
}
