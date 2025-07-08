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

    /* font.pointSize:  40; font.bold: true */

    anchors.centerIn: parent


      Process {                 //Process management object
          command: ["date"]     // every arg in its own string
          running: true         // run the command immediately
          stdout: StdioCollector { // process the stdout stream using a StdioCollector Use StdioCollector to retrieve the text the process sends to stdout.
              onStreamFinished: dateProc.text  = text  // Listen for the streamFinished signal, which is sent when the process closes stdout or exits.
          }
      }

      Timer {
         //1000 ms is 1 s
          interval: 1000

          // start timer immediately
          running: true

          //run the timer again when it ends
          repeat: true

          onTriggered: dateProc.running = true // when the timer is triggered, set the running property of the process to true, which reruns it if stopped.
      }
  }
}
