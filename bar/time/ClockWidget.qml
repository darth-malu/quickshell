import qs.themes
import QtQuick
import qs.customItems
import Quickshell.Widgets
import qs.services
import Quickshell.Io
import Quickshell

BarBlock {
    id: root
    required property var host
    property bool showPopup: false
    readonly property string date: Time.date
    readonly property string time: Time.time
    readonly property string dateTime: Time.dateTime
    hoveredBg: false
    // anchors.verticalCenter: parent.verticalCenter

    // hoverEnabled: true

    // acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton | Qt.ForwardButton | Qt.BackButton

    onClicked: mouse => {
        mouse.accepted = true;
        if (mouse.button == Qt.LeftButton)
            ResourcesState.resourcesVisible = !ResourcesState.resourcesVisible;
        else if (mouse.button == Qt.RightButton)
            NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
        else if (mouse.button == Qt.MiddleButton)
            showPopup = !showPopup;
    }

    content: BarText {
        symbolText: root.time
        rightPadding: 0
        font {
            pixelSize: 13
            // family: 'ZedMono Nerd Font Propo'
            // family: 'Lekton Nerd Font'
            // family: 'DaddyTimeMono Nerd Font'
            // family: "Mononoki Nerd Font"
            // family: 'quicksand light'
            family: 'lato'
            bold: true
        }
        baseColor: Themes.clockColor
    }

    IpcHandler {
        target: "Time"

        function currentDate() {
            Quickshell.execDetached(["notify-send", "-i", "office-calendar-symbolic", "Today", root.date]);
        }

        function currentDateTime() {
            Quickshell.execDetached(["notify-send", "-i", "office-calendar-symbolic", "Today", root.dateTime]);
        }
    }

    ClockPopup {
        hostt: root
    }
}
