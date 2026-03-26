import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell

Rectangle {
    id: root
    width: parent.width
    height: appName.childrenRect.height + 15
    color: "transparent"

    // default property alias content: appName.data // data is the contents of an instance children list
    default property Item app

    required property string iconUrl

    property bool isCurrentItem: (parent.currentItem == 0)

    property Item mouseArea: MouseArea

    // signal clicked

    property string command

    function launch_app2unit() {
        Quickshell.execDetached(["hyprctl", "dispatch", "--", "exec", `[workspace emptym] app2unit -s a ${command}`]);
        Qt.quit();
    }

    MouseArea {
        id: mouseArea
        anchors.fill: root
        hoverEnabled: true
        onClicked: root.launch_app2unit()
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
        }
    }
}
