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

    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton //Qt.AllButtons
    hoverEnabled: true

    property Notification n
    property real timestamp
    property real elapsed: Date.now()

    /*
    IMAGE: icon associated with the notification eg. a profile picture in a messaging app
    appIcon: sending app's icon, if none provided .. the icon form an associated desktop entry will be retrieved. if none found = ""
     */
    property string image: (n.image == "" && n.appIcon != "") ? n.appIcon : n.image // Return appIcon of application or image if image present.
    property bool hasAppIcon: !(n.image == "" && n.appIcon != "") // negate ... no image + appIcon present = image + appIcon absent

    property int indexPopup: -1
    property int indexAll: -1

    property real iconSize: (n.appName == 'ncmpcpp' || n.appName == 'spotifY') ? 98 : 44
    property real iconRadius: Math.round(iconSize / 8)

    property bool showTime: true
    property bool expanded: false

    onClicked: mouse => {
        // actions: list <NotificationAction>
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
        implicitWidth: Math.max(100, mainLayout.implicitWidth + 10)
        implicitHeight: mainLayout.implicitHeight
        radius: root.iconSize / 6 // 16;;
        color: Colors.bgBlur

        RowLayout {
            id: mainLayout

            spacing: 8 // picture and text space
            Item { // songart parent item
                id: coverItem
                visible: root.image != ""
                // Layout.alignment: Qt.AlignTop
                implicitWidth: root.iconSize
                implicitHeight: root.iconSize
                Layout.topMargin: 2
                Layout.bottomMargin: 2
                Layout.leftMargin: 2
                Layout.rightMargin: 0
                // Layout.minimumWidth: 200
                // Layout.fillWidth: true

                ClippingWrapperRectangle {
                    id: songArt
                    anchors.centerIn: parent
                    radius: outerBox.radius - 2 // TODO make only TopLeft/bottom radius
                    IconImage {
                        implicitSize: coverItem.height
                        source: Utils.getImage(root.image)
                        asynchronous: true
                    }
                }

                ClippingWrapperRectangle {
                    visible: root.hasAppIcon
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
                        color: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 0.98)
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
                    // color: 'red'
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
                        model: root.n.actions.slice(1) // This returns array of all elements in root.n.actions after index [0] to end... TODO see why needed
                        // model: {
                        //     // console.log("Printing n.actions[]:", root.n.actions.slice(0)); // NOTE Empty always
                        //     return root.n.actions.slice(1); // This returns array of all elements in root.n.actions after index [0] to end
                        // }
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
