import QtQuick
import QtQuick.Layouts

// import Quickshell

Rectangle {
    id: root

    Layout.preferredWidth: contentContainer.implicitWidth + 4 // :+8

    Layout.preferredHeight: 20 // 30::

    property Item content

    property Item mouseArea: mouseArea

    property string text

    // property bool dim: false

    property bool underline: false

    property color underlineColor: 'orange'

    property var onClicked: function () {}

    // property int leftPadding
    // property int rightPadding

    property string hoveredBgColor: "#666666"

    color: {
        if (mouseArea.containsMouse)
            return hoveredBgColor;
        return "transparent";
    }

    // color: 'transparent'

    states: [
        State {
            when: mouseArea.containsMouse
            PropertyChanges {
                target: root
                // color: 'white'
            }
        }
    ]

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Item {
        // Contents of the bar block
        id: contentContainer
        implicitWidth: root.content.implicitWidth
        implicitHeight: root.content.implicitHeight
        anchors.centerIn: parent
        children: root.content
    }

    MouseArea {
        id: mouseArea
        anchors.fill: root
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | PointerDevice.Mouse | PointerDevice.TouchPad
        onClicked: root.onClicked()
        propagateComposedEvents: true
    }

    // While line underneath workspace
    Rectangle {
        id: wsLine
        width: root.width
        height: 1

        color: {
            if (root.underline)
                return root.underlineColor;
            return "transparent";
        }
        anchors.bottom: parent.bottom
    }
}
