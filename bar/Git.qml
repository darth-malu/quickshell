import QtQuick
import QtQml
import Quickshell.Io
import qs.customItems

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

    content: BarText {
        text: ""
        pointSize: 14
        color: gitButton.isDirty ? 'pink' : 'grey'
    }

    Process {
        id: gitStatus
        command: ["sh", "-c", `
        for i in ${gitButton.gitLoc.join(" ")}; do
            res=$(git -C "$i" status --porcelain)
            if [ -z "$res" ]; then echo "REPO_CLEAN"; else echo "$res"; fi
        done
        echo "CHECK_COMPLETE"
        `]

        running: false

        property bool foundDirtyInCurrentRun: false

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim();
                if (output === "CHECK_COMPLETE") {
                    // End of the whole check: update the button and reset
                    gitButton.isDirty = gitStatus.foundDirtyInCurrentRun;
                    gitStatus.foundDirtyInCurrentRun = false;
                } else if (output !== "REPO_CLEAN" && output.length > 0) {
                    // If it's not our clean marker and not empty, it's a real git change
                    gitStatus.foundDirtyInCurrentRun = true;
                }
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
