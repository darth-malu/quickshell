import Quickshell
// import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// import QtQuick.Controls

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
            colors.map(color => mzazi.color = Qt.color(color));
        }
    }
}
