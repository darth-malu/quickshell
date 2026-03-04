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

            TextField {
                id: search

                Layout.fillWidth: true
                Layout.bottomMargin: 2
                placeholderText: ""
                enabled: true
                hoverEnabled: true
                color: search.enabled ? Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) : 'transparent'
                background: Rectangle {
                    color: 'transparent'
                    implicitHeight: 10
                    implicitWidth: 200
                    radius: 4
                    // The Search Icon
                    // IconImage {
                    //     anchors.left: parent.left
                    //     anchors.verticalCenter: parent.verticalCenter
                    //     anchors.leftMargin: 8
                    //     source: Quickshell.iconPath("system-search-symbolic", "search")
                    //     width: 18
                    //     height: 18
                    //     // Icon color changes to your teal accent when typing
                    //     // color: search.text.length > 0 ? "#3fa7c5" : Qt.rgba(1, 1, 1, 0.5)
                    // }
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
                            actualList.currentItem.modelData.execute();
                            Qt.quit();
                        }
                        event.accepted = true;
                    } else if (event.key === Qt.Escape)
                        Qt.quit();
                }
            }

            ListView {
                id: actualList
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: DesktopEntries.applications.values.filter(a => a.name.toLowerCase().includes(search.text))
                highlight: Item {
                    z: 8
                    Rectangle {
                        id: bg
                        anchors.fill: parent
                        color: Qt.rgba(72 / 255, 191 / 255, 227 / 255, 1)
                        // radius: 5
                        opacity: 0.13
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        // anchors.topMargin: 1
                        // anchors.bottomMargin: 1
                        width: 2
                        color: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)
                        radius: 5
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        // anchors.topMargin: 1
                        // anchors.bottomMargin: 1
                        width: 2
                        radius: 5
                        color: Qt.rgba(63 / 255, 167 / 255, 197 / 255, 0.82)
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
                    onClicked: {
                        modelData.execute();
                        Qt.quit();
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
