import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

ProgressBar {
    id: root
    // property bool vertical: false
    property real valueBarWidth: 27
    property real valueBarHeight: 14
    property color highlightColor: "#685496" //Filled part
    property color trackColor: "#F1D3F9" //empty part
    property alias radius: contentItem.radius
    property string text

    default property Item textMask: Item {
        width: valueBarWidth
        height: valueBarHeight
        // BarText {
        //     anchors.centerIn: parent
        //     font: root.font
        //     text: root.text
        // }
    }

    text: Math.round(value * 100) // provide value which is used for text calculations

    font {
        pixelSize: 12
        family: "Quicksand"
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

    /*
    True: As * Am.
    False: As * (1 - Am).
    */

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
