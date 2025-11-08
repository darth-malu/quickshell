import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick 

PanelWindow {
        id: launcher
        implicitWidth: 350
        implicitHeight:350
        color: "transparent"
        focusable: true

        WrapperRectangle {
            id: wrap
            color: white

            implicitWidth: 300
            implicitHeight:300
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 6

                TextField {
                    id: search

                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 30

                    placeholderText: "Type to search"

                    enabled: true
                    focus: true
                    activeFocusOnPress: true
                }
                ListView {
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 500

                    model: DesktopEntries.applications.values.filter(a => a.name.includes(search.text))

                    delegate: Text {
                        required property DesktopEntry modelData
                        text: modelData.name
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // launch the app
                                modelData.execute()
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
