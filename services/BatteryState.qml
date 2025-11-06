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

    property real batPercentage: Math.floor(UPower.displayDevice.percentage * 100) // charge level as % TODO investigate how this fails

    property bool isPlugged: Upower.displayDevice.state.PendingCharge

    property bool isDischarging: Upower.displayDevice.state.Discharging

    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull

    property bool isLow: available && batPercentage <= 18
    property bool isCritical: available && batPercentage <= 7

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging


    //Functions to handle different levels of charge
    onIsLowAndNotChargingChanged: {
        if(available && isCriticalAndNotCharging) {
            Quickshell.execDetached([
                "notify-send",
                "Low battery",
                "Plugin charger m8",
                "-u", "critical",
                "-a", "Shell"
            ])
        }
    }

    onIsCriticalAndNotChargingChanged: {
        if(available && isCriticalAndNotCharging) {
            Quickshell.execDetached([
                "notify-send",
                "Critically Low battery",
                "-u", "critical",
                "-a", "Shell"
            ])
        }
    }
}
