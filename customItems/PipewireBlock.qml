import QtQuick
import Quickshell.Services.Pipewire
import qs.customItems
import qs.themes
import QtQuick.Layouts
import qs.services

BarBlock {
    id: root
    visible: PipewireState.pipewireReady

    //underline: true
    readonly property int textSize: 8
    property string textFont: 'quicksand'
    readonly property bool textBold: true
    readonly property color volumeColor: "#ccccccff"
    readonly property PwNode outputSink: PipewireState.outputSink
    readonly property PwNode inputSink: PipewireState.inputSink

    content: RowLayout {
        BarText {
            id: outputSink
            symbolText: `🔈 ${PipewireState.outputVolume}` /*󰓃*/
            color: root.volumeColor
            renderNative: true
            font {
                pixelSize: 12
                bold: true
                family: root.textFont
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: event => {
                    if (!root.outputSink?.audio)
                        return;
                    const step = 4;
                    let volume = root.outputSink.audio.volume * 100;
                    volume += event.angleDelta.y > 0 ? step : -step;
                    volume = Math.max(0, Math.min(volume, 100));
                    Pipewire.defaultAudioSink.audio.volume = volume / 100;
                }
                onClicked: mouse => {
                    // mouse.accepted = true;
                    if (mouse.button == Qt.LeftButton)
                        NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
                    else if (mouse.button == Qt.RightButton) {
                        Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                    }
                }
            }
        }
        BarText {
            id: inputSink
            symbolText: `🎙️ ${PipewireState.inputVolume} `
            color: root.volumeColor
            visible: PipewireState.isCrusherWireless
            renderNative: true
            font: Themes.quicksand

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton | Qt.RightButton | PointerDevice.Mouse | PointerDevice.TouchPad

                onWheel: event => {
                    if (!root.inputSink?.audio)
                        return;
                    const step = 4;
                    let volume = root.inputSink.audio.volume * 100;
                    volume += event.angleDelta.y > 0 ? step : -step;
                    volume = Math.max(0, Math.min(volume, 100)); // Clamp 0% - 100% even with continued scrolling
                    Pipewire.defaultAudioSource.audio.volume = volume / 100;
                }

                onClicked: mouse => {
                    // mouse.accepted = true;
                    if (mouse.button == Qt.LeftButton)
                        NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
                    else if (mouse.button == Qt.RightButton) {
                        Pipewire.defaultAudioSource.audio.muted = !Pipewire.defaultAudioSource.audio.muted;
                    }
                }
            }
        }
    }
}
