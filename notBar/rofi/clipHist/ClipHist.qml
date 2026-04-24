import QtQuick
import Quickshell
import qs.services
import qs.notBar.rofi
import Quickshell.Io

Rofi {
    id: root
    visible: RofiState.toggleClipHist

    // TODO: INGEST CLIPHIST MODEL
    modelIngest: root.clipHist

    // readonly property string clipHist: Quickshell.clipboardText
    // Use cliphist decode instead for persistence
    property var clipHist
    property var neo

    Process {
        id: grabber
        command: ["cliphist", "list"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const cleanText = this.text.split(",");
                root.clipHist = cleanText;
                // root.clipHist = this.text;
                // SPLIT THIS
                // Quickshell.execDetached(["notify-send", `${this.text}`]);
            }
        }
    }

    onClipHistChanged: {
        // Quickshell.execDetached(["notify-send", `${clipHist}`]);
        // Quickshell.execDetached(["notify-send", `${neo}`]);
        // root.neo = root.clipHist.split("\n");
        // if (root.neo)
        // Quickshell.execDetached(["notify-send", `${root.neo}`]);
        // root.neo.map(x => console.log(x));

        console.log(`This is: ${root.clipHist}`);
    }

    delegateIngest: LauncherDelegate {
        required property var modelData
        // TODO: default for all ? way to do pictures?...
        // TODO: try Quickshell.clipboard
        iconUrl: Quickshell.iconPath(modelData.icon, "image-missing")
        app: Text {
            id: modelText
            text: clipHist
            color: Qt.rgba(196 / 255, 203 / 255, 212 / 255, 1)
            font {
                pointSize: 11
                family: "Mononoki Nerd Font"
            }
        }
    }
}
