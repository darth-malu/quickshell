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

    onClicked: pusherMan()

    content: BarText {
        text: ""               // 
        pointSize: 13
        color: gitButton.isDirty ? Themes.clockColor : 'grey'
    }

    function pusherMan() {
        gitButton.gitLoc.forEach(location => {
            let gitCmd = `git -C "${location}" add . && git -C "${location}" commit -m "++AutoCommit++" && git -C "${location}" push`;

            if (gitButton.isDirty) {
                Quickshell.execDetached(["sh", "-c", `${gitCmd}  && notify-send "AutoCommited ${location}"`]);
            } else {
                Quickshell.execDetached(["notify-send", `${location} !dirty...skipping`]);
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
