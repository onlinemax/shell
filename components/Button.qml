pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import qs.utils
import qs.components as Components

Components.Rectangle {
    id: root
    Component.onCompleted: console.log(width, height)
    enum Size {
        XS,
        SM,
        MD,
        L,
        XL
    }
    enum Shape {
        ROUND,
        SQUARE
    }
    enum Color {
        Elevated,
        Filled,
        Tonal,
        Outlined
    }
    enum Padding {
        BIG,
        SM
    }

    property int size: Button.Size.SM
    property int shape: Button.Shape.ROUND
    property int colorMaterial: Button.Color.Filled
    property int padding: Button.Padding.SM
    property alias icon: iconLoader.sourceComponent
    property bool hovered: false
    property bool pressed: false
    readonly property int spacing: icon ? 5 : 0
    readonly property int extraPad: padding == Button.Padding.SM ? 0 : 8
    required property string label

    property int imageWidth: {
        switch (root.size) {
        case Button.Size.XS:
            return 20;
        case Button.Size.SM:
            return 20;
        case Button.Size.MD:
            return 24;
        case Button.Size.L:
            return 32;
        default:
            return 40;
        }
    }
    signal clicked

    function setIconColor(color: string) {
        if (iconLoader.item.hasOwnProperty("color")) {
            iconLoader.item.color = color;
        }
    }
    radius: root.shape == Button.ROUND ? implicitHeight / 2 : implicitHeight / 4

    implicitHeight: {
        switch (root.size) {
        case Button.Size.XS:
            return 32;
        case Button.Size.SM:
            return 40;
        case Button.Size.MD:
            return 56;
        case Button.Size.L:
            return 96;
        default:
            return 136;
        }
    }
    implicitWidth: {
        return iconLoader.width + spacing + textComponent.implicitWidth + 2 * this.radius + 2 * extraPad;
    }
    color: {
        switch (root.colorMaterial) {
        case Button.Color.Elevated:
            textComponent.color = Colors.primary;
            setIconColor(Colors.primary);
            shadow.blur = 5;
            layer.color = Colors.primary;
            layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
            return Colors.surface_container_low;
        case Button.Color.Filled:
            textComponent.color = Colors.on_primary;
            setIconColor(Colors.on_primary);
            layer.color = Colors.on_primary;
            layer.opacity = (pressed) ? 0.2 : (hovered) ? 0.08 : 0;
            return Colors.primary;
        case Button.Color.Tonal:
            textComponent.color = Colors.on_surface;
            setIconColor(Colors.on_secondary_container);
            layer.color = Colors.on_secondary_container;
            layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
            return Colors.secondary_container;
        case Button.Color.Outlined:
            textComponent.color = Colors.on_surface_variant;
            setIconColor(Colors.on_surface_variant);
            layer.color = Colors.on_surface_variant;
            layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
            root.border.width = 1;
            root.border.color = Colors.outline_variant;
            return "transparent";
        }
    }
    RectangularShadow {
        id: shadow
        anchors.fill: root
        radius: root.radius
        z: root.z - 1
        blur: 0
        color: Colors.shadow
    }
    MouseArea {
        hoverEnabled: true
        anchors.fill: root
        onEntered: {
            root.hovered = true;
        }
        onExited: {
            root.hovered = false;
        }
        onPressed: {
            root.pressed = true;
        }
        onReleased: {
            root.pressed = false;
            root.clicked();
        }
    }
    Loader {
        id: iconLoader
        anchors.left: parent.left
        anchors.leftMargin: root.radius + root.extraPad
        anchors.verticalCenter: parent.verticalCenter
        width: sourceComponent ? root.imageWidth : 0
        height: width
    }
    Components.Text {
        id: textComponent
        anchors.right: parent.right
        anchors.rightMargin: root.radius + root.extraPad
        anchors.verticalCenter: parent.verticalCenter
        text: parent.label
        font.pixelSize: 14
        font.weight: 500
        font.family: "Roboto"
    }
    Rectangle {
        id: layer
        anchors.fill: parent
        z: root.z + 1
        opacity: 0
        radius: root.radius
    }
}
