import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.customItems
import qs.services

BarBlock {
    id: text
    visible: PipewireState.pipewireReady

    //underline: true
    readonly property int textSize: 8
    readonly property string textFont: 'inter'
    readonly property bool textBold: true
    readonly property color volumeColor: "#ccccccff"
    readonly property PwNode defaultOut: PipewireState.outputSink
    /* readonly property PwNode defaultIn: PipewireState.inputSink */


    MouseArea {
      anchors.fill: parent
      onClicked: Hyprland.dispatch("workspace 1")
      onWheel: (event) => {
        if (!defaultOut?.audio) return;
        const step = 4;
        let volume = defaultOut.audio.volume * 100;
        volume += event.angleDelta.y > 0 ? step : -step;
        volume = Math.max(0, Math.min(volume, 100)); // Clamp 0% - 100% even with continued scrolling
        Pipewire.defaultAudioSink.audio.volume = volume / 100;
      }
    }

    content: BarText {
        id: volumeOut
        symbolText: `🔈 ${PipewireState.volume}`
        color: text.volumeColor
        font {
            pixelSize: 12
            bold: false
            family: "quicksand medium"
        }
    }
}
