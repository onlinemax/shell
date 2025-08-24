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
    property bool toggled: false
    property alias toggleIcon: toggleIconLoader.sourceComponent
    property alias untoggleIcon: untoggleIconLoader.sourceComponent
    property bool hovered: false
    property bool pressed: false
    signal toggle(bool value)

    function setToggleIconColor(color: string) {
        if (toggleIconLoader.item && toggleIconLoader.item.hasOwnProperty("color"))
            toggleIconLoader.item.color = color;
    }

    function setUntoggleIconColor(color: string) {
        if (untoggleIconLoader.item && untoggleIconLoader.item.hasOwnProperty("color"))
            untoggleIconLoader.item.color = color;
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
            if (toggled) {
                setToggleIconColor(Colors.on_primary);
                layer.color = Colors.on_primary;
                return Colors.primary;
            }
            setUntoggleIconColor(Colors.on_surface_variant);
            layer.color = Colors.on_primary;
            return Colors.surface_container;
        case IconButton.Color.Tonal:
            if (toggled) {
                setToggleIconColor(Colors.on_secondary);
                layer.color = Colors.on_secondary;
                return Colors.secondary;
            }
            setUntoggleIconColor(Colors.on_secondary_container);
            layer.color = Colors.on_secondary_container;
            return Colors.secondary_container;
        case IconButton.Color.Outlined:
            if (toggled) {
                border.width = 0;
                border.color = Colors.outline_variant;
                setToggleIconColor(Colors.inverse_on_surface);
                return Colors.inverse_surface;
            }
            border.width = 1;
            border.color = Colors.outline_variant;
            setUntoggleIconColor(Colors.on_surface_variant);
            layer.color = Colors.on_surface_variant;
            return "transparent";
        case IconButton.Color.Standard:
            if (toggled) {
                setToggleIconColor(Colors.primary);
                layer.color = Colors.primary;
                return "transparent";
            }
            setUntoggleIconColor(Colors.on_surface_variant);
            layer.color = Colors.on_surface_variant;
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
            root.toggled = !root.toggled;
            root.toggle(root.toggled);
        }
    }
    Rectangle {
        id: layer
        anchors.fill: root
        radius: root.radius
        opacity: 0
    }

    Loader {
        id: toggleIconLoader
        anchors.centerIn: parent
        visible: root.toggled
        active: root.toggled
        width: root.iconWidth
        height: root.iconWidth
    }
    Loader {
        id: untoggleIconLoader
        visible: !root.toggled
        active: !root.toggled
        anchors.centerIn: parent
        width: root.iconWidth
        height: root.iconWidth
    }
}
