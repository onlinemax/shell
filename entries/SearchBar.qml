import QtQuick
import QtQuick.Controls
import qs.utils
import qs.components as Components

Rectangle {
    id: root
    color: Colors.surface_container_high
    radius: 20
    property alias text: textfield.text
    property alias textfieldFocus: textfield.focus
    Components.ImageColor {
        id: searchIcon
        width: 20
        height: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        inputAsset: "search.svg"
        color: Colors.on_surface_variant
    }
    TextField {
        id: textfield
        implicitHeight: 40
        anchors.left: searchIcon.right
        anchors.right: clearButton.visible ? clearButton.left : parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 5
        color: Colors.on_surface
        maximumLength: 40
        font.family: "Roboto"
        font.pixelSize: 16
        placeholderText: "Search Applications"
        placeholderTextColor: Colors.on_surface_variant
        background: Item {}
    }
    Components.IconButton {
        id: clearButton
        visible: textfield.displayText != ""
        anchors.right: parent.right
        size: Components.IconButton.Size.XS
        anchors.verticalCenter: parent.verticalCenter
        colorMaterial: Components.IconButton.Color.Standard
        anchors.rightMargin: 10
        icon: Components.ImageColor {
            inputAsset: "close.svg"
        }
        onClicked: {
            textfield.text = "";
        }
    }
}
