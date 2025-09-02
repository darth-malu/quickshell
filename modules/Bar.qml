import Quickshell // PanelWindow
import QtQuick // Text
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets

import "./time"
//import "./blocks" as Blocks

Scope {
  Variants {
    model: Quickshell.screens;  //Returns all connected screens

    PanelWindow {
      id: invincibleMainPanel
      property var modelData
      screen: modelData
      color: "transparent"
      implicitHeight: 22
      //color: '#35a29fff'; //move this to rectangle

      margins {//TODO make this adapt to my Gap size
        //top: 6
        left: 12
        right: 12
        //TODO make gaps zero im gaps zero
      }
      anchors {
        top: true
        bottom: false
        left: true
        right: true
      }

      //main bar
      Rectangle {
        id: mainBar
        anchors.fill: parent
        //color: '#1a1a1a'
        //color: '#35a29fff'; //move this to rectangle
        color: Qt.rgba(8/255, 41/255, 41/255, 0.58)
        radius: 16
        border.width: 0
        border.color: "#333333"
        Row {
          id: hyprlandWorkspacesRow
          spacing: 2.5
          anchors {
            left : parent.left
            leftMargin: 1
          }
          Repeater {
            //model: Hyprland.workspaces
            //model: Hyprland.focusedWorkspace
            anchors.verticalCenter: parent.verticalCenter
            model: Hyprland.workspaces.values.filter(w => !w.name.startsWith("special"))
            Rectangle {
              implicitWidth: 20
              implicitHeight: 20
              radius: 16
              //color: modelData.active ? "#4a9eff" : "transparent"
              //color: modelData.active ? Qt.rgba(218/255,25/255,91/255,0.34) : "transparent"
              //color: modelData.active ? "#6247AA" : "transparent"
              color: modelData.active ? "#6247AA" : "transparent" // Green -062726, 062726, 6247AA
              //border.width: 0.4
              //border.color: Qt.rgba(255/255 ,117/255 , 143/255, 0.86)
              //border.color: "#da195b57"
              MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
                onWheel: (wheel) => {
                    if (wheel.angleDelta.y > 0) {
                      Hyprland.dispatch("workspace m-1")
                    } else if (wheel.angleDelta.y < 0) {
                      Hyprland.dispatch("workspace m+1")
                    }
                }
              }
              Text {
                text: modelData.id
                anchors {
                  centerIn: parent
                  verticalCenter: parent.verticalCenter
                  //horizontalCenter: parent.horizontalCenter
                }
                //color: modelData.active ? "#ffffff" : "#ccccccff"
                //color: modelData.active ? Qt.rgba(255/255 ,158/255 , 170/255, 0.96) : Qt.rgba( 7/255 , 177/255 , 169/255, 0.88)
                //color: modelData.active ? Qt.rgba(255/255 ,158/255 , 170/255, 0.96) : Qt.rgba( 7/255 , 177/255 , 169/255, 0.88)
                color: modelData.active ? Qt.rgba(242/255, 226/255, 255/255,  0.96) : Qt.rgba( 7/255 , 177/255 , 169/255, 0.83)//'#d896ff/255' //D5E68D, #C8EAD3, 42BFDD, #B6DC76, 98B06F, 442B48(orange), 7C90A0(grey/silver), 7C90A0, 5D5179
                font.pixelSize: 14
                font.bold: true
                //font.family: "quicksand"
                font.family: "Mononoki Nerd Font"
              }
            }
          }


        readonly property var toplevels: Hyprland.toplevels
            Rectangle {
              implicitWidth: 20
              implicitHeight: 20
              //radius: 15
              color: 'transparent'

              Text {
                text: toplevels
                color: 'white'

                anchors {
                  centerIn: parent
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
          anchors {
            centerIn: parent
            verticalCenter: parent.verticalCenter
          }
          //font.family: "VictorMono Nerd Font"
          font.family: "Mononoki Nerd Font"
          //font.family: "quicksand"
          font.pixelSize: 13
          font.bold: true
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
          /* Text{ */
          /*   text: UPower.displayDevice.isLaptopBattery ? qsTr("Remaining: %1%").arg(Math.round(UPower.displayDevice.percentage * 100)) : qsTr("No battery detected") */
          /*   anchors.right: parent.right */
          /*   anchors.verticalCenter: parent.VerticalCenter */
          /* } */
          //Blocks.Battery {}
          Pipewire {}
          //Mpris {}
          Memory {}
          Volume {}

          SystemTrayy {
            anchors {
              //centerIn: parent
              //bottom: parent.bottom
              //horizontalCenter: parent.horizontalCenter
            }
          }
          //Notifications {}
        }
        //SystemTray {}
      }
    }
  }
}
