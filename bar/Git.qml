import QtQuick
import QtQml
import Quickshell.Io
// import Quickshell.Io
import qs.customItems

// import Quickshell

/* Requirements
+ Different Colors depending on if the work tree is clean or dirty
+ Easy Click to update my dots.
+
*/

BarBlock {
    id: gitButton

    property var preConf: ["doom", "quickshell"]

    property var prePath: ["Shibuya", "Development", "Documents/IMPORTANT/Org"]

    property var gitLoc: {
        let conf = preConf.map(conf => `/home/malu/.config/${conf}`);
        let path = prePath.map(path => `/home/malu/${path}`);
        return [...conf, ...path];
    }

    property bool isDirty: false

    // Component.onCompleted: {
    //     Quickshell.execDetached(["notify-send", `This works...your list is..: ${gitLoc.join(" ")}`]);
    // }

    content: BarText {
        text: ""
        pointSize: 14
        color: gitButton.isDirty ? 'pink' : 'black'
    }

    Process {
        id: gitStatus
        command: ["sh", "-c", `for i in ${gitButton.gitLoc.join(" ")}; do git -C "$i" status --porcelain; done; echo "CHECK_COMPLETE"`]
        running: false

        // Temporary state for the current run
        property bool foundDirty: false

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim();
                if (output === "CHECK_COMPLETE") {
                    gitButton.isDirty = gitStatus.foundDirty;
                    gitStatus.foundDirty = false;
                } else
                    gitStatus.foundDirty = true;
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            gitStatus.running = true;
        }
    }
}
