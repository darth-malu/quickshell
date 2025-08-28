import QtQuick
import Quickshell.Hyprland
import Quickshell
import "../time"

Scope {
    id: root
    //main bar
    Rectangle {
    id: mainRectangleContainer
    anchors.fill: parent
    //color: '#1a1a1a'
    color: '#35a29fff'; //move this to rectangle
    radius: 6
    border.width: 1
    border.color: "#333333"
    ClockWidget {//TODO make this pop up calendar, alarm, weather, netSpeed, pomodoro
        anchors.centerIn: parent
        //font.family: "VictorMono Nerd Font"
        font.family: "Mononoki Nerd Font"
        font.pixelSize: 13
    }
    Row {
        id: hyprlandWorkspacesRow
        spacing: 2.3
        anchors {
        left : parent.left
        verticalCenter: parent.verticalCenter
        leftMargin: 1
        }
        Repeater {
        //model: Hyprland.workspaces
        model: Hyprland.workspaces.values.filter(w => !w.name.startsWith("special"))
        Rectangle {
            implicitWidth: 19
            implicitHeight: 19
            radius: 6
            color: modelData.active ? "#4a9eff" : "transparent"
            border.color: "#da195b57"
            MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }
            Text {
            text: modelData.id
            anchors.centerIn: parent
            color: modelData.active ? "#ffffff" : "#cccccc"
            font.pixelSize: 13
            font.family: "Mononoki Nerd Font"
            }
        }
        }

        //fallback if no workspace
        Text {
        visible: Hyprland.workspaces.length === 0
        text: "No workspaces"
        color: "#ffffff"
        font.pixelSize: 12
        }
    }
    }
}
