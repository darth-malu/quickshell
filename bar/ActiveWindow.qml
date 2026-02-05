import QtQuick
import qs.services
import qs.themes
import Qt5Compat.GraphicalEffects

Text {
    id: myText
    readonly property int chop: 95
    text: {
        var str = ActiveWindowState.currentWindow;
        return str.length > chop ? str.slice(0, chop) + '..' : str;
    }
    color: Themes.windowTextColor
    leftPadding: 15
    font: Themes.windowTextFont
    renderType: Text.NativeRendering
}
