import QtQuick
import QtQuick.Layouts
import qs.services
import qs.customItems
import Quickshell

/* TODO
   + Alternative modes on click eg. time to full, empty, charge rate
 * */

RowLayout {
    id: batteryBlock
    spacing: 2

    MouseArea {
        id: root

        visible: BatteryState.available

        implicitWidth: batteryProgress.implicitWidth

        implicitHeight: batteryProgress.implicitHeight

        readonly property bool isCharging: BatteryState.isCharging // stops at 100 even if still plugged

        readonly property bool isLow: BatteryState.isLow

        readonly property bool isPluggedIn: BatteryState.isPluggedIn

        readonly property bool isPendingCharge: BatteryState.isPendingCharge

        readonly property bool isPendingDischarge: BatteryState.isPendingDischarge

        readonly property real percentage: BatteryState.batPercentage // 0.0-1.0 - Energy/Capacity

        readonly property bool isFull: BatteryState.isFullyCharged

        property bool togglePerformanceMode: false

        property string currentPerfProfile

        // hoverEnabled: true

        property var powerProfile: BatteryState.powerProfile

        property bool balancedMode: BatteryState.balMode
        property bool performanceMode: BatteryState.perfMode
        property bool powerSaverMode: BatteryState.saverMode

        // property bool balancedMode: BatteryState.balMode

        onClicked: mouse => {
            mouse.accepted = true;
            if (mouse.button == Qt.LeftButton)
                togglePerformanceMode = !togglePerformanceMode;
        }

        ClippedProgressBar {
            id: batteryProgress
            value: root.percentage
            highlightColor: root.isCharging ? "#7CE577" /*Lime*/ : root.isLow ? "#D295BF" /*pink*/ : Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)
            trackColor: 'grey'

            Item {
                // anchors.centerIn: parent
                width: batteryProgress.valueBarWidth
                height: batteryProgress.valueBarHeight

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 2

                    MaterialSymbol {
                        id: boltIcon
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: -2
                        Layout.rightMargin: -2
                        fill: 1
                        text: "⚡"
                        iconSize: 10
                        visible: root.isCharging
                    }

                    MaterialSymbol {
                        id: plugIcon
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: -2
                        Layout.rightMargin: -2
                        fill: 1
                        text: "🔌"
                        iconSize: 13
                        visible: root.isPendingCharge
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignVCenter
                        font: batteryProgress.font
                        text: root.isFull ? '⚡' : batteryProgress.text
                    }
                }
            }
        }
    }

    BarBlock {
        id: perfomanceBlock
        visible: root.togglePerformanceMode
        content: BarText {
            text: {
                if (root.balancedMode) {
                    console.log(`mode is: ${root.balancedMode}`);
                    return '☯';
                }
                if (root.performanceMode)
                    return '⚡';
                if (root.powerSaverMode)
                    return '🍀';
            }
        }
        onClicked: {
            const profiles = ['power-saver', 'performance', 'balanced'];

            // current
            let currentIndex = profiles.indexOf(root.powerProfile);

            //next index - Modulo of current + 1 eg 5/4 0 r 1 so loop back
            let nextIndex = (currentIndex + 1) % profiles.length;
            let nextProfile = profiles[nextIndex];

            Quickshell.execDetached(["sh", "-c", `powerprofilesctl set ${nextProfile} && notify-send -u low -i ${this.content.text} ${nextProfile}`]); // TODO: better Icons here, and menu

            root.powerProfile = nextProfile;
        }
    }
}
