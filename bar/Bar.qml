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
            color: Themes.bar_bg
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
                    anchors.fill: parent
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
                    Layout.alignment: Qt.AlignLeft
                    Workspaces {}
                    ActiveWindow {}
                }

                Mpris {
                    id: centerBlock
                    // Layout.alignment: Qt.AlignCenter
                    anchors.centerIn: parent
                }

                RowLayout {
                    id: rightBlock
                    Layout.alignment: Qt.AlignRight
                    spacing: 10 //0.4::

                    // Netspeed_darth {}
                    Resources {}
                    ClockWidget {
                        onClicked: ResourcesState.resourcesVisible = !ResourcesState.resourcesVisible
                    }
                    Battery {}
                    SystemTray {}
                }
            }
        }
    }
}
