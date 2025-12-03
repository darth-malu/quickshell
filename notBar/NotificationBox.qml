pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import qs
import qs.customItems
import qs.services

WrapperMouseArea {
    id: root

    acceptedButtons: Qt.AllButtons
    hoverEnabled: true

    property Notification n
    property real timestamp
    property real elapsed: Date.now()
    property string image: (n.image == "" && n.appIcon != "") ? n.appIcon : n.image
    property bool hasAppIcon: !(n.image == "" && n.appIcon != "")
    property int indexPopup: -1
    property int indexAll: -1

    property real iconSize: 98 // TODO make smaller for !mpd && !spotify
    property real iconRadius: 12

    property bool showTime: false
    property bool expanded: false

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton && root.n.actions != []) {
            root.n.actions[0].invoke();
        } else if (mouse.button == Qt.RightButton) {
            if (indexAll != -1)
                NotificationState.notifDismissByAll(indexAll);
            else if (indexPopup != -1)
                NotificationState.notifDismissByPopup(indexPopup);
        } else if (mouse.button == Qt.MiddleButton) {
            NotificationState.dismissAll();
        }
    }

    ElapsedTimer {
        id: elapsedTimer
    }

    Timer {
        running: root.showTime
        interval: 1000
        repeat: true
        onTriggered: root.elapsed = elapsedTimer.elapsed()
    }

    Rectangle {
        id: outerBox
        // implicitWidth: Math.max(250, bodyText.implicitWidth) // TODO Make This shrink based on content , but with min
        implicitWidth: Math.max(250, mainLayout.implicitWidth) // TODO Make This shrink based on content , but with min
        // implicitWidth: mainLayout.implicitWidth
        // implicitWidth: contentLayout.implicitWidth
        implicitHeight: mainLayout.implicitHeight
        radius: 16
        color: Colors.bgBlur
        // Layout.margins: 12

        RowLayout {
            id: mainLayout

            spacing: 8 // picture and text space

            // anchors {
            //     top: parent.top
            //     left: parent.left
            //     right: parent.right
            // }

            Item { // songart parent item
                id: coverItem
                visible: root.image != ""
                // Layout.alignment: Qt.AlignTop
                implicitWidth: root.iconSize
                implicitHeight: root.iconSize
                // Layout.margins: 2 //12::
                // ADD PADDING/MARGINS TO CREATE SPACE AROUND THE CONTENT
                Layout.topMargin: 2
                Layout.bottomMargin: 2
                Layout.leftMargin: 2
                Layout.rightMargin: 0
                // Layout.minimumWidth: 200
                // Layout.fillWidth: true
                //Layout.rightMargin: 4 // NOTE noeffect??

                ClippingWrapperRectangle {
                    id: songArt
                    anchors.centerIn: parent
                    radius: 12
                    // TODO make only TopLeft/bottom radius
                    //color: "transparent" // NOTE noeffect
                    IconImage {
                        implicitSize: coverItem.height
                        source: Utils.getImage(root.image)
                        asynchronous: true
                    }
                }

                ClippingWrapperRectangle {
                    visible: root.hasAppIcon /* TODO: see when this triggers*/
                    radius: 2
                    color: "red"
                    anchors {
                        horizontalCenter: coverItem.right
                        verticalCenter: coverItem.bottom
                        horizontalCenterOffset: -4
                        verticalCenterOffset: -4
                    }
                    IconImage {
                        implicitSize: 16
                        source: Utils.getImage(root.n.appIcon)
                        asynchronous: true
                    }
                }
            }

            ColumnLayout {
                id: contentLayout
                Layout.fillWidth: true // TODO: see if usefull really lol
                //Layout.leftMargin: coverItem.visible ? 4 : 12
                Layout.rightMargin: 4
                spacing: 4
                RowLayout {
                    // Layout.maximumWidth: contentLayout.width - buttonLayout.width
                    // Layout.maximumWidth: contentLayout.width
                    Text {
                        id: summary
                        // Layout.alignment: Qt.AlignRight
                        text: root.n.summary
                        // elide: Text.ElideRight
                        // wrapMode: Text.Wrap
                        font {
                            pointSize: 10
                            family: 'Quicksand medium'
                            weight: Font.Bold
                            bold: true
                        }
                    }
                    Text {
                        id: currentTime
                        visible: root.showTime
                        Layout.alignment: Qt.AlignRight
                        text: Utils.humanTime(root.timestamp, root.elapsed)
                    }
                }

                Text {
                    id: bodyText
                    // Layout.fillWidth: true
                    Layout.maximumWidth: 500 // For absurdly long stuff
                    Layout.preferredWidth: implicitWidth
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.weight: Font.Medium
                    maximumLineCount: root.expanded ? 10 : (root.n.actions.length > 1 ? 1 : 2)
                    text: root.n.body
                }

                RowLayout {
                    visible: root.n.actions.length > 1

                    Layout.fillWidth: true
                    implicitHeight: actionRepeater.implicitHeight

                    Repeater {
                        id: actionRepeater
                        model: root.n.actions.slice(1)
                        // model: root.n.actions

                        WrapperMouseArea {
                            id: actionButtonMA
                            required property NotificationAction modelData

                            hoverEnabled: true
                            implicitHeight: actionButton.implicitHeight
                            Layout.fillWidth: true

                            onPressed: () => {
                                modelData.invoke();
                            }

                            Rectangle {
                                id: actionButton
                                radius: 16
                                color: actionButtonMA.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
                                implicitHeight: buttonText.implicitHeight
                                Layout.fillWidth: true

                                Text {
                                    id: buttonText

                                    anchors.centerIn: parent
                                    text: actionButtonMA.modelData.text
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            id: buttonLayout
            visible: root.containsMouse
            implicitHeight: 16

            anchors {
                top: parent.top
                right: parent.right
                topMargin: 8
                rightMargin: 8
            }

            WrapperMouseArea {
                id: expandButton

                visible: bodyText.text.length > (root.n.actions.length > 1 ? 50 : 100)

                property string sourceIcon: root.expanded ? "go-up-symbolic" : "go-down-symbolic"

                hoverEnabled: true
                Layout.fillHeight: true
                implicitWidth: 16

                onPressed: () => root.expanded = !root.expanded

                Rectangle {
                    // radius: 16
                    radius: implicitHeight / 2
                    color: expandButton.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
                    implicitWidth: 16
                    implicitHeight: 16

                    IconImage {
                        source: Quickshell.iconPath(expandButton.sourceIcon)
                        anchors.centerIn: parent
                        implicitHeight: parent.implicitHeight - 4
                        implicitWidth: parent.implicitHeight - 4
                        asynchronous: true
                        /* isMask: true */
                        //color: 'white'
                    }
                }
            }

            WrapperMouseArea {
                id: closeButton

                hoverEnabled: true
                Layout.fillHeight: true
                implicitWidth: 16

                onPressed: () => {
                    if (root.indexAll != -1)
                        NotificationState.notifCloseByAll(root.indexAll);
                    else if (root.indexPopup != -1)
                        NotificationState.notifCloseByPopup(root.indexPopup);
                }

                Rectangle {
                    radius: 16
                    color: closeButton.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
                    implicitWidth: 16
                    implicitHeight: 16

                    IconImage {
                        source: Quickshell.iconPath("process-stop-symbolic")
                        anchors.centerIn: parent
                        implicitHeight: parent.implicitHeight - 4
                        implicitWidth: parent.implicitHeight - 4
                        asynchronous: true
                        //isMask: true
                        //color: Colors.foreground
                    }
                }
            }
        }
    }
}
