import QtQuick
import Quickshell.Services.Pipewire
import qs.customItems
import qs.services

BarBlock {
    id: text
    visible: PipewireState.pipewireReady

    //underline: true
    readonly property int textSize: 8
    property string textFont: 'quicksand'
    readonly property bool textBold: true
    readonly property color volumeColor: "#ccccccff"
    readonly property PwNode defaultOut: PipewireState.outputSink
    /* readonly property PwNode defaultIn: PipewireState.inputSink */

    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            if (!text.defaultOut?.audio)
                return;
            const step = 4;
            let volume = text.defaultOut.audio.volume * 100;
            volume += event.angleDelta.y > 0 ? step : -step;
            volume = Math.max(0, Math.min(volume, 100)); // Clamp 0% - 100% even with continued scrolling
            Pipewire.defaultAudioSink.audio.volume = volume / 100;
        }
        onClicked: NetworkState.netspeedVisible = !NetworkState.netspeedVisible
    }

    content: BarText {
        id: volumeOut
        symbolText: `🔈 ${PipewireState.volume}` /*󰓃*/
        color: text.volumeColor
        renderNative: true
        font {
            pixelSize: 12
            bold: true
            family: text.textFont
        }
    }
}
