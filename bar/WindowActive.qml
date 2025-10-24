//pragma Singleton
import QtQuick
import qs.customItems
import Quickshell
import Quickshell.Hyprland


Text {
    property var acWindow: Hyprland.activeToplevel
    id: myText
    text: acWindow?.title ?? ""
    color: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) //#8390FA
    leftPadding: 10
    font {
        family: 'quicksand'
        bold: true
        pointSize: 10
    }
    //anchors.leftMargin: 100
}
