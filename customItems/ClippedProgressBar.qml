import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

/**
 * A progress bar with both ends rounded and text acts as clipping like OneUI 7's battery indicator.
 */
ProgressBar {
    id: root
    property bool vertical: false
    property real valueBarWidth: 30
    property real valueBarHeight: 18
    property color highlightColor: "red" ?? "#685496"
    property color trackColor: "green" ?? "#F1D3F9"
    property alias radius: contentItem.radius
    property string text
    default property Item textMask: Item {
        width: valueBarWidth
        height: valueBarHeight
        BarText {
            anchors.centerIn: parent
            font: root.font
            text: root.text
        }
    }

    text: Math.round(value * 100)
    font {
        pixelSize: 13
        weight: text.length > 2 ? Font.Medium : Font.DemiBold
    }

    background: Item {
        implicitHeight: valueBarHeight
        implicitWidth: valueBarWidth
    }

    contentItem: Rectangle {
        id: contentItem
        anchors.fill: parent
        radius: 9999
        color: root.trackColor
        visible: false

        Rectangle {
            id: progressFill
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: undefined
            }
            width: parent.width * root.visualPosition
            height: parent.height

            states: State {
                name: "vertical"
                when: root.vertical
                AnchorChanges {
                    target: progressFill
                    anchors {
                        top: undefined
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                }
                PropertyChanges {
                    target: progressFill
                    width: parent.width
                    height: parent.height * root.visualPosition
                }
            }

            radius: Appearance.rounding.unsharpen
            color: root.highlightColor
        }
    }

    OpacityMask {
        id: roundingMask
        visible: false
        anchors.fill: parent
        source: contentItem
        maskSource: Rectangle {
            width: contentItem.width
            height: contentItem.height
            radius: contentItem.radius
        }
    }

    OpacityMask {
        anchors.fill: parent
        source: roundingMask
        invert: true
        maskSource: root.textMask
    }
}
