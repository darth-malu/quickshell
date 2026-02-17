import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick

PanelWindow {
    id: launcher
    implicitWidth: 350
    implicitHeight: 450
    color: "transparent"
    focusable: true

    WrapperRectangle {
        id: wrap
        color: "#1e1e2e"
        implicitWidth: 300
        implicitHeight: 300
        anchors.fill: parent

        Keys.onEscapePressed: launcher.visible = false
        focus: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 6

            TextField {
                id: search

                Layout.preferredWidth: 300
                Layout.preferredHeight: 30

                placeholderText: ""
                Keys.onEscapePressed: launcher.visible = false
                // enabled: true
                // focus: true
                hoverEnabled: true
                // activeFocusOnPress: true
                color: 'white'
            }

            ListView {
                Layout.preferredWidth: 300
                Layout.preferredHeight: 500

                model: DesktopEntries.applications.values.filter(a => a.name.includes(search.text))

                delegate: Text {
                    required property DesktopEntry modelData
                    text: modelData.name
                    color: 'white'
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            // launch the app
                            modelData.execute();
                            // TODO:
                            // Make ESC close the launcher
                            // Replicate my Rofi UI
                        }
                    }
                }
            }
        }
    }
}
