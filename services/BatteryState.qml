pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root
    readonly property UPowerDevice battery: UPower.displayDevice

    property real batPercentage: battery.percentage // Energy/EnergyCapacity

    property var chargeState: battery.state

    property bool available: battery.isLaptopBattery

    property bool isCharging: available && chargeState == UPowerDeviceState.Charging

    property bool isDischarging: chargeState == UPowerDeviceState.Discharging

    property bool isPluggedIn: isCharging || isPendingCharge

    property bool isPendingCharge: chargeState == UPowerDeviceState.PendingCharge

    property bool isPendingDischarge: chargeState == UPowerDeviceState.PendingDischarge

    property bool isFullyCharged: chargeState == UPowerDeviceState.FullyCharged

    // property real energyRate: battery.changeRate

    // property real timeToEmpty: battery.timeToEmpty

    // property real timeToFull: battery.timeToFull

    property bool isLow: available && (batPercentage <= 20 / 100)

    property bool isCritical: available && (batPercentage <= 7 / 100)

    property bool isLowAndNotCharging: isLow && !isCharging && !isPendingCharge

    property bool isCriticalAndNotCharging: isCritical && !isCharging && !isPendingCharge

    property string whichPowerProfile

    Process {
        id: getPower
        command: ["powerprofilesctl", "get"]
        stdout: SplitParser {
            onRead: data => {
                let cleanData = data.trim();
                if (cleanData !== "")
                    whichPowerProfile = data.trim();
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (getPower.running)
                return;
            getPower.running = true;
        }
    }

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging) {
            Quickshell.execDetached(["sh", "-c", "notify-send 'Low battery ' -u low -i /home/malu/.config/quickshell/assets/battery/low-battery.png -a Shell && canberra-gtk-play -i bell"]);
        }
    }

    // onIsChargingChanged: {
    //     if (isCharging) {
    //         Quickshell.execDetached(["sh", "-c", "notify-send 'Charger Connected' -u low -i /home/malu/.config/quickshell/assets/battery/plug.png -a Shell && canberra-gtk-play -i power-plug"]);
    //     } else if (isDischarging) {
    //         Quickshell.execDetached(["sh", "-c", "notify-send 'Charger Disconnected' -u low -i /home/malu/.config/quickshell/assets/battery/unplug.png -a Shell && canberra-gtk-play -i power-unplug"]);
    //     } else if (isFullyCharged) {
    //         Quickshell.execDetached(["sh", "-c", "notify-send 'Fully Charged' -u low -i /home/malu/.config/quickshell/assets/battery/full-battery.png -a Shell && canberra-gtk-play -i power-unplug"]);
    //     }
    // }

    onChargeStateChanged: {
        switch (chargeState) {
        case UPowerDeviceState.Charging:
            Quickshell.execDetached(["sh", "-c", "notify-send 'Charger Connected' -u low -i /home/malu/.config/quickshell/assets/battery/plug.png -a Shell && canberra-gtk-play -i power-plug"]);
            break;
        case UPowerDeviceState.Discharging:
            Quickshell.execDetached(["sh", "-c", "notify-send 'Charger Disconnected' -u low -i /home/malu/.config/quickshell/assets/battery/unplug.png -a Shell && canberra-gtk-play -i power-unplug"]);
            break;
        case UPowerDeviceState.FullyCharged:
            Quickshell.execDetached(["sh", "-c", "notify-send 'Fully Charged' -u low -i /home/malu/.config/quickshell/assets/battery/full-battery.png -a Shell && canberra-gtk-play -i power-unplug"]);
            break;
        }
    }
    onIsCriticalAndNotChargingChanged: {
        if (isCriticalAndNotCharging) {
            Quickshell.execDetached(["sh", "-c", "notify-send 'Critical battery!' -u critical -i /home/malu/.config/quickshell/assets/battery/warning-battery.png -a Shell && canberra-gtk-play -i bell"]);
        }
    }
}
