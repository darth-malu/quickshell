import QtQuick
import qs.services

BarBlock {
    id: memory

    readonly property int memoryPercent: ResourcesState.memPercent

    readonly property color memoryColor: memoryPercent > 90 ? "#7CE577" : '#ccccccff'

    content: BarText {
        id: memoryText
        renderNative: true
        font {
            pixelSize: 12
            bold: true
            family: "quicksand"
        }
        baseColor: memory.memoryColor
        symbolText: `🧠 ${memory.memoryPercent}` //
    }
}
