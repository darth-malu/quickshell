import qs.customItems
import qs.themes
import QtQuick
import Quickshell.Widgets
import qs.services

WrapperMouseArea {
    id: masaa
    property bool showPopup: false
    required property var host

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
        anchors.fill: parent
        symbolText: Time.time
        font {
            pixelSize: 14
            family: 'Quicksand medium'
            bold: true
        }
        baseColor: Themes.clockColor
    }

    ClockPopup {
        hostt: masaa
    }
}
