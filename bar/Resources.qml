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

    readonly property int textSize: 9
    readonly property string textFont: 'quicksand'
    readonly property bool textBold: true

    readonly property int symbolSize: 10

    readonly property color valueColor: 'white'
    readonly property color cpuColor: cpuText.text > 80 ? "#EEFC57" : cpuText.text > 50 ? "#7CE577" : '#C6CAED'

    readonly property color memoryColor: memoryText.text >  90 ?  "#7CE577" : '#ccccccff'
    readonly property string textColor: "lightgray"

    IpcHandler {
        target: 'resources'
        function toggleResources(): void {
            root.visible = !root.visible
        }
    }

    content: RowLayout {
        id: resourcesRow
        anchors.centerIn: parent
        spacing: 13
        /* uniformCellSizes: true */

        RowLayout {
            id: memoryIcon
            /* spacing: 3 */
            BarText {
                font.pointSize: root.symbolSize
                symbolText: "🧠"
                /* Layout.alignment: Qt.AlignRight */
            }
            BarText {
                id: memoryText
                color: memoryColor
                font { pointSize: root.textSize; family: root.textFont; bold: root.textBold}
                text: ResourcesState.mem_percent
                /* Layout.alignment: Qt.AlignLeft */
            }
        }

        RowLayout {
            id: cpuColumn
            /* spacing: 6 */
            BarText {
                id: cpuIcon
                font.pointSize: root.symbolSize
                symbolText: "🤖"
                /* Layout.alignment: Qt.AlignCenter */
            }
            BarText {
                id: cpuText
                font { pointSize: root.textSize; family: root.textFont; bold: root.textBold}
                text: ResourcesState.cpu_percent
                /* Layout.alignment: Qt.AlignCenter */
                color: root.cpuColor
                Behavior on color { ColorAnimation { duration: 200 } } 
            }
        }

    }
}
