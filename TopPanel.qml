import Quickshell
import QtQuick
import qs.bar
import qs.rightpanel
import qs.utils
import qs.components

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: topPanel
        required property ShellScreen modelData
        color: "transparent"
        anchors {
            left: true
            right: true
            bottom: true
            top: true
        }
        exclusionMode: ExclusionMode.Ignore

        mask: Region {
            x: topPanel.x ?? 0 // this is to supress warnings
            y: topPanel.y ?? 0 // this is to supress warnings
            width: topPanel.width
            height: topPanel.height
            intersection: Intersection.Xor
            regions: [
                Region {
                    x: notifOverlay.x
                    y: notifOverlay.y
                    width: notifOverlay.width
                    height: notifOverlay.height
                    intersection: Intersection.Xor
                }
            ]
        }
        Bar {
            screen: modelData
        }
        RightPanel {
            parentHeight: topPanel.height
            parentWidth: topPanel.width
            barHeight: 25
        }
        NotificationOverlay {
            id: notifOverlay
            screenWidth: topPanel.modelData.width
            barHeight: 25
        }
    }
}
