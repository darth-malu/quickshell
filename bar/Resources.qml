import QtQuick
import QtQuick.Layouts
import qs.customItems
import qs.services

// TODO add LazyLoader for this
Item {
    id: root

    implicitWidth: resourceLoader.item ? resourceLoader.item.implicitWidth : 0

    implicitHeight: resourceLoader.item ? resourceLoader.item.implicitHeight : 0

    Loader {
        id: resourceLoader
        active: ResourcesState.resourcesVisible
        visible: active
        sourceComponent: resourcesComponent
        // anchors.fill: parent
    }

    Component {
        id: resourcesComponent

        RowLayout {
            id: resourcesRow
            spacing: 16
            readonly property int valueSize: 8
            readonly property int textSize: 8
            readonly property string textFont: 'quicksand medium'
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

            Pipewire {}

            BarBlock {
                id: disk
                underline: false
                content: BarText {
                    id: diskText
                    renderNative: true
                    font {
                        pixelSize: 12
                        bold: true
                        family: "quicksand medium"
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
                        family: "quicksand medium"
                    }
                    baseColor: resourcesRow.memoryColor
                    symbolText: `🧠 ${resourcesRow.memoryPercent}` //
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
                    baseColor: resourcesRow.cpuColor
                    symbolText: `❄️  ${resourcesRow.cpuPercent}`
                }
                onClicked: {
                    resourcesRow.showTemp = !resourcesRow.showTemp;
                    // console.log(`$id clicked`)
                }
            }

            BarBlock {
                id: cpuTemp
                visible: resourcesRow.showTemp

                /* Layout.preferredWidth: visible ? implicitWidth : 0 */
                /* Layout.preferredHeight: visible ? implicitHeight : 0 */
                /* Layout. */

                content: BarText {
                    id: cpuTempText
                    renderNative: true
                    font {
                        pixelSize: 12
                        bold: true
                        family: "quicksand medium"
                    }
                    baseColor: resourcesRow.cpuColor
                    symbolText: `🥶  ${resourcesRow.cpuFreq}`
                }
            }
        }
    }
}
