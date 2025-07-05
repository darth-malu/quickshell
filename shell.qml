import Quickshell // for PanelWindow
import Quickshell.Io            // for process
import QtQuick // for Text

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 20

  Text {
    id: dateProc

    anchors.centerIn: parent


      Process {
          command: ["date"]
          running: true
          stdout: StdioCollector {
              onStreamFinished: dateProc.text  = this.text
          }
      }

      Timer {
         //1000 ms is 1 s
          interval: 1000

          // start timer immediately
          running: true

          //run the timer again when it ends
          repeat: true

          // when the timer is triggered, set the running property of the
          // process to true, which reruns it if stopped.
          onTriggered: dateProc.running = true
      }
  }
}
