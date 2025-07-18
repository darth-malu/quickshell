import Quickshell
import QtQuick

Variants {
    model: Quickshell.screens
    Scope {
        required property ShellScreen modelData
        PanelWindow {
            id: root
            implicitHeight: 20
            color: "transparent"

            readonly property var barWidth: (modelData.width - 16) / 5

            anchors {
                top: true
                right: true
                left: true
            }
            margins {
                top: 8
                right: 8
                left: 8
            }

            Rectangle {
                id: leftBar
                color: "transparent"
                implicitHeight: parent.height
                implicitWidth: root.barWidth
                border.color: "white"
                border.width: 2
                anchors.left: parent.left
            }

            Rectangle {
                id: middleBar
                color: "transparent"
                height: parent.height
                width: root.barWidth
                border.color: "white"
                border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: rightBar
                color: "transparent"
                height: parent.height
                width: root.barWidth
                border.color: "white"
                border.width: 2
                anchors.right: parent.right
            }
        }
    }
}
