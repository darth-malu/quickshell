import QtQuick
import qs.services
import qs.themes
import Quickshell.Hyprland
import QtQuick.Layouts

RowLayout {
    spacing: 30
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    Repeater {
        id: repa
        model: WorkspaceService.workspaces

        Rectangle {
            id: circleBackground
            visible: isMonitorFocused

            property color activeWorkspaceIdColor: Themes.activeWorkspaceIdColor
            property color inactiveTextColor: Themes.inactiveTextColor
            property color activeWorkspaceColor: Themes.activeWorkspaceColor
            property color currentMonitorNotActiveColor: Themes.currentMonitorNotActiveColor

            readonly property bool isActiveOnMonitor: modelData.id === modelData.monitor.activeWorkspace.id
            readonly property bool isMonitorFocused: modelData.monitor === Hyprland.monitorFor(screen) // TODO difference betweeen Hyprland.focusedMonitor / Hyprland/monitorFor(screen)

            implicitWidth: 20
            implicitHeight: 20

            radius: implicitHeight / 2

            color: isMonitorFocused && isActiveOnMonitor ? "#b298dc" : "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }

            Text { // TODO reveal appss in workspace on hover
                id: workspaceId
                text: modelData.name
                anchors.centerIn: parent
                color: circleBackground.isMonitorFocused ? (parent.isActiveOnMonitor ? "black" : parent.activeWorkspaceColor) : "#6D5D6E" //#5c0099 4C585B
                font.pixelSize: 13
                font.bold: true
                font.family: "lato"
            }

            Text {
                id: fallback
                visible: WorkspaceService.workspacesPresent
                text: "No workspaces"
                color: "#ffffff"
                font.pixelSize: 12
            }
        }

        property var symbolImgMap: {
            "": "extra-scale-vim",
            "󰇥": "extra-scale-yazi",
            // "󰇧": "extra-zen",
            "󰇧": "extra-scale-firefox",
            "󰒱": "extra-scale-slack",
            "": "extra-scale-terminal-thin",
            "": "extra-scale-firefox",
            "": "extra-scale-element-desktop",
            "󰊴": "extra-scale-discord-circle-dark",
            "": "extra-scale-chromium",
            // "": "chromium",
            "󰽉": "libreoffice-draw",
            "󰷈": "libreoffice-writer",
            "": "libreoffice-calc",
            "󰈩": "libreoffice-impress",
            // "󰭹": "signal-desktop",
            "󰭹": "extra-signal-simple",
            "": "extra-zathura",
            "": "extra-spotify",
            // "": "extra-scale-spotify",
            "": "extra-steam",
            "": "extra-scale-bluetooth",
            "": "extra-anki",
            "": "extra-scale-gimp",
            "": "extra-ghidra",
            // "󰄄": "com.obsproject.Studio",
            "󰄄": "extra-scale-obs",
            "": "extra-scale-photos",
            "": "extra-anki",
            "": "extra-mpv",
            "": "extra-virtualbox",
            "": "extra-scale-emacs",
            "": "monero",
            "󰻎": "extra-system-explorer-outline",
            "󱍼": "extra-scale-vlc",
            "": "com.usebottles.bottles",
            "": "Zoom",
            "󰊻": "teams-for-linux"
        }
    }
}
