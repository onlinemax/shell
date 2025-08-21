import Quickshell
import QtQuick
import qs.utils

PopupWindow {
    required property real screenHeight
    required property real screenWidth
    required property real barHeight
    anchor.rect.x: 0 //parentWindow.width - width
    anchor.rect.y: barHeight + PanelAppeareance.margin.medium

    width: PanelAppeareance.sideSize.big
    height: screenHeight - barHeight - 2 * PanelAppeareance.margin.medium
    visible: anchor.rect.x != 0
}
