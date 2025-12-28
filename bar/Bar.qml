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
            implicitHeight: 20

            margins {
                left: 12
                right: 12
            }

            anchors {
                top: true
                left: true
                right: true
            }

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

            Rectangle {
                id: panel
                anchors.fill: parent
                //radius: 16
                color: 'transparent'

                RowLayout {
                    id: leftBlock
                    spacing: 0.4
                    anchors.left: parent.left
                    Workspaces {}
                    ActiveWindow {}
                }

                Mpris {
                    id: centerBlock
                }

                RowLayout {
                    id: rightBlock
                    anchors.right: parent.right
                    spacing: 10 //0.4::
                    // Layout.rightMargin: 50
                    Netspeed_darth {}
                    Resources {}
                    ClockWidget {}
                    Battery {}
                    SystemTrayy {}
                }
            }
        }
    }
}
