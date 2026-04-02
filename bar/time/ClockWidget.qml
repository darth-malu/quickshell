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
    readonly property string date: Time.dateYangu
    readonly property string time: Time.time
    // anchors.verticalCenter: parent.verticalCenter

    // hoverEnabled: true

    // acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton | Qt.ForwardButton | Qt.BackButton

    onClicked: mouse => {
        mouse.accepted = true;
        if (mouse.button == Qt.LeftButton)
            ResourcesState.resourcesVisible = !ResourcesState.resourcesVisible;
        else if (mouse.button == Qt.RightButton)
            NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
    // else if (mouse.button == Qt.MiddleButton)
    //     showPopup = !showPopup;
    }

    content: BarText {
        symbolText: root.time
        font {
            pixelSize: 13
            // family: 'ZedMono Nerd Font Propo'
            // family: 'Lekton Nerd Font'
            // family: 'DaddyTimeMono Nerd Font'
            // family: "Mononoki Nerd Font"
            family: 'quicksand light'
            bold: true
        }
        baseColor: Themes.clockColor
    }

    IpcHandler {
        target: "Time"

        function currentTime() {
            Quickshell.execDetached(["notify-send", "-i", "office-calendar-symbolic", "Today", masaa.date]);
        }
    }

    ClockPopup {
        hostt: masaa
    }
}
