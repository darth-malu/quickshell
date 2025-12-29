import QtQuick.Layouts
import qs.services
import QtQuick

RowLayout {
    spacing: 0
    BarBlock {
        id: cpu
        border.width: 0

        property bool showTemp: false

        readonly property color cpuColor: cpuPercent > 80 ? "#7CE577" : cpuPercent > 50 ? "#7CE577" : '#C6CAED' // #EEFC57

        readonly property int cpuPercent: ResourcesState.cpuPercent

        readonly property real cpuFreq: ResourcesState.cpuFreq

        readonly property real cpuTemp: ResourcesState.cpuTemp

        readonly property string family: "quicksand"

        // antialiasing: true

        onClicked: {
            showTemp = !showTemp;
        }

        content: RowLayout {
            spacing: 16
            BarText {
                id: cpuText
                renderNative: true
                font {
                    pixelSize: 12
                    bold: true
                    family: cpu.family
                }
                color: cpu.cpuColor
                symbolText: `🤖  ${cpu.cpuPercent}` // 
            }
            BarText {
                id: cpuFreqText
                visible: cpu.showTemp
                renderNative: true
                font {
                    pixelSize: 12
                    bold: true
                    family: cpu.family
                }
                symbolText: `🥶  ${cpu.cpuFreq} Ghz `
                baseColor: cpu.cpuColor
            }
        }
    }
    BarBlock {
        // radiusSide: "right"
        border {
            width: 0
            pixelAligned: false
        }
        content: BarText {
            id: cpuTemp
            renderNative: true
            symbolText: `${cpu.cpuTemp} `
            baseColor: cpu.cpuColor
            font {
                pixelSize: 12
                bold: true
            }
        }
    }
}
