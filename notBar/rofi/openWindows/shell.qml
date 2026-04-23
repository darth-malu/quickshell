import QtQuick
import Quickshell.Hyprland
import Quickshell

Rofi {
    content: LauncherListView {}
    modelIngest: Hyprland.toplevels
    delegateIngest: LauncherDelegate {
        required property var modelData
        iconUrl: Quickshell.iconPath(modelData?.wayland.appId, "image-missing")
        app: TopLevelText {}
    }
}
