import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

//TODO: link search to this, ensure in layout for size
ListView {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    // highlightMoveDuration: 150

    signal accepted(var item)

    // required property var model

    property var inputText

    // property alias modelIngest: root.model

    model: Hyprland.toplevels

    highlight: HighlightItem {}

    delegate: LauncherDelegate {
        required property var modelData
        iconUrl: Quickshell.iconPath(modelData?.wayland.appId, "image-missing")
        app: TopLevelText {}
    }
}
