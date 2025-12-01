pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: main
    property string readings

    Process {
        id: netspeed
        running: true
        command: ["sh", "-c", "netspeed"]
        stdout: SplitParser {
            onRead: data => main.readings = data
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: () => netspeed.running = true
    }
}
