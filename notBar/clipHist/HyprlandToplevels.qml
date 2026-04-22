import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

// import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: launcher
    implicitWidth: 580          // TODO...clamp max min
    implicitHeight: 250
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore

    // WlrLayershell.keyboardFocus: WlrLayerShell.OnDemand
    // WlrLayershell.layer: WlrLayer.Overlay

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

        Keys.onEscapePressed: Qt.quit()

        child: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout {
                spacing: 20

                Text {
                    text: "  "
                    color: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)
                    horizontalAlignment: Qt.AlignRight
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
                                actualList.currentItem.modelData.wayland.activate();
                                event.accepted = true;
                                Qt.quit();
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Escape) {
                            event.accepted = true;
                            Qt.quit();
                        }
                    }
                }
            }

            ListView {
                id: actualList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                // boundsBehavior: Flickable.StopAtBounds // Optional: cleaner scrolling feel
                model: {
                    if (search.text === "")
                        return Hyprland.toplevels;
                    const searchLower = search.text.toLowerCase();
                    return Hyprland.toplevels.values.filter(window => window.wayland.title.toLowerCase().includes(searchLower));
                }

                readonly property color markerColor: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)

                // snapMode: ListView.SnapToItem

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
                    // Behavior on y {
                    //     SpringAnimation {
                    //         spring: 3
                    //         damping: 0.2
                    //     }
                    // }
                }

                delegate: LauncherEntry {
                    id: currentItem
                    required property var modelData
                    iconUrl: Quickshell.iconPath(modelData?.wayland.appId, "image-missing")
                    // windowTitle: modelData.wayland.activate()
                    // onClicked: focusTopLevel() //modelData.execute()
                    app: Text {
                        id: modelText
                        text: modelData.wayland.title
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
