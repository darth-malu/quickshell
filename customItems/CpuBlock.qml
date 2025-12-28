import QtQuick.Layouts
import qs.services
import QtQuick

MonitorBlock {
    id: cpu

    property bool showTemp: false

    readonly property color cpuColor: cpuPercent > 80 ? "#7CE577" : cpuPercent > 50 ? "#7CE577" : '#C6CAED' // #EEFC57

    readonly property int cpuPercent: ResourcesState.cpu_percent
    readonly property real cpuFreq: ResourcesState.cpu_freq

    // TODO:Try JsonObject fonts
    readonly property string family: "quicksand"
    // antialiasing: true

    onClicked: {
        showTemp = !showTemp;
    }
    content: RowLayout {
        spacing: 16
        Text {
            id: cpuText
            // renderNative: true
            padding: 1
            font {
                pixelSize: 12
                bold: true
                family: cpu.family
            }
            color: cpu.cpuColor
            text: `❄️  ${cpu.cpuPercent}`
            // horizontalAlignment: Qt.AlignLeft
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
            symbolText: `🥶  $cpuw.cpuFreq} Ghz`
            baseColor: cpu.cpuColor
            // horizontalAlignment: Qt.AlignRight
        }
    }
}
