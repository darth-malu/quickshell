import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: root

    required property SystemTrayItem modelData
    required property int index

    implicitWidth: 16
    implicitHeight: 16

    Popup {
        id: trayMenuPopup
        y: root.y + root.height
        width: children[0].width
        height: children[0].height
        modal: true
        focus: true

        TrayItemMenu {
            anchors.fill: parent
            trayMenu: QsMenuOpener { menu: modelData.menu }
        }
    }

    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent

        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                modelData.activate();
            } else if (event.button === Qt.RightButton) {
                trayMenuPopup.open();
            }
        }
    }

    IconImage {
        id: icon
        anchors.fill: parent
        asynchronous: true
        source: {
            let icon = root.modelData.icon;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
        }
    }
}