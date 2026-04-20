import qs.themes
import QtMultimedia
import QtQuick
import qs.customItems
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
    // color: 'red'

    // anchors.verticalCenter: parent.verticalCenter

    // hoverEnabled: true
    SoundEffect {
        id: beep
        source: Qt.resolvedUrl("game_ready.wav")
    }

    onClicked: mouse => {
        // mouse.accepted = true;
        if (mouse.button === Qt.LeftButton) {
            ResourcesState.resourcesVisible = !ResourcesState.resourcesVisible;
            beep.play();
        } else if (mouse.button === Qt.RightButton)
            NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
        else if (mouse.button === Qt.MiddleButton)
            showPopup = !showPopup;
    }

    content: BarText {
        symbolText: root.time
        paddingg: 0
        // bottomPadding: 2
        // verticalAlignment: Text.AlignVCenter
        font: Themes.monofur
        bottomPadding: 2
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
