import QtQuick
import qs.utils

Rectangle {
    id: root
    enum Size {
        XS,
        SM,
        MD,
        L,
        XL
    }
    enum Shape {
        Round,
        Square
    }
    enum Color {
        Filled,
        Tonal,
        Outlined,
        Standard
    }
    enum Width {
        Default,
        Narrow,
        Wide
    }

    property int size: IconButton.Size.SM
    property int shape: IconButton.Shape.Round
    property int colorMaterial: IconButton.Color.Filled
    property int widthMaterial: IconButton.Width.Default
    property alias icon: iconLoader.sourceComponent
    property bool hovered: false
    property bool pressed: false
    signal clicked

    function setIconColor(color: string) {
        if (iconLoader.item && iconLoader.item.hasOwnProperty("color"))
            iconLoader.item.color = color;
    }

    radius: implicitHeight / (shape == IconButton.Shape.Round ? 2 : 4)

    implicitHeight: {
        switch (size) {
        case IconButton.Size.XS:
            return 32;
        case IconButton.Size.SM:
            return 40;
        case IconButton.Size.MD:
            return 56;
        case IconButton.Size.L:
            return 96;
        case IconButton.Size.XL:
            return 136;
        }
    }

    implicitWidth: {
        if (widthMaterial == IconButton.Width.Default) {
            return implicitHeight;
        }
        switch (size) {
        case IconButton.Size.XS:
            return widthMaterial == IconButton.Width.Narrow ? 28 : 40;
        case IconButton.Size.SM:
            return widthMaterial == IconButton.Width.Narrow ? 32 : 52;
        case IconButton.Size.MD:
            return widthMaterial == IconButton.Width.Narrow ? 48 : 72;
        case IconButton.Size.L:
            return widthMaterial == IconButton.Width.Narrow ? 64 : 128;
        case IconButton.Size.XL:
            return widthMaterial == IconButton.Width.Narrow ? 104 : 184;
        }
    }

    property int iconWidth: {
        switch (size) {
        case IconButton.Size.XS:
            return 20;
        case IconButton.Size.SM:
            return 24;
        case IconButton.Size.MD:
            return 24;
        case IconButton.Size.L:
            return 32;
        case IconButton.Size.XL:
            return 40;
        }
    }

    color: {
        layer.opacity = (pressed) ? 0.1 : (hovered) ? 0.08 : 0;
        switch (colorMaterial) {
        case IconButton.Color.Filled:
            setIconColor(Colors.on_primary);
            layer.color = Colors.on_primary;
            return Colors.primary;
        case IconButton.Color.Tonal:
            setIconColor(Colors.on_secondary_container);
            layer.color = Colors.on_secondary_container;
            return Colors.secondary_container;
        case IconButton.Color.Outlined:
            border.width = 1;
            border.color = Colors.outline_variant;
            setIconColor(Colors.on_surface_variant);
            layer.color = Colors.on_secondary_container;
            return "transparent";
        case IconButton.Color.Standard:
            setIconColor(Colors.on_surface_variant);
            layer.color = Colors.on_secondary_container;
            return "transparent";
        }
    }

    MouseArea {
        anchors.fill: root
        hoverEnabled: true
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
    Rectangle {
        id: layer
        anchors.fill: root
        radius: root.radius
        opacity: 0
    }
    Loader {
        id: iconLoader
        anchors.centerIn: parent
        width: root.iconWidth
        height: root.iconWidth
    }
}
