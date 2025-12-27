import QtQuick
import QtQuick.Layouts
import qs.services
import qs.customItems

/* TODO
   + Alternative modes on click eg. time to full, empty, charge rate
   + colors for different charge states
   + FIXME color change not working for Text{}
 * */

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

    //hoverEnabled: true

    ClippedProgressBar {
        id: batteryProgress
        anchors.centerIn: parent
        value: root.percentage
        highlightColor: root.isCharging ? "#7CE577" /*Lime*/ : root.isLow ? "#D295BF" /*pink*/ : Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)
        trackColor: 'grey'

        Item {
            anchors.centerIn: parent
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
                    // visible: isCharging && percentage < 1 // TODO: animation
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
