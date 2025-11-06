//import QtQuick
// import QtMultimedia
import Quickshell.Services.UPower
import qs.customItems

BarBlock {
    id: batBlock
    visible: isBatteryPresent

    readonly property UPowerDevice battery: UPower.displayDevice

    readonly property bool isBatteryPresent: UPower.displayDevice.isLaptopBattery

    property var chargeState: UPower.displayDevice.state

    property bool isCharging: chargeState == UPowerDeviceState.Charging

    property bool isPluggedIn: isCharging || UPowerDeviceState.PendingCharge

    property real batLevel: Math.floor(UPower.displayDevice.percentage * 100) // charge level as %

    property bool isPlugged: Upower.displayDevice.state.PendingCharge

    property bool isDischarging: Upower.displayDevice.state.Discharging

    /* SoundEffect { */
    /*     id: beep */
    /*     source: Qt.resolvedUrl("beep.wav") */
    /* } */

    content: BarText {
        id: batText
        /* baseColor: isCharging == 'Charging' ? 'red' : batLevel < 10 ? '#FF2DD1' : batLevel < 20 ? '#DCED31' : batLevel < 50 ? '#B0FF92' : '#AA78A6' */
        baseColor: batLevel < 10 ? '#FF2DD1' : batLevel < 20 ? '#DCED31' : batLevel < 50 ? '#B0FF92' : '#AA78A6'
        font { pointSize: 10; family: 'lato'; bold: true}
        symbolText: batLevel 
    }
}
