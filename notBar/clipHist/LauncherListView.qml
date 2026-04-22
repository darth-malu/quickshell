import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

ListView {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    highlightMoveDuration: 150

    // Properties for customization
    property color accentColor: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)

    signal accepted(var item)

    required property var model

    required property var inputText

    model: {
        if (root.inputText.text === "")
            return Hyprland.toplevels;
        const searchLower = root.inputText.text.toLowerCase();
        return Hyprland.toplevels.values.filter(window => window.wayland.title.toLowerCase().includes(searchLower));
    }

    highlight: Item {
        ClippingRectangle {
            anchors.fill: parent
            color: Qt.rgba(72 / 255, 191 / 255, 227 / 255, 0.2)
            radius: 2

            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: 2
                color: root.accentColor
                radius: 5
            }
            Rectangle {
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                width: 2
                color: root.accentColor
                radius: 5
            }
        }
    }

    delegate: LauncherEntry {
        width: root.width
        readonly property var entry: modelData

        iconUrl: Quickshell.iconPath(modelData?.wayland.appId, "image-missing")

        app: Text {
            text: entry.wayland ? entry.wayland.title : entry.title
            color: "#C4CBD4"
            font {
                pointSize: 11
                family: "Mononoki Nerd Font"
            }
        }

        // onClicked: root.accepted(entry)
        // TODO make this wayland.activate
        onClicked: entry.wayland.activate()
    }
}
