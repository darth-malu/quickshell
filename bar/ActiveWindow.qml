import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.services


Text {
    id: myText
    text: ActiveWindowState.currentWindow
    color: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) //#8390FA
    leftPadding: 10
    font {family: 'quicksand' ;bold: true ;pointSize: 10;}
}
