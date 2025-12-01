import QtQuick
import qs.services

Text {
    id: myText
    readonly property real chop: 95
    text: {
        var str = ActiveWindowState.currentWindow;
        return str.length > chop ? str.slice(0, chop) + '..' : str;
    }
    color: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) //#8390FA
    leftPadding: 10
    font {
        family: 'quicksand'
        bold: true
        pointSize: 10
    }
}
