import QtQuick
import qs.services
import qs.customItems
import qs.themes
import Quickshell.Hyprland
import QtQuick.Layouts

RowLayout {
    spacing: 0
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

            radius: height / 2

            color: isMonitorFocused && isActiveOnMonitor ? "#b298dc" : "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }

            Text { // TODO reveal appss in workspace on hover
                id: workspaceId
                text: modelData.id
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
    }
}
