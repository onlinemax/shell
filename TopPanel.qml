pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.bar
import qs.utils
import qs.rightpanel
import qs.entries
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
            x: 0
            y: 0
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
                },
                Region {
                    x: rightPanel.x ?? 0
                    y: rightPanel.y ?? 0
                    width: rightPanel.width ?? 0
                    height: rightPanel.height ?? 0
                    intersection: Intersection.Xor
                },
                Region {
                    x: 0
                    y: 0
                    width: entries.visible ? entries.width : 0
                    height: entries.visible ? entries.height : 0
                    intersection: Intersection.Xor
                }
            ]
        }
        Bar {
            screen: topPanel.modelData
        }
        RightPanel {
            id: rightPanel
            parentHeight: topPanel.modelData.height
            parentWidth: topPanel.modelData.width
            barHeight: 25
        }
        NotificationOverlay {
            id: notifOverlay
            screenWidth: topPanel.modelData.width
            barHeight: 25
        }
        Loader {
            active: Opener.entries
            sourceComponent: Entries {
                id: entries
                barHeight: topPanel.modelData.height
                barWidth: topPanel.modelData.width
            }
        }
    }
}
