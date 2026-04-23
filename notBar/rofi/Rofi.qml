import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

PanelWindow {
    id: launcher
    implicitWidth: 580          // TODO...clamp max min
    implicitHeight: 250
    color: "transparent"
    focusable: true
    exclusionMode: ExclusionMode.Ignore

    default property Item content     // TODO see if ListView type works directly...inherits from flickable

    // WlrLayershell.keyboardFocus: WlrLayerShell.OnDemand
    // WlrLayershell.layer: WlrLayer.Overlay
    required property var modelIngest
    required property Component delegateIngest

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
                            itemLauncher.decrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down || (event.key === Qt.Key_J && event.modifiers & Qt.ControlModifier)) {
                            itemLauncher.incrementCurrentIndex();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (itemLauncher.currentItem) {
                                itemLauncher.currentItem.modelData.wayland.activate();
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
                id: itemLauncher
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
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
