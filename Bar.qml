import Quickshell // for PanelWindow
import Quickshell.Io            // for process
import QtQuick // for Text

Scope {
  Time {id: timesource}        //Time type we created

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
        text: timeSource.time
      }
    }
  }

  Process {
    id: dateProc
    command: ["date"]
    running: true

    stdout: StdioCollector {
        onStreamFinished: root.time  = this.text
    }
  }

  Timer {
      interval: 1000 //1000 ms is 1 s

      running: true // start timer immediately

      repeat: true //run the timer again when it ends

      onTriggered: dateProc.running = true // when the timer is triggered, set the running property of the process to true, which reruns it if stopped.
  }
}
