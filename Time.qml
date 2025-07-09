//convert Type to singleton(Only one instance and accessible from any scope)
//singletons always have Singleton as the type
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  property string time

  Process {
    id: dateProc
    //command: ["date" "+%H:%M:%S"]
    command: ["date"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.time = this.text
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}
