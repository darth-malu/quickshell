import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.customItems

WrapperMouseArea {
    id: mprisRoot

    visible: MprisState.player != null && MprisState.mprisVisible

    hoverEnabled: true

    anchors.centerIn: parent

    acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton | Qt.ForwardButton | Qt.BackButton

    property bool showVolume: false

    property int mprisFont: 13
    property bool mprisBold: false
    property bool volumeBold: true
    property int volumeFont: 12

    property bool showPlayer: !!(MprisState.player?.isPlaying && MprisState.player?.trackTitle !== "default" && !(MprisState.player?.trackTitle || "").includes("default"))

    Timer {
        id: hideVolumeTimer
        interval: 1000
        repeat: false
        running: false
        onTriggered: mprisRoot.showVolume = false
    }

    onContainsMouseChanged: {
        if (!containsMouse)
            hideVolumeTimer.restart();
        else
            hideVolumeTimer.stop();
    }

    onClicked: mouse => {
        mouse.accepted = true; // Prevent background click
        if (mouse.button == Qt.LeftButton) {
            MprisState.player?.togglePlaying();
        } else if (mouse.button == Qt.RightButton) {
            MprisState.player?.next();
        } else if (mouse.button == Qt.MiddleButton) {
            MprisState.player?.raise();
        } else if (mouse.button == Qt.ForwardButton) {
            MprisState.player?.next();
        } else if (mouse.button == Qt.BackButton) {
            MprisState.player?.previous();
        }
    }

    onWheel: event => {
        if (!MprisState.player?.isPlaying)
            return;
        let vol = MprisState.player.volume * 100; // Convert current volume (0.0–1.0) to percent

        vol += event.angleDelta.y > 0 ? 4 : -4; // Scroll up increases, down decreases

        vol = Math.max(0, Math.min(vol, 100)); // Clamp between 0% and 100%

        MprisState.player.volume = vol / 100; // Apply back to player

        mprisRoot.showVolume = true;
    }

    RowLayout {
        visible: mprisRoot.showPlayer

        ClippingWrapperRectangle {
            id: art
            // TODO Hover To view alburm art in bigger size
            visible: MprisState.mprisArtVisible
            radius: height / 2 // 6
            implicitWidth: 24
            implicitHeight: 24
            Image {
                id: artwork
                anchors.fill: parent
                source: MprisState.player?.trackArtUrl || ""
                fillMode: Image.PreserveAspectFit
                asynchronous: true
            }
        }

        BarText {
            id: title
            renderNative: true
            text: {
                let x = 50;
                var str = MprisState.player?.trackTitle || "";
                return str.length > x ? str.slice(0, x) + '..' : str;
            }
            color: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 0.98)
            font {
                pixelSize: mprisRoot.mprisFont
                family: 'Quicksand medium'
                bold: mprisRoot.mprisBold
            }
        }

        BarText {
            id: volumePlayer
            visible: mprisRoot.showVolume
            text: Math.round(MprisState.player?.volume * 100) ?? ""
            font {
                pixelSize: mprisRoot.mprisFont
                family: 'lato'
                bold: mprisRoot.volumeBold
            }
            //opacity: mprisRoot.showVolume ? 1 : 0
            //opacity: mprisRoot.containsMouse ? 1 : 0
            color: '#ff79c6'
            //Behavior on opacity { NumberAnimation { duration: 460 } }
        }
    }
}
