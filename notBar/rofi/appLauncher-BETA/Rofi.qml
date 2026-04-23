import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

PanelWindow {
    id: launcher
    implicitWidth: 380          // TODO...clamp max min
    implicitHeight: 250
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore

    default property Item content     // TODO see if ListView type works directly...inherits from flickable

    property var command

    property bool isCurrentItem: (parent.currentItem == 0)

    function launch_app2unit() {
        // Ensure the command after 'exec' is a single string
        Quickshell.execDetached(["notify-send", `your cmd: "${command}"`]);
        Quickshell.execDetached(["hyprctl", "dispatch", "exec", `[workspace emptym] app2unit -s a "${command}"`]);
    }
    // WlrLayershell.keyboardFocus: WlrLayerShell.OnDemand
    // WlrLayershell.layer: WlrLayer.Overlay
    required property Component delegateIngest

    property var modelIngest: AppData.filter(search.text)

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
                    Layout.leftMargin: 6
                    // enabled: true
                    // hoverEnabled: true // whether this TF accepts hover events
                    maximumLength: 10
                    color: search.enabled ? Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) : 'red'
                    rightInset: 20
                    background: Rectangle {
                        color: 'transparent'
                    }
                    Keys.onPressed: event => {
                        const isCtrlJ = event.key === Qt.Key_J && event.modifiers & Qt.ControlModifier;
                        const isCtrlK = event.key === Qt.Key_K && event.modifiers & Qt.ControlModifier;

                        if (event.key === Qt.Key_Up || isCtrlK) {
                            itemLauncher.decrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down || isCtrlJ) {
                            itemLauncher.incrementCurrentIndex();
                            event.accepted = true;
                        }
                    }
                    onAccepted: {
                        if (itemLauncher.currentItem) {
                            itemLauncher.currentItem.modelData.execute();
                            Quickshell.execDetached(["notify-send", `${itemLauncher.currentItem.modelData.execute}`]);
                            Qt.quit();
                        }
                    }
                }
            }

            ListView {
                id: itemLauncher
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                // keyNavigationWraps: true
                // highlightMoveDuration: 150

                signal accepted(var item)

                // required property var model

                property var inputText

                // property alias modelIngest: root.model

                // TODO outsrc this
                model: launcher.modelIngest

                highlight: HighlightItem {}

                // TODO outsrc this
                delegate: launcher.delegateIngest
            }
        }
    }
}
