import Quickshell // PanelWindow
//import Quickshell.Io            // process
import QtQuick // Text
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
/* import Quickshell.Hyprland */
/* import Quickshell.Services.SystemTray */
import "./time"

Scope {
  Volume {}
  Variants {
    model: Quickshell.screens;  //Returns all connected screens
    PanelWindow {
      id: mainPanel
      implicitHeight: 20
      /* color: '#35a29fff'; //move this to rectangle */
      margins {
        //top: 6
        left: 12
        right: 13
      }

      //main bar
      Rectangle {
        id: mainContainer
        anchors.fill: parent
        //color: #1a1a1a
        color: '#35a29fff'; //move this to rectangle
        radius: 15
        border.width: 1
        Row {
          id: hyprlandWorkspaces
          anchors {
            left : parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 16
          }
          spacing: 8

          Repeater {
            model: Hyprland.workspaces

            Rectangle {
              width: 32
              height: 24
              radius: 4
              color: modelData.active ? "red" : "magenta"
              border.color: "cyan"

              MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
              }

              Text {
                text: modelData.id
                anchors.centerIn: parent
                color: modelData.active ? "#ffffff" : "#cccccc"
                font.pixelSize: 12
                font.family: "nunito, quicksand, Inter"
              }
          }
        }

      property var modelData    //For multriscreen
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }


      ClockWidget {
        anchors.centerIn: parent
      }

      /* Mpris {} */

    }
  }
}
