import QtQuick
import QtQml
import Quickshell.Io
import Quickshell
import qs.customItems
import qs.themes

BarBlock {
    id: gitButton

    property var gitLoc: {
        const home = "/home/malu";
        const conf = ["doom", "quickshell"].map(conf => `${home}/.config/${conf}`);
        const path = ["Shibuya", "Documents/IMPORTANT/Org"].map(path => `${home}/${path}`);
        return [...conf, ...path];
    }

    property bool isDirty: false
    property bool isRunning: false // New: Track if a command is active

    property bool isCommited: false

    onClicked: mouse => {
        if (isRunning)
            return; // Ignore clicks while a sync is in progress
        if (mouse.button === Qt.LeftButton)
            commitOrPush("commit");
        else if (mouse.button === Qt.RightButton)
            commitOrPush("push");
    }

    content: BarText {
        text: ""               // 
        pointSize: 13
        color: {
            if (gitButton.isRunning)
                return 'cyan';
            return gitButton.isDirty ? Themes.clockColor : 'grey';
        }
    }

    function commitOrPush(arg) {
        gitButton.isRunning = true;

        gitButton.gitLoc.forEach(location => {
            let checkCmd = `[ -n "$(git -C "${location}" status --porcelain)" ]`;
            let cleanPath = " " + location.split("/").pop();
            if (arg === "commit") {
                let commit = `${checkCmd} && git -C "${location}" add . && git -C "${location}" commit -m "++AutoCommit++" && notify-send "Git" "Commited ${cleanPath}" || true`;
                Quickshell.execDetached(["sh", "-c", commit]);
            } else if (arg === "push") {
                let push = `git -C "${location}" push`;
                Quickshell.execDetached(["sh", "-c", push]);
            }
        });
        cooldownTimer.start();
    }

    Timer {
        id: cooldownTimer
        interval: 1000
        repeat: false // Crucial: ensures it only runs once per trigger
        onTriggered: {
            gitButton.isRunning = false;
            gitStatusProcess.running = true;
        }
    }

    Process {
        id: gitStatusProcess
        command: ["sh", "-c", gitButton.gitLoc.map(loc => `git -C "${loc}" status --porcelain`).join("; ")]
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
            if (!gitButton.isRunning) {
                gitButton.isDirty = false;
                gitStatusProcess.running = true;
            }
        }
    }
}
