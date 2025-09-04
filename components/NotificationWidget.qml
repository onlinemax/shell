import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.utils
import qs.components as Components

WrapperMouseArea {
    id: root
    required property Notification notification
    property real initialX: 0
    property real accumX: 0
    property real thresholdBeforeDelete: 0.30
    property real thresholdSwipe: 1.0

    onNotificationChanged: {
        if (root.notification == null) {
            // sometime this can happen
            destroyAnimation.running = true;
        }
    }
    onPressed: {
        initialX = mouseX;
    }
    onReleased: {
        const percentageSwiped = Math.min(thresholdSwipe, Math.max(-thresholdSwipe, accumX / root.width));
        if (Math.abs(percentageSwiped) > thresholdBeforeDelete) {
            destroySwipeAnimation.goesLeft = percentageSwiped < 0;
            destroySwipeAnimation.running = true;
            return;
        }
        x = 0;
        accumX = 0;
        rect.opacity = 1.0;
    }
    onClicked: {
        if (root.notification.actions.length == 0)
            return;
        root.notification.actions[0].invoke();
        destroyAnimation.running = true;
    }
    onMouseXChanged: {
        accumX += mouseX - initialX;
        const percentageSwiped = Math.abs(Math.min(thresholdSwipe, Math.max(-thresholdSwipe, accumX / root.width)));
        root.x = Math.min(Math.max(accumX, -thresholdSwipe * root.width), thresholdSwipe * root.width);
        rect.opacity = 1.0 - (percentageSwiped > thresholdBeforeDelete ? percentageSwiped : 0);
    }

    ParallelAnimation {
        id: destroyAnimation
        property bool expired: false
        running: false
        NumberAnimation {
            target: rect
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: rect
            property: "implicitHeight"
            to: 0
            duration: 500
            easing.type: Easing.InOutQuad
        }
        onFinished: {
            if (expired && root.notification)
                root.notification.expire();
            else if (root.notification)
                root.notification.dismiss();
            root.destroy();
        }
    }
    SequentialAnimation {
        id: destroySwipeAnimation
        property bool goesLeft: false
        ParallelAnimation {
            alwaysRunToEnd: true
            NumberAnimation {
                target: rect
                property: "opacity"
                to: 0
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: root
                property: "x"
                duration: 500
                to: destroySwipeAnimation.goesLeft ? -root.width : 2 * root.width
                easing.type: Easing.InOutQuad
            }
        }
        NumberAnimation {
            target: rect
            property: "implicitHeight"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }
        onFinished: {
            if (root.notification)
                root.notification.dismiss();
            root.destroy();
        }
    }
    WrapperRectangle {
        id: rect
        clip: true
        implicitWidth: 250
        color: Colors.surface
        margin: 10
        bottomMargin: 20
        radius: 25
        z: 100

        GridLayout {
            id: grid
            rows: 3
            columns: 5
            columnSpacing: 0
            rowSpacing: 0
            Item {
                Layout.row: 0
                Layout.column: 1
                Layout.columnSpan: 5
                Layout.rowSpan: 1
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                Layout.leftMargin: 5
                Layout.rightMargin: 10

                Rectangle {
                    id: timeoutRect
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    anchors.left: parent.left
                    color: Colors.primary
                    Component.onCompleted: animation.running = true
                    NumberAnimation {
                        id: animation
                        running: false
                        target: timeoutRect
                        property: "implicitWidth"
                        duration: {
                            const timeout = root?.notification?.expireTimeout ?? -1;
                            return timeout < 0 ? 10_000 : timeout;
                        }
                        to: 0.5
                        onFinished: {
                            destroyAnimation.expired = true;
                            destroyAnimation.running = true;
                        }
                    }
                }
            }

            Item {
                Layout.row: 1
                Layout.column: 1
                Layout.minimumWidth: 50
                Layout.minimumHeight: 50
                Layout.columnSpan: 1
                Layout.rowSpan: 1
                Image {
                    source: {
                        if (!root || !root.notification) {
                            return "";
                        }

                        return root.notification.image != "" ? root.notification.image : Quickshell.iconPath(root.notification.appIcon);
                    }
                    anchors.fill: parent
                    anchors.margins: 5
                }
            }
            Item {
                Layout.row: 1
                Layout.column: 2
                Layout.fillWidth: true
                Layout.rowSpan: 1
                Layout.columnSpan: 4
                Layout.minimumHeight: 50
                Layout.preferredHeight: summaryText.contentHeight
                clip: true
                Components.Text {
                    id: summaryText
                    anchors.fill: parent
                    anchors.margins: 5
                    text: root?.notification?.summary ?? "" // I need this because when root is destroy else it creates an eror
                    wrapMode: Text.Wrap
                    color: Colors.on_surface
                }
            }
            Item {
                Layout.row: 2
                Layout.column: 1
                Layout.rowSpan: 1
                Layout.columnSpan: 5
                Layout.fillWidth: true
                Layout.preferredHeight: bodyText.contentHeight
                Components.Text {
                    id: bodyText
                    anchors.fill: parent
                    anchors.margins: 5
                    text: root?.notification?.body ?? "" // I need this because when the object is destroy
                    wrapMode: Text.Wrap
                    color: Colors.on_surface
                }
            }
        }
    }
}
