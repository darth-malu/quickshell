import Quickshell // for PanelWindow
//import Quickshell.Io            // for process
import QtQuick // for Text
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
/* import Quickshell.Hyprland */
/* import Quickshell.Services.SystemTray */
import "./bar-components"

Scope {
  Volume {}
  //Activate {}
  Variants {
    model: Quickshell.screens;  //Returns all connected screens

    PanelWindow {
      color: '#35a29fff';
      margins {
        left: 12
        right: 12
      }
      property var modelData    //For multriscreen
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 20

      ClockWidget {
        anchors.centerIn: parent
      }

      /* Mpris {} */

      Text {
        text: "This works?"
        color: "magenta"
        // anchors.right: parent
      }
    }
  }
}
