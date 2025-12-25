pragma ComponentBehavior: Bound
// allows using outer component ids root.currentVolume
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.customItems

Scope {
    id: root
    property bool shouldShowOsd: false
    property var defaultSink: Pipewire.defaultAudioSink
    property var ifAudioNode: defaultSink?.audio // extra info if node sends/receives audio, if non-null node manages audio
    property var currentVolume: ifAudioNode?.volume

    // Bind the pipewire node so its properties eg.volume will be tracked
    PwObjectTracker {
        objects: [root.defaultSink]
    }

    Connections {
        target: root.ifAudioNode ?? null // NOTE: patch work

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    // PanelWindow.visible could be set instead of using a loader, but using a loader will reduce the memory overhead when the window isn't open.
    LazyLoader {
        active: root.shouldShowOsd
        PanelWindow {
            // Since the panel's screen is unset, it will be picked by the compositor when the window is created. Most compositors pick the current active monitor.
            anchors.right: true
            margins.right: screen.width / 95
            exclusiveZone: 0

            implicitWidth: 16
            implicitHeight: 200
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            ColumnLayout {
                anchors {
                    fill: parent
                    //leftMargin: 1
                    //rightMargin: 8
                    verticalCenter: parent.verticalCenter
                }

                /* IconImage { */
                /*   implicitSize: 16 */
                /*   source: "root:assets/speaker/icons8-speaker-30-4.png" */
                /*   asynchronous: true */
                /* } */

                Rectangle {
                    id: outerRectangle
                    Layout.fillWidth: true // Stretches to fill all left-over space
                    implicitHeight: 200
                    radius: width / 2
                    color: "#80000000"

                    Rectangle {
                        id: innerCurrentVolumeRectangle
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        implicitHeight: parent.height * (root.currentVolume ?? 0)
                        radius: parent.radius
                        color: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1.00) // '#bd93f9'

                        Text {
                            id: currentVolume
                            text: Math.floor(root.currentVolume * 100)
                            color: 'black'
                            // renderType: Text.NativeRendering
                            anchors {
                                leftMargin: 5
                                rightMargin: 5
                                centerIn: parent
                            }
                            font {
                                pixelSize: 11
                                family: 'Quicksand medium'
                                bold: true
                            }
                        }
                    }
                }
            }
        }
    }
}
