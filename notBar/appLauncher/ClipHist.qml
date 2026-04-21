import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: clipHist
    implicitWidth: 380
    implicitHeight: 250
    focusable: true
    color: "transparent"
    WlrLayershell.keyboardFocus: WlrLayerShell.OnDemand
    WlrLayershell.layer: WlrLayerShell.Overlay

    Rectangle {
        id: bigBox

        color: Qt.rgba(12 / 255, 44 / 255, 44 / 255, 0.9) // "#282a36" //"#1e1e2e"
        radius: 6
        anchors.fill: parent
        border {
            color: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.42)
            width: 1
        }

        Keys.onEscapePressed: Qt.quit()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout {
                spacing: 20

                // IconImage {

                // }

                TextField {
                    id: search
                    Layout.fillWidth: true
                    Layout.bottomMargin: 2
                    enabled: true
                    hoverEnabled: true
                    maximumLength: 10
                    color: search.enabled ? Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) : 'red'
                    background: Rectangle {
                        color: 'transparent'
                    }
                }
            }

            ListView {}
        }
    }
}
