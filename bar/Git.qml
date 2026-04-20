import QtQuick
import QtQml
import Quickshell.Io
// import Quickshell.Io
import qs.customItems
import Quickshell

/* Requirements
+ Different Colors depending on if the work tree is clean or dirty
+ Easy Click to update my dots.
+
*/

BarBlock {
    id: gitButton

    property list<string> preConf: ["doom", "quickshell"]

    property list<string> prePath: ["Shibuya", "Development", "Documents/IMPORTANT/Org"]

    property list<string> gitLoc: {
        let conf = preConf.map(conf => `/home/malu/.config/${conf}`);
        let path = prePath.map(path => `/home/malu/${path}`);
        return [...conf, ...path];
    }

    property bool isDirty: false

    Component.onCompleted: {
        Quickshell.execDetached(["notify-send", `This works...your list is..: ${gitLoc.join(" ")}`]);
    }

    content: BarText {
        text: ""
        pointSize: 14
        color: gitButton.isDirty ? 'pink' : 'black'
    }

    // if work tree is clean ... transparent...otherwise hot pink

    Process {
        id: gitStatus
        // command: ["sh", "-c", `for i in ${gitButton.gitLoc}git -C $HOME/Shibuya status --porcelain`]
        command: ["sh", "-c", `for i in ${gitButton.gitLoc.join(" ")};do
              git -C $i status -s --porcelain
            done`]
        running: false

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim();
                if (output.length > 0) {
                    gitButton.isDirty = true;
                    console.log("Caught: ", output.slice(0, 3));
                } else {
                    gitButton.isDirty = false;
                    console.log("Caught: ", output.slice(0, 3));
                    console.log("NOTT");
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: gitStatus.running = true
    }
}
