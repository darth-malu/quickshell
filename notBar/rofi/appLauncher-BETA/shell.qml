import QtQuick
import Quickshell

Rofi {
    content: LauncherListView {}
    delegateIngest: LauncherDelegate {
        required property var modelData
        delegateMD: modelData
        iconUrl: Quickshell.iconPath(modelData.icon, "image-missing")
        app: Text {
            id: modelText
            text: modelData.name
            color: Qt.rgba(196 / 255, 203 / 255, 212 / 255, 1)
            font {
                pointSize: 11
                family: "Mononoki Nerd Font"
            }
        }
    }
}
