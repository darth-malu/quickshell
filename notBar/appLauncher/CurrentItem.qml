import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Rectangle {
    id: root
    width: parent.width
    height: appName.childrenRect.height + 15
    // height: 50
    // margin: 10
    color: "transparent"

    // default property alias content: appName.data // data is the contents of an instance children list
    default property Item app

    property string iconUrl

    property bool isCurrentItem: (parent.currentItem == 0)

    property Item mouseArea: MouseArea

    signal clicked

    MouseArea {
        id: mouseArea
        anchors.fill: root
        hoverEnabled: true
        onClicked: root.clicked()
        acceptedButtons: Qt.LeftButton | PointerDevice.Mouse | PointerDevice.TouchPad
    }

    RowLayout {
        anchors.verticalCenter: root.verticalCenter
        spacing: 20

        IconImage {
            id: appIcon
            source: root.iconUrl
            implicitSize: 18
            asynchronous: true
            Layout.leftMargin: 10
        }

        Item {
            id: appName
            Layout.fillHeight: true // Centers text lol
            children: root.app
            // onChildrenChanged: {
            //     for (var i = 0; i < children.length; i++) {
            //         children[i].anchors.verticalCenter = contentContainer.verticalCenter;
            //         // children[i].x = 10; // Left padding
            //     }
            // }
        }
    }
}
