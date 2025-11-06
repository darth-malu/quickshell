pragma Singleton
import Quickshell
//import QtQuick
// import QtMultimedia
import Quickshell.Services.UPower
import qs.customItems

Singleton {
    readonly property UPowerDevice battery: UPower.displayDevice

    property var chargeState: battery.state

    property bool available: battery.isLaptopBattery

    property bool isCharging: chargeState == UPowerDeviceState.Charging

    property bool isPluggedIn: isCharging || UPowerDeviceState.PendingCharge

    /* property real batPercentage: Math.floor(battery.percentage * 100) // charge level as % TODO investigate how this fails */
    property real batPercentage: battery.percentage

    property bool isPlugged: chargeState == UPowerDeviceState.PendingCharge

    property bool isDischarging: chargeState == UPowerDeviceState.Discharging

    property real energyRate: battery.changeRate

    property real timeToEmpty: battery.timeToEmpty

    property real timeToFull: battery.timeToFull

    property bool isLow: available && (batPercentage <=  18 / 100)

    property bool isCritical: available && (batPercentage <=  7 / 100)

    property bool isLowAndNotCharging: isLow && !isCharging

    property bool isCriticalAndNotCharging: isCritical && !isCharging


    // TODO Functions or signals?? to handle different levels of charge
    onIsLowAndNotChargingChanged: {
        if(available && isLowAndNotCharging) {
            Quickshell.execDetached([
                "notify-send",
                "Low battery ",
                "-u", "low",
                "-i", "/home/malu/.config/quickshell/assets/battery/low-battery.png",
                "-a", "Shell",
                "&&", "paplay /run/current-system/sw/share/sounds/freedesktop/stereo/bell.oga"
            ])
        }
    }

    onIsChargingChanged: {
        if(available && isCharging) {
            Quickshell.execDetached([
                "sh", "-c",
                "notify-send",
                "Charger connected ",
                "-i", "/home/malu/.config/quickshell/assets/battery/plug.png",
                "-u", "low",
                "-a", "Shell",
                "&&", "paplay /run/current-system/sw/share/sounds/freedesktop/stereo/power-plug.oga"
            ])
        }
        else if (available && !isCharging) {
            Quickshell.execDetached([
                "sh", "-c",
                "notify-send",
                "Charger disconnected ",
                "-i", "/home/malu/.config/quickshell/assets/battery/unplug.png",
                "-u", "low",
                "-a", "Shell",
                "&&", "paplay /run/current-system/sw/share/sounds/freedesktop/stereo/power-unplug.oga"
            ])
        }
    }

    onIsCriticalAndNotChargingChanged: {
        if(available && isCriticalAndNotCharging) {
            Quickshell.execDetached([
                "notify-send",
                "Critically Low battery ",
                "-i", "/home/malu/.config/quickshell/assets/battery/warning-battery.png",
                "-u", "critical",
                "-a", "Shell",
                "&&" , "paplay /run/current-system/sw/share/sounds/freedesktop/stereo/bell.oga"
            ])
        }
    }
}
