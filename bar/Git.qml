import QtQuick
import QtQml
import Quickshell.Io
import Quickshell
import qs.customItems
import qs.themes

/* Requirements
+ Different Colors depending on if the work tree is clean or dirty
+ Easy Click to update my dots.
+
*/

BarBlock {
    id: gitButton

    property var preConf: ["doom", "quickshell"]

    property var prePath: ["Shibuya", "Documents/IMPORTANT/Org"]

    property var gitLoc: {
        let conf = preConf.map(conf => `/home/malu/.config/${conf}`);
        let path = prePath.map(path => `/home/malu/${path}`);
        return [...conf, ...path];
    }

    property bool isDirty: false

    property bool isCommited: false

    onClicked: {
        Quickshell.execDetached(["notify-send", "Click works"]);
        commitTimer.start();
    }

    content: BarText {
        text: ""               // 
        pointSize: 13
        color: gitButton.isDirty ? Themes.clockColor : 'grey'
    }

    Process {
        id: gitCommit
        command: ["sh", "-c", `for i in ${gitButton.gitLoc.join(" ")}; do git -C $i commit -a -m '++AutoCommit++'; done`]
        // TODO: make it check gitStatus process is triggered first
        // TODO: Make a push after the commet
        // TODO: right click to push, left click to commit
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                // TODO: push after the commit stream is done and display notif if successful
                Quickshell.execDetached(["sh", "-c", `for i in ${gitButton.gitLoc.join(" ")}; do git -C $i push; done; notify-send \"Pushing $i \""`]);
                Quickshell.execDetached(["notify-send", "FAIL"]);
            }  // TODO: STDERR for notif
        }
    }

    // MAKE FUNCTION INSTEAD OF PROCESS...TRIGGER with gitStatus PROCESS...
    function pusherMan() {
        // TODO: ingest list of directories to commit & push
        Quickshell.execDetached(["notify-send", "Pusher Man works"]);
    }

    Timer {
        id: commitTimer
        interval: 500
        repeat: false
        running: false

        onTriggered: {
            gitCommit.running = true;
            gitButton.pusherMan();
        }
    }

    Process {
        id: gitStatus
        command: ["sh", "-c", `for i in ${gitButton.gitLoc.join(" ")}; do
              git -C "$i" status -s --porcelain
            done`]
        running: false

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim();
                if (output.length > 0)
                    gitButton.isDirty = true;
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            gitButton.isDirty = false;
            gitStatus.running = true;
        }
    }
}
