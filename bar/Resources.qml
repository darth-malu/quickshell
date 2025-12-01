import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import qs.customItems
import qs.services

BarBlock {// TODO add LazyLoader for this
    id: root

    color: "transparent"
    implicitWidth: resourcesRow.width

    readonly property int valueSize: 8

    readonly property int textSize: 8
    readonly property string textFont: 'quicksand medium'
    readonly property bool textBold: true
    readonly property int cpuPercent: ResourcesState.cpu_percent
    readonly property int memoryPercent: ResourcesState.mem_percent

    readonly property string diskUsage: ResourcesState.disk_used

    readonly property color diskColor: {
        const match = diskUsage.match(/(\d+\.?\d*)/); // returns list?

        if (match) {
            // const usage = parseFloat(match[0]);
            if (match[0] < 20) {
                return "#7CE577";
            } else if (match[0] < 10) {
                return "#ff79c6";
            } else {
                return "#ccccccff";
            }
        }

        return "grey";
    }

    readonly property color cpuColor: cpuPercent > 80 ? "#7CE577" : cpuPercent > 50 ? "#7CE577" : '#C6CAED' // #EEFC57

    readonly property color memoryColor: memoryPercent > 90 ? "#7CE577" : '#ccccccff'

    // readonly property color diskColor: ""  // TODO strip digits and make this color changes?

    IpcHandler {
        target: 'resources'
        function toggleResources(): void {
            root.visible = !root.visible;
        }
    }

    content: RowLayout {
        id: resourcesRow
        anchors.centerIn: parent
        spacing: 12
        // uniformCellSizes: true

        Pipewire {}

        BarBlock {
            id: disk
            content: BarText {
                id: diskText
                renderNative: true
                font {
                    pixelSize: 12
                    bold: true
                    family: "quicksand medium"
                }
                color: root.diskColor
                symbolText: `🗃️ ${root.diskUsage}` //
            }
        }

        BarBlock {
            id: memory
            content: BarText {
                id: memoryText
                renderNative: true
                font {
                    pixelSize: 12
                    bold: true
                    family: "quicksand medium"
                }
                color: root.memoryColor
                symbolText: `🧠 ${root.memoryPercent}` //
            }
        }

        BarBlock {
            id: cpu
            content: BarText {
                id: cpuText
                renderNative: true
                font {
                    pixelSize: 12
                    bold: true
                    family: "quicksand medium"
                }
                color: root.cpuColor
                symbolText: `❄️  ${root.cpuPercent}`
            }
        }
    }
}
