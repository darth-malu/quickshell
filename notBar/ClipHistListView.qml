import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick
import QtQuick.Controls

/*
Functional Requirements:
+ Grab cliphist list
+ Tabulate ListView with the list as model
+ Cliphist decode on return
+ wl-copy the output of !!
+ Qt.quit() frame
 */

PanelWindow {
    id: root
    implicitWidth: 380
    implicitHeight: 250
    focusable: true
    color: 'transparent'
    exclusionMode: ExclusionMode.Ignore

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

    WrapperRectangle {
        id: parentRect
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

                // source:
                // implicitWidth
                // implicitHeight
                IconImage {}

                TextField {
                    id: searchHistory
                    enabled: true
                    hoverEnabled: true
                    maximumLength: 10
                    background: Rectangle {
                        color: 'red'
                    }
                }
            }

            ListView {
                id: cliphistList
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: {
                    // cliphist
                }
            }
        }
    }
}
