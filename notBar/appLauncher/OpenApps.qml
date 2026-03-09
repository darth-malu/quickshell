import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

import Quickshell.Wayland

PanelWindow {
    id: launcher
    implicitWidth: 380
    implicitHeight: 250
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus: WlrLayerShell.OnDemand
    WlrLayershell.layer: WlrLayer.Overlay

    onVisibleChanged: {
        if (visible) {
            search.forceActiveFocus();
        }
    }

    WrapperRectangle {
        id: wrap
        color: Qt.rgba(12 / 255, 44 / 255, 44 / 255, 0.9) // "#282a36" //"#1e1e2e"
        radius: 6
        anchors.fill: parent
        border {
            color: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.42)
            width: 1
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | PointerDevice.Mouse | PointerDevice.TouchPad
            onContainsMouseChanged: {
                if (!containsMouse)
                    Qt.quit();
            }
        }

        Keys.onEscapePressed: Qt.quit()

        child: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout {
                spacing: 20

                IconImage {
                    Layout.preferredWidth: 15
                    Layout.leftMargin: 10
                    source: Quickshell.iconPath("system-search-symbolic", "search")
                    implicitWidth: 18
                    implicitHeight: 18
                }

                TextField {
                    id: search

                    Layout.fillWidth: true
                    Layout.bottomMargin: 2
                    enabled: true
                    hoverEnabled: true
                    maximumLength: 30
                    color: search.enabled ? Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) : 'transparent'
                    background: Rectangle {
                        color: 'transparent'
                        implicitHeight: 10
                        implicitWidth: 200
                        radius: 4
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
                model: DesktopEntries.applications.values.filter(a => a.name.toLowerCase().includes(search.text))
                readonly property color markerColor: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)
                highlight: Item {
                    // z: 8
                    ClippingRectangle {
                        id: currentItemBg
                        anchors.fill: parent
                        color: Qt.rgba(72 / 255, 191 / 255, 227 / 255, 0.2)
                        radius: 2
                        Rectangle {
                            id: markerLeft
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2
                            color: actualList.markerColor
                            radius: 5
                        }

                        Rectangle {
                            id: markerRight
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2
                            radius: 5
                            color: actualList.markerColor
                        }
                    }
                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }

                delegate: CurrentItem {
                    id: currentItem
                    required property DesktopEntry modelData
                    iconUrl: Quickshell.iconPath(modelData?.icon, "image-missing")
                    function launch_app2unit() {
                        let command = modelData.command[0];
                        Quickshell.execDetached(["notify-send", "-i", "process-stop-symbolic " + command]);
                        Quickshell.execDetached(["hyprctl", "dispatch", "--", "exec", "[workspace emptym] app2unit -s a " + command]);
                        // TODO add logic for terminal applications
                        Qt.quit();
                    // if (!commandArray || commandArray.length === 0) return;

                    //         // Strip desktop entry macros like %u, %f, etc. if they exist
                    //         let cleanCommand = commandArray[0].replace(/%[a-zA-Z]/g, "").trim();
                    }
                    onClicked: {
                        // modelData.execute();
                        launch_app2unit();
                    }
                    app: Text {
                        id: modelText
                        text: modelData.name
                        color: Qt.rgba(196 / 255, 203 / 255, 212 / 255, 1)
                        font {
                            pointSize: 11
                            family: "Mononoki Nerd Font"
                        }
                    }
                }
            }
        }
    }
}
