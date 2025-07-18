import Quickshell // for PanelWindow
//import Quickshell.Io            // for process
/* import QtQuick // for Text */
/* import QtQuick.Layouts */
/* import QtQuick.Controls */
import Quickshell.Hyprland

Scope {
  Variants {
    model: Quickshell.screens;

    PanelWindow {
      /* color: '#20362D' */
      color: '#35a29fff';
      margins {
        left: 11
        right: 11
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

      SystemTray {
          id: trayYangu

          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: clock.top
          /* anchors.bottomMargin: Appearance.spacing.larger */
      }
    /* HyprlandWorkspace { */
    /*     HyprlandWindow.opacity: 0.6 */
    /* } */

    }
  }
}
