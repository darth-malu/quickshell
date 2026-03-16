import qs.customItems
import qs.themes
import QtQuick
import Quickshell.Widgets
import qs.services
import Quickshell.Io
import Quickshell

WrapperMouseArea {
    id: masaa
    property bool showPopup: false
    required property var host
    readonly property string date: Time.dateYangu
    readonly property string time: Time.time

    hoverEnabled: true

    acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton | Qt.ForwardButton | Qt.BackButton

    onClicked: mouse => {
        mouse.accepted = true;
        if (mouse.button == Qt.LeftButton)
            ResourcesState.resourcesVisible = !ResourcesState.resourcesVisible;
        else if (mouse.button == Qt.RightButton)
            NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
        else if (mouse.button == Qt.ForwardButton)
            showPopup = !showPopup;
    }

    BarText {
        symbolText: masaa.time
        font {
            pixelSize: 14
            family: 'Quicksand medium'
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
