import QtQuick
import QtQml
import Quickshell.Io
import Quickshell
import qs.customItems
import qs.themes

BarBlock {
    id: gitButton

    property var gitLoc: {
        let conf = ["doom", "quickshell"].map(conf => `/home/malu/.config/${conf}`);
        let path = ["Shibuya", "Documents/IMPORTANT/Org"].map(path => `/home/malu/${path}`);
        return [...conf, ...path];
    }

    property bool isDirty: false

    property bool isCommited: false

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton)
            commitOrPush("commit");
        else if (mouse.button === Qt.RightButton)
            commitOrPush("push");
    }

    content: BarText {
        text: ""               // 
        pointSize: 13
        color: gitButton.isDirty ? Themes.clockColor : 'grey'
    }

    function commitOrPush(arg) {
        gitButton.gitLoc.forEach(location => {
            let cleanPath = " " + location.split("/").pop();
            if (gitButton.isDirty) {
                if (arg === "commit") {
                    let commit = `git -C "${location}" add . && git -C "${location}" commit -m "++AutoCommit++"`;
                    Quickshell.execDetached(["sh", "-c", `${commit}  && notify-send "++ ${cleanPath}"`]);
                } else if (arg === "push") {
                    Quickshell.execDetached(["sh", "-c", `notify-send "Commit changes in ${cleanPath} to proceed"`]);
                }
            } else {
                if (arg === "push") {
                    let push = `git -C "${location}" push`;
                    Quickshell.execDetached(["sh", "-c", `${push}  && notify-send "Pushed: ${cleanPath}"`]);
                }
            }
        });
    }

    Process {
        id: gitStatus
        command: ["sh", "-c", gitButton.gitLoc.map(loc => `git -C "${loc}" status -s`).join(" && ")]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (data.trim().length > 0)
                    gitButton.isDirty = true;
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            gitButton.isDirty = false;
            gitStatus.running = true;
        }
    }
}
