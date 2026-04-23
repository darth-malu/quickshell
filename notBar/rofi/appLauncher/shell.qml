import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

// import qs.services

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
    // readonly property list<DesktopEntry> allApps: DesktopEntries.applications.values

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
                    Layout.leftMargin: 6
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
                        const isCtrlJ = event.key === Qt.Key_J && event.modifiers & Qt.ControlModifier;
                        const isCtrlK = event.key === Qt.Key_K && event.modifiers & Qt.ControlModifier;

                        if (event.key === Qt.Key_Up || isCtrlK) {
                            actualList.decrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down || isCtrlJ) {
                            actualList.incrementCurrentIndex();
                            event.accepted = true;
                        }
                    }
                    onAccepted: {
                        if (actualList.currentItem) {
                            actualList.currentItem.modelData.execute();
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
                keyNavigationWraps: true
                // boundsBehavior: Flickable.StopAtBounds // Optional: cleaner scrolling feel

                // Smooth scrolling follow selection
                // highlightRangeMode: ListView.ApplyRange
                // snapMode: ListView.SnapToItem

                // Efficiency: Increase buffer for smoother scrolling
                // displayMarginBeginning: 40
                // displayMarginEnd: 40

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

                model: AppData.filter(search.text)

                highlight: Item {
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
                        }

                        Rectangle {
                            id: markerRight
                            anchors.right: parent.right
                            visible: true
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2
                            color: currentItemBg.markerColor
                        }
                    }
                }

                delegate: LauncherEntry {
                    required property DesktopEntry modelData
                    command: modelData.command.join(' ')
                    iconUrl: Quickshell.iconPath(modelData.icon, "image-missing")
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
