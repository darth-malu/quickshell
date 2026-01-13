import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    Layout.preferredWidth: contentContainer.implicitWidth + 4 // :+8

    Layout.preferredHeight: contentContainer.implicitHeight // 30::

    radius: 10

    property Item content

    property Item mouseArea: mouseArea

    property string text

    property bool dim: false

    property bool underline: false

    property color underlineColor: 'orange'

    signal clicked

    property string hoveredBgColor: "#666666"

    color: {
        if (mouseArea.containsMouse)
            return hoveredBgColor;
        return "transparent";
    }

    // color: "transparent"

    // states: [
    //     State {
    //         when: mouseArea.containsMouse
    //         PropertyChanges {
    //             target: root
    //         }
    //     }
    // ]

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Item {
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
        onClicked: root.clicked()
        // propagateComposedEvents: true
    }

    // While line underneath workspace
    Rectangle {
        id: wsLine
        width: root.width
        radius: 12
        height: 0.1

        color: {
            if (root.underline)
                return root.underlineColor;
            return "transparent";
        }
        anchors.top: parent.top
    }
}
