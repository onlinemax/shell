pragma Singleton
import Quickshell
import QtQuick

Singleton {
    component Dimension: QtObject {
        required property real little
        required property real medium
        required property real big
    }

    readonly property Dimension margin: Dimension {
        little: 5
        medium: 10
        big: 15
    }
    readonly property Dimension icon: Dimension {
        little: 25
        medium: 35
        big: 45
    }

    readonly property Dimension sideSize: Dimension {
        little: 150
        medium: 150
        big: 250
    }
}
