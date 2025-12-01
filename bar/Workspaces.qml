import QtQuick
import qs.services
import Quickshell.Hyprland

Repeater {
    id: repa
    model: WorkspaceService.workspaces

    Rectangle {
        id: circleBackground

        // visible: modelData.monitor === Hyprland.focusedMonitor || modelData.active // Show all workspaces only on the focused monitor

        property color activeWorkspaceIdColor: "#5c0099"

        property color inactiveTextColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 0.88)

        property color activeWorkspaceColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)

        property color currentMonitorNotActiveColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)

        readonly property bool isActiveOnMonitor: modelData.id === modelData.monitor.activeWorkspace.id

        readonly property bool isMonitorFocused: modelData.monitor === Hyprland.focusedMonitor

        implicitWidth: 20

        implicitHeight: 20

        radius: height / 2

        color: isMonitorFocused && isActiveOnMonitor ? "#b298dc" : "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch("workspace " + modelData.id)
        }

        Text { // TODO reveal appss in workspace on hover
            id: numbers
            text: modelData.id
            anchors.centerIn: parent
            color: isMonitorFocused ? (parent.isActiveOnMonitor ? "black" : parent.activeWorkspaceColor) : "#6D5D6E" //#5c0099 4C585B
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
