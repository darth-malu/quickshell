pragma Singleton
import Quickshell
//import QtQuick
// import QtMultimedia
import Quickshell.Services.UPower
import qs.customItems

Singleton {
    readonly property UPowerDevice battery: UPower.displayDevice

    property var chargeState: UPower.displayDevice.state

    property bool available: battery.isLaptopBattery

    property bool isCharging: chargeState == UPowerDeviceState.Charging

    property bool isPluggedIn: isCharging || UPowerDeviceState.PendingCharge

    /* property real batPercentage: Math.floor(UPower.displayDevice.percentage * 100) // charge level as % TODO investigate how this fails */
    property real batPercentage: battery.percentage

    property bool isPlugged: Upower.displayDevice.state.PendingCharge

    property bool isDischarging: Upower.displayDevice.state.Discharging

    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull

    property bool isLow: available && (batPercentage <=  18 / 100)
    property bool isCritical: available && (batPercentage <=  7 / 100)

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging


    // TODO Functions or signals?? to handle different levels of charge
    onIsLowAndNotChargingChanged: {
        if(available && isLowAndNotCharging) {
            Quickshell.execDetached([
                "notify-send",
                "Low battery",
                "-u", "critical",
                "-i", "$XDG_CONFIG_HOME/quickshell/assets/battery/low-battery.png",
                "-a", "Shell"
            ])
        }
    }

    onIsCriticalAndNotChargingChanged: {
        if(available && isCriticalAndNotCharging) {
            Quickshell.execDetached([
                "notify-send",
                "Critically Low battery",
                "-i", "$XDG_CONFIG_HOME/quickshell/assets/battery/warning-battery.png",
                "-u", "critical",
                "-a", "Shell"
            ])
        }
    }
}
