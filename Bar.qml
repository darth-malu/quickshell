import Quickshell // for PanelWindow
//import Quickshell.Io            // for process
import QtQuick // for Text
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
/* import Quickshell.Hyprland */
/* import Quickshell.Services.SystemTray */

Scope {
  Variants {
    model: Quickshell.screens;

    PanelWindow {
      /* color: '#20362D' */
      color: '#35a29fff';
      margins {
        left: 12
        right: 12
      }
      property var modelData
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


      Mpris {
        /* anchors.centerIn: parent.horizontalCenter */
        anchors.fill: parent.right
      }
    }
  }
}
