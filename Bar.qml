import Quickshell // for PanelWindow
//import Quickshell.Io            // for process
//import QtQuick // for Text

Scope {

  Variants {
    model: Quickshell.screens;

    PanelWindow {
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
    }
  }
}
