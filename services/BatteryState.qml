pragma Singleton
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice battery: UPower.displayDevice

    property real batPercentage: battery.percentage // Energy/EnergyCapacity

    property real batPercentage: battery.percentage // Energy/EnergyCapacity

    property var chargeState: battery.state

    property bool available: battery.isLaptopBattery

    property bool isCharging: available && chargeState == UPowerDeviceState.Charging

    property bool isDischarging: chargeState == UPowerDeviceState.Discharging

    property bool isPluggedIn: isCharging || isPendingCharge

    property bool isPendingCharge: chargeState === UPowerDeviceState.PendingCharge

    property bool isPendingDischarge: chargeState === UPowerDeviceState.PendingDischarge

    property bool isFullyCharged: chargeState === UPowerDeviceState.FullyCharged

    // property real energyRate: battery.changeRate

    // property real timeToEmpty: battery.timeToEmpty

    // property real timeToFull: battery.timeToFull

    property bool isLow: available && (batPercentage <= 20 / 100)

    property bool isCritical: available && (batPercentage <= 7 / 100)

    property bool isLowAndNotCharging: isLow && !isCharging && !isPendingCharge

    property bool isCriticalAndNotCharging: isCritical && !isCharging && !isPendingCharge

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging) {
            Quickshell.execDetached(["sh", "-c", "notify-send 'Low battery ' -u low -i /home/malu/.config/quickshell/assets/battery/low-battery.png -a Shell && canberra-gtk-play -i bell"]);
        }
    }

    onIsChargingChanged: {
        if (isCharging) {
            Quickshell.execDetached(["sh", "-c", "notify-send 'Charging' -u low -i /home/malu/.config/quickshell/assets/battery/plug.png -a Shell && canberra-gtk-play -i power-plug"]);
        } else if (!isCharging && !isFullyCharged) {
            Quickshell.execDetached(["sh", "-c", "notify-send 'Discharging' -u low -i /home/malu/.config/quickshell/assets/battery/unplug.png -a Shell && canberra-gtk-play -i power-unplug"]);
        } else if (!isDischarging && isFullyCharged) {
            Quickshell.execDetached(["sh", "-c", "notify-send 'Fully Charged' -u low -i /home/malu/.config/quickshell/assets/battery/full-battery.png -a Shell && canberra-gtk-play -i power-unplug"]);
        }
    }

    onIsCriticalAndNotChargingChanged: {
        if (isCriticalAndNotCharging) {
            Quickshell.execDetached(["sh", "-c", "notify-send 'Critical battery!' -u critical -i /home/malu/.config/quickshell/assets/battery/warning-battery.png -a Shell && canberra-gtk-play -i bell"]);
        }
    }
}
