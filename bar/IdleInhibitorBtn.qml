import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import QtQuick.Controls

// ClippingWrapperRectangle {
//     color: 'red'
//     implicitHeight: 20
//     implicitWidth: 20
//     radius: height / 2
//     // margin: 1
//     Button {
//         text: '👁'
//         // width: 2
//         display: AbstractButton.IconOnly
//         icon {
//             name: "process-stop-symbolic"
//             // source: Qt.iconPath("process-stop-symbolic")
//             width: 20
//             color: 'red'
//             height: 20
//         }
//         // highlighted: true
//         onClicked: {
//             Quickshell.execDetached(["notify-send", "This works"]);
//         }
//     }
// }

Rectangle {
    id: mzazi
    implicitHeight: 11
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: 11
    radius: height / 2
    color: 'orange'
    signal clicked

    property Item mouseArea: MouseArea

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }

    Connections {
        target: mzazi
        function onClicked() {
            const colors = ["red", "white", "black"];
            Quickshell.execDetached(["notify-send", "This works"]);
            mzazi.color = 'red';
        }
    }
}
