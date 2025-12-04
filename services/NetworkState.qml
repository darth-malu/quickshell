pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: main

    property real upload
    property real download

    Process {
        id: uploadProc
        running: true
        command: ["netspeed", "upload"]
        stdout: SplitParser {
            onRead: data => main.upload = data
            // splitMarker: " "
        }
    }

    Process {
        id: downloadProc
        running: true
        command: ["netspeed", "download"]
        stdout: SplitParser {
            onRead: data => main.download = data
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: () => {
            uploadProc.running = true;
            downloadProc.running = true;
        }
    }
}
