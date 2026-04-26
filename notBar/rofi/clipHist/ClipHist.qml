import QtQuick
import Quickshell
import qs.services
import qs.notBar.rofi
import Quickshell.Io

Rofi {
    id: root
    visible: RofiState.toggleClipHist

    modelIngest: clipHist

    property var clipHist: []

    Process {
        id: grabber
        command: ["cliphist", "list"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.clipHist = [...root.clipHist, data];
            }
        }
        // Reset the list when the process starts so you don't get duplicates
        onStarted: root.clipHist = []
    }
    // onClipHistChanged: {
    //     root.clipHist.map(x => console.log(x));
    // }
    // LIST -> select item -> decode -> wl-copy

    delegateIngest: LauncherDelegate {
        required property var modelData
        iconUrl: ""
        app: TextClipHistDelegate {}
    }
}
