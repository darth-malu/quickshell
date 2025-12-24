import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

// TODO why this does not change color
ProgressBar {
    id: root
    // property bool vertical: false
    property real valueBarWidth: 30
    property real valueBarHeight: 15
    property color highlightColor: "#685496" //Filled part
    property color trackColor: "#F1D3F9" //empty part
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

    text: Math.round(value * 100) // value here is the percentage from battery

    font {
        pixelSize: 12
        family: "Quicksand medium"
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
            // width: parent.width * root.visualPosition
            width: parent.width * root.visualPosition // TODO see hwo visualPosition works
            height: parent.height
            radius: 12
            color: root.highlightColor
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: undefined
            }
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
