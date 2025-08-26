import Quickshell // PanelWindow
import QtQuick // Text
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import "./time"

Scope {
  Volume {}
  Variants {
    model: Quickshell.screens;  //Returns all connected screens

    PanelWindow {
      property var modelData
      screen: modelData

      color: "transparent"

      id: invincibleMainPanel

      implicitHeight: 20

      //color: '#35a29fff'; //move this to rectangle

      margins {//TODO make this adapt to my Gap size
        //top: 6
        /* left: 12 */
        /* right: 12 */
        //TODO make gaps zero im gaps zero
      }

      anchors {
        top: true
        left: true
        right: true
      }

      //main bar
      Rectangle {
        id: mainRectangleContainer
        anchors.fill: parent
        //color: '#1a1a1a'
        color: '#35a29fff'; //move this to rectangle
        //radius: 6
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
          anchors {
            left : parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 1
          }

          spacing: 2

          Repeater {
            model: Hyprland.workspaces
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
  }
}
