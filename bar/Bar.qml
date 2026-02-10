pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import "./time"
import Quickshell.Wayland
import "./systemTray"
import qs.themes
import qs.services

ShellRoot {
    id: root

    readonly property bool enableBar: BarState.enableBar

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barr
            WlrLayershell.namespace: "tildeBar"
            visible: root.enableBar

            // the screen from the screens list will be injected into this property
            required property var modelData
            screen: modelData   // ALl currently connected screens, updates as connected screens change. Reusing a window on every screen This creates an instance of your window once on every screen. As screens are added or removed your window will be created or destroyed on those screens.

            aboveWindows: false // true::
            color: Themes.barBg
            implicitHeight: 22//20
            margins.right: 6
            margins.left: 6

            anchors {
                top: true
                left: true
                right: true
            }

            RowLayout {
                id: panel
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent // TODO: layout.alignment instead
                    onWheel: wheel => {
                        if (wheel.angleDelta.y > 0) {
                            Hyprland.dispatch("workspace m-1");
                        } else if (wheel.angleDelta.y < 0) {
                            Hyprland.dispatch("workspace m+1");
                        }
                    }
                }

                RowLayout {
                    id: leftBlock
                    spacing: 0.4
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    // Workspaces {}
                    Workspaces2 {}
                    // implicitWidth: Math.min(implicitWidth, (centerBlock.x - mapToItem(parent, 0, 0).x) - 20)
                    ActiveWindow {}
                }

                Mpris {
                    id: centerBlock
                    // Layout.alignment: Qt.AlignVCenter | QtAlignHCenter
                    anchors.centerIn: parent
                    // Layout.fillWidth: true
                }

                RowLayout {
                    id: rightBlock
                    Layout.alignment: Qt.AlignRight
                    spacing: 7 //10, 0.4::

                    Netspeed_darth {}
                    Resources {}
                    ClockWidget {
                        acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton | Qt.ForwardButton | Qt.BackButton
                        onClicked: mouse => {
                            mouse.accepted = true;
                            if (mouse.button == Qt.LeftButton)
                                ResourcesState.resourcesVisible = !ResourcesState.resourcesVisible;
                            else if (mouse.button == Qt.RightButton)
                                NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
                        }
                    }
                    Battery {}
                    SystemTray {}
                }
            }
        }
    }
}
