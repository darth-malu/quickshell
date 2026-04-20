import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland

// Requirement Ingest Open Apps Hyprland

PanelWindow {
    id: openApps
    implicitWidth: 380
    implicitHeight: 250
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus: WlrLayerShell.OnDemand
    WlrLayershell.layer: WlrLayer.Overlay

    Rectangle {
        id: wrap
        color: Qt.rgba(12 / 255, 44 / 255, 44 / 255, 0.9) // "#282a36" //"#1e1e2e"
        radius: 6
        anchors.fill: parent
        border {
            color: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.42)
            width: 1
        }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout {
                spacing: 20

                IconImage {
                    Layout.preferredWidth: 15
                    Layout.leftMargin: 10
                    source: Quickshell.iconPath("system-search-symbolic", "🔍")
                    implicitWidth: 18
                    implicitHeight: 18
                }

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
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Up || (event.key === Qt.Key_K && event.modifiers & Qt.ControlModifier)) {
                            actualList.decrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down || (event.key === Qt.Key_J && event.modifiers & Qt.ControlModifier)) {
                            actualList.incrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (actualList.currentItem) {
                                actualList.currentItem.launch_app2unit();
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Escape)
                            Qt.quit();
                    }
                }
            }

            ListView {
                id: actualList
                Layout.fillWidth: true
                Layout.fillHeight: true
                // clip: true
                // boundsBehavior: Flickable.StopAtBounds // Optional: cleaner scrolling feel
                model: {}

                highlight: Item {}

                delegate: CurrentItem {}
            }
        }
    }
}
