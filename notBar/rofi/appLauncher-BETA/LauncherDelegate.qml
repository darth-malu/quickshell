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
    default required property Item app

    required property string iconUrl

    property var command

    property var delegateMD

    property bool isCurrentItem: (parent.currentItem == 0)

    property Item mouseArea: MouseArea

    property string windowTitle

    signal clicked

    function launch_app2unit() {
        // Ensure the command after 'exec' is a single string
        Quickshell.execDetached(["notify-send", `your cmd: "${command}"`]);
        Quickshell.execDetached(["hyprctl", "dispatch", "exec", `[workspace emptym] app2unit -s a "${command}"`]);
    }

    function focustoplevel() {
        let title = root.windowTitle;
        Quickshell.execDetached(["hyprctl", "dispatch", "--", "focuswindow", "title:", `${windowTitle}`]);
    }

    function execute() {
        // if (delegateMD && delegateMD.exec) {
        // Use the 'exec' property from your model data
        // Quickshell.execDetached(["hyprctl", "dispatch", "exec", `[workspace emptym] app2unit -s a "${delegateMD.exec}"`]);
        Quickshell.execDetached(["notify-send", "works"]);

    // }
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
