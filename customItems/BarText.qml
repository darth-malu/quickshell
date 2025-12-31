import QtQuick
import Qt5Compat.GraphicalEffects

Text {
    id: root
    property string mainFont: "quicksand"
    property string symbolFont: "Symbols Nerd Font Mono"
    property int pointSize: 12
    property bool renderNative: false
    property int symbolSize: pointSize * 1.10 // 1.37
    property string symbolText
    property bool dim
    property color baseColor: "#D295BF"

    color: dim ? "#CCCCCC" : baseColor
    text: wrapSymbols(symbolText)
    renderType: this.renderNative ?? Text.NativeRendering // FIXME: doubles clocwidget
    textFormat: Text.RichText //PlainText, RichText

    font {
        family: mainFont
        pixelSize: pointSize
        bold: true
    }

    Text {
        id: textcopy
        // padding: root.padding
        visible: true
        text: parent.text
        textFormat: parent.textFormat
        color: parent.color
        font: parent.font
    }

    DropShadow {
        visible: textcopy.visible
        anchors.fill: parent
        horizontalOffset: 1
        verticalOffset: 1
        color: "#000000"
        source: textcopy
    }

    function wrapSymbols(text) {
        if (!text)
            return "";

        const isSymbol = codePoint => (codePoint >= 0xE000 && codePoint <= 0xF8FF) // Private Use Area
            || (codePoint >= 0xF0000 && codePoint <= 0xFFFFF) // Supplementary Private Use Area-A
            || (codePoint >= 0x100000 && codePoint <= 0x10FFFF); // Supplementary Private Use Area-B

        return text.replace(/./gu, c => isSymbol(c.codePointAt(0)) ? `<span style='font-family: ${symbolFont};font-size: ${symbolSize}px'>${c}</span>` : c); //  letter-spacing: -5px;
    }
}
