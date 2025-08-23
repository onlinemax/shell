import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.utils

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
        NotificationCenter {
            Layout.fillWidth: true
            Layout.preferredHeight: PanelAppeareance.sideSize.big
            radius: PanelAppeareance.margin.little
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
