import QtQuick
import qs.customItems
import qs.services

BarBlock {
    id: main
    readonly property string currentSpeed: NetworkState.readings
    content: BarText {
        symbolText: main.currentSpeed
        symbolSize: 12
        font {
            pixelSize: 12
            bold: true
            family: "quicksand medium"
        }
    }
}
