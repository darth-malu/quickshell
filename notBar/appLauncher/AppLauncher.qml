import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

// import Quickshell.Wayland
// TODO: make this launch only once per invocation

PanelWindow {
    id: launcher
    implicitWidth: 380
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

    Rectangle {
        id: wrap
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
                Text {
                    text: "  "
                    color: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)
                    horizontalAlignment: Qt.AlignRight
                }

                TextField {
                    id: search
                    Layout.fillWidth: true
                    Layout.bottomMargin: 2
                    // enabled: true
                    // hoverEnabled: true // whether this TF accepts hover events
                    maximumLength: 10
                    color: search.enabled ? Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) : 'red'
                    // implicitBackgroundHeight: 10
                    // implicitBackgroundWidth: 10
                    rightInset: 20
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
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | PointerDevice.Mouse | PointerDevice.TouchPad
                    onExited: {
                        if (!containsMouse)
                            Qt.quit();
                    }
                    propagateComposedEvents: true
                    // z: 1
                    // onContainsMouseChanged: {
                    //     if (!containsMouse && !search.hovered)
                    //         Qt.quit();
                    // }
                }
                model: {
                    if (search.text === "")
                        return DesktopEntries.applications.values;
                    const searchLower = search.text.toLowerCase();
                    return DesktopEntries.applications.values.filter(app => app.name.toLowerCase().includes(searchLower));
                }

                highlight: Item {
                    // z: 8
                    ClippingRectangle {
                        id: currentItemBg
                        anchors.fill: parent
                        color: Qt.rgba(72 / 255, 191 / 255, 227 / 255, 0.2)
                        readonly property color markerColor: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)
                        radius: 4

                        Rectangle {
                            id: markerLeft
                            visible: true
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2
                            color: currentItemBg.markerColor
                            radius: 5
                        }

                        Rectangle {
                            id: markerRight
                            anchors.right: parent.right
                            visible: true
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2
                            radius: 5
                            color: currentItemBg.markerColor
                        }
                    }
                    // Behavior on y {
                    //     SpringAnimation {
                    //         spring: 3
                    //         damping: 0.2
                    //     }
                    // }
                }

                delegate: CurrentItem {
                    id: currentItem
                    required property DesktopEntry modelData
                    command: modelData.command[0]
                    iconUrl: Quickshell.iconPath(modelData?.icon, "image-missing")
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
