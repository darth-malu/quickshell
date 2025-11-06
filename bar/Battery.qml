import QtQuick
import QtQuick.Layouts
import qs.services
import qs.customItems

MouseArea{
    id: root
    visible: BatteryState.available

    // battery properties
    readonly property var chargeState: BatteryState.chargeState
    readonly property bool isCharging: BatteryState.isCharging
    readonly property bool isPluggedIn: BatteryState.isPluggedIn
    readonly property real percentage: BatteryState.batPercentage

    implicitWidth: batteryProgress.implicitWidth
    implicitHeight: batteryProgress.implicitHeight

    hoverEnabled: true

    ClippedProgressBar {
        id: batteryProgress
        anchors.centerIn: parent
        value: percentage
        highlightColor: (isLow && !isCharging) ? 'white' : 'red'

        /* Item { */
        /*     anchors.centerIn: parent */
        /*     width: batteryProgress.valueBarWidth */
        /*     height: batteryProgress.valueBarHeight */

        /*     RowLayout { */
        /*         anchors.centerIn: parent */
        /*         spacing: 0 */

        /*         BarText { */
        /*             id: textt */
                    
        /*         } */

                
        /*     } */
        /* } */
    }
}

        /* content: BarText { */
        /*     id: batText */
        /*     /\* baseColor: isCharging == 'Charging' ? 'red' : batLevel < 10 ? '#FF2DD1' : batLevel < 20 ? '#DCED31' : batLevel < 50 ? '#B0FF92' : '#AA78A6' *\/ */
        /*     baseColor: batLevel < 10 ? '#FF2DD1' : batLevel < 20 ? '#DCED31' : batLevel < 50 ? '#B0FF92' : '#AA78A6' */
        /*     font { pointSize: 10; family: 'lato'; bold: true} */
        /*     symbolText: batLevel  */
        /* } */
