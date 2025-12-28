import QtQuick
import QtQuick.Layouts
import qs.customItems
import qs.services
import qs.themes

// TODO add LazyLoader for this
Item {
    id: root

    implicitWidth: resourceLoader.item ? resourceLoader.item.implicitWidth : 0

    implicitHeight: resourceLoader.item ? resourceLoader.item.implicitHeight : 0

    Loader {
        id: resourceLoader
        active: ResourcesState.resourcesVisible
        visible: active
        sourceComponent: RowLayout {
            id: resourcesRow
            spacing: 16
            readonly property int valueSize: 8
            readonly property int textSize: 8

            // TODO:Try JsonObject fonts
            readonly property string family: "quicksand"

            readonly property bool textBold: true

            readonly property int cpuPercent: ResourcesState.cpu_percent
            readonly property real cpuFreq: ResourcesState.cpu_freq

            readonly property int memoryPercent: ResourcesState.mem_percent

            property bool showTemp: false

            readonly property string diskUsage: ResourcesState.darth_pool

            readonly property color diskColor: {
                const match = diskUsage.match(/(\d+\.?\d*)/); // returns list...get first match...number only eg 37.8
                if (match) {
                    if (match[0] < 10) {
                        return "#7CE577";
                    } else if (match[0] < 20) {
                        return "#ff79c6";
                    } else {
                        return "#ccccccff";
                    }
                }
                return "grey";
            }

            readonly property color cpuColor: cpuPercent > 80 ? "#7CE577" : cpuPercent > 50 ? "#7CE577" : '#C6CAED' // #EEFC57

            readonly property color memoryColor: memoryPercent > 90 ? "#7CE577" : '#ccccccff'

            Pipewire {
                textFont: "quicksand"
            }

            BarBlock {
                id: disk
                underline: false
                content: BarText {
                    id: diskText
                    renderNative: true
                    font {
                        pixelSize: 12
                        bold: true
                        family: "quicksand"
                    }
                    baseColor: resourcesRow.diskColor
                    symbolText: `🗃️ ${resourcesRow.diskUsage}` //
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
                        family: "quicksand"
                    }
                    baseColor: resourcesRow.memoryColor
                    symbolText: `🧠 ${resourcesRow.memoryPercent}` //
                }
            }

            BarBlock {
                id: cpu
                onClicked: {
                    resourcesRow.showTemp = !resourcesRow.showTemp;
                }
                content: RowLayout {
                    spacing: 16
                    BarText {
                        id: cpuText
                        renderNative: true
                        font {
                            pixelSize: 12
                            bold: true
                            family: resourcesRow.family
                        }
                        baseColor: resourcesRow.cpuColor
                        symbolText: `❄️  ${resourcesRow.cpuPercent}`
                        // horizontalAlignment: Qt.AlignLeft
                    }
                    BarText {
                        id: cpuFreqText
                        visible: resourcesRow.showTemp
                        renderNative: true
                        font {
                            pixelSize: 12
                            bold: true
                            family: resourcesRow.family
                        }
                        symbolText: `🥶  ${resourcesRow.cpuFreq} Ghz`
                        baseColor: resourcesRow.cpuColor
                        // horizontalAlignment: Qt.AlignRight
                    }
                }
            }
        }
    }
}
