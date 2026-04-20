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
