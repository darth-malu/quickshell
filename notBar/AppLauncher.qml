import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

import Quickshell.Wayland

PanelWindow {
    id: launcher
    implicitWidth: 550
    implicitHeight: 350
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    onVisibleChanged: {
        if (visible) {
            search.forceActiveFocus();
        }
    }
    WrapperRectangle {
        id: wrap
        color: "#1e1e2e"
        radius: 6
        anchors.fill: parent

        Keys.onEscapePressed: Qt.quit()
        focus: true

        child: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            TextField {
                id: search

                Layout.fillWidth: true
                Layout.bottomMargin: 2

                // placeholderText: ""
                // enabled: true
                focus: true
                hoverEnabled: true
                color: search.enabled ? 'white' : 'transparent'
                background: Rectangle {
                    color: 'transparent'
                    implicitHeight: 10
                    implicitWidth: 200
                    radius: 8
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                // keyNavigationEnabled: true
                // Layout.preferredHeight: 500

                model: DesktopEntries.applications.values.filter(a => a.name.toLowerCase().includes(search.text))
                highlight: Rectangle {
                    color: "lightsteelblue"
                    radius: 5
                }

                delegate: Text {
                    required property DesktopEntry modelData
                    text: modelData.name
                    color: 'white'
                    padding: 4
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            modelData.execute();
                            Qt.quit();
                        }
                    }
                }
            }
        }
    }
}
