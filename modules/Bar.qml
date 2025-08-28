import Quickshell // PanelWindow
import QtQuick // Text
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick.Layouts

import "./time"
import "./blocks" as Blocks

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
        left: 12
        right: 12
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
        radius: 6
        border.width: 1
        border.color: "#333333"
        Row {
          id: hyprlandWorkspacesRow
          spacing: 2.5
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
        ClockWidget {//TODO make this pop up calendar, alarm, weather, netSpeed, pomodoro
          anchors.centerIn: parent
          //font.family: "VictorMono Nerd Font"
          font.family: "Mononoki Nerd Font"
          font.pixelSize: 13
        }

        //RHS
        RowLayout {
          id: rhsBlocks
          spacing: 2
          anchors {
            right : parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: 1
          }

            Text{
              text: UPower.displayDevice.isLaptopBattery ? qsTr("Remaining: %1%").arg(Math.round(UPower.displayDevice.percentage * 100)) : qsTr("No battery detected")
              anchors.right: parent.right
              anchors.verticalCenter: parent.VerticalCenter
            }
          //Blocks.Battery {}
        }
      }
    }
  }
}
