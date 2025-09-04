pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import qs.utils
import qs.components as Components

Rectangle {
    id: root
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
        }
    }
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

    property bool toggled: false
    property int size: ToggleButton.Size.SM
    property int shape: ToggleButton.Shape.ROUND
    property int colorMaterial: ToggleButton.Color.Filled
    property int padding: ToggleButton.Padding.SM
    property alias toggleIcon: toggleIconLoader.sourceComponent
    property alias untoggleIcon: untoggleIconLoader.sourceComponent
    property bool hovered: false
    property bool pressed: false
    readonly property int extraPad: padding == ToggleButton.Padding.SM ? 0 : 8
    required property string toggledLabel
    required property string untoggledLabel
    signal toggle(bool value)
    readonly property int spacing: toggled ? (toggleIcon ? 5 : 0) : (untoggleIcon ? 5 : 0)

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

    function setToggleIconColor(color: string) {
        if (toggleIconLoader.item && toggleIconLoader.item.hasOwnProperty("color"))
            toggleIconLoader.item.color = color;
    }

    function setUntoggleIconColor(color: string) {
        if (untoggleIconLoader.item && untoggleIconLoader.item.hasOwnProperty("color"))
            untoggleIconLoader.item.color = color;
    }

    radius: root.shape == ToggleButton.ROUND ? implicitHeight / 2 : implicitHeight / 4

    implicitHeight: {
        switch (root.size) {
        case ToggleButton.Size.XS:
            return 32;
        case ToggleButton.Size.SM:
            return 40;
        case ToggleButton.Size.MD:
            return 56;
        case ToggleButton.Size.L:
            return 96;
        case ToggleButton.Size.XL:
            return 136;
        }
    }
    implicitWidth: {
        return (toggled ? toggleIconLoader.width : untoggleIconLoader.width) + spacing + textComponent.implicitWidth + 2 * this.radius + 2 * extraPad;
    }
    color: {
        switch (root.colorMaterial) {
        case ToggleButton.Color.Elevated:
            shadow.blur = 5;
            layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
            if (toggled) {
                textComponent.color = Colors.on_primary;
                setToggleIconColor(Colors.on_primary);
                layer.color = Colors.on_primary;
                return Colors.primary;
            }
            textComponent.color = Colors.primary;
            setUntoggleIconColor(Colors.primary);
            layer.color = Colors.primary;
            return Colors.surface_container_low;
        case ToggleButton.Color.Filled:
            layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
            if (toggled) {
                textComponent.color = Colors.on_primary;
                setToggleIconColor(Colors.on_primary);
                layer.color = Colors.on_primary;
                return Colors.primary;
            }
            textComponent.color = Colors.on_surface_variant;
            setUntoggleIconColor(Colors.on_surface_variant);
            layer.color = Colors.primary;
            return Colors.surface_container;
        case ToggleButton.Color.Tonal:
            layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
            if (toggled) {
                textComponent.color = Colors.on_primary;
                setToggleIconColor(Colors.on_primary);
                layer.color = Colors.on_primary;
                return Colors.secondary;
            }
            textComponent.color = Colors.on_secondary_container;
            setUntoggleIconColor(Colors.on_secondary_container);
            layer.color = Colors.on_secondary_container;
            return Colors.secondary_container;
        case ToggleButton.Color.Outlined:
            layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
            if (toggled) {
                textComponent.color = Colors.inverse_on_surface;
                setToggleIconColor(Colors.inverse_on_surface);
                layer.color = Colors.inverse_on_surface;
                border.color = Colors.inverse_surface;
                return Colors.inverse_surface;
            }
            border.width = 1;
            textComponent.color = Colors.on_surface_variant;
            setUntoggleIconColor(Colors.on_surface_variant);
            layer.color = Colors.on_surface_variant;
            border.color = Colors.on_surface_variant;
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
            root.toggled = !root.toggled;
            root.toggle(root.toggled);
        }
    }
    Loader {
        id: toggleIconLoader
        visible: root.toggled
        active: root.toggled
        anchors.left: parent.left
        anchors.leftMargin: root.radius + root.extraPad
        anchors.verticalCenter: parent.verticalCenter
        width: sourceComponent ? root.imageWidth : 0
        height: width
    }

    Loader {
        id: untoggleIconLoader
        visible: !root.toggled
        active: !root.toggled
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
        text: root.toggled ? root.toggledLabel : root.untoggledLabel
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
