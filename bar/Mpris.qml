import QtQuick
import Quickshell.Services.Mpris
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.customItems
import qs.themes

Loader {
    id: mprisLoader

    active: MprisState.player != null && MprisState.mprisVisible

    required property var host

    sourceComponent: WrapperMouseArea {
        id: mprisRoot

        hoverEnabled: true

        acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton | Qt.ForwardButton | Qt.BackButton

        property bool showVolume: false

        property bool showPlayer: MprisState.player?.isPlaying

        property bool showPopup: false

        PopupWindow {
            id: popup
            anchor {
                window: host
                rect {
                    x: host.width / 2 - width / 2
                    y: host.height //35
                }
            }
            visible: showPopup
            // color: '#0D0814'
            color: 'transparent'
            implicitWidth: Math.min(500, parentRect.implicitWidth + 10)

            Rectangle {
                id: parentRect
                radius: 6
                // color: 'black'
                anchors.fill: parent
                implicitWidth: playersContainer.implicitWidth

                color: Qt.rgba(0.1, 0.04, 0.18, 0.7) // The "Glass" Color - Dark with a purple tint and transparency
                border {
                    width: 1
                    color: "#A020F0" // Qt.rgba(0.63, 0.13, 0.94, 0.3)
                }

                ColumnLayout {
                    id: playersContainer
                    anchors.fill: parent

                    Repeater {
                        id: playerRepeater
                        model: Mpris.players
                        Layout.fillWidth: true
                        delegate: MouseArea {
                            required property var modelData
                            hoverEnabled: true
                            Layout.fillWidth: true
                            implicitHeight: innerRow.implicitHeight
                            implicitWidth: innerRow.implicitWidth
                            onPressed: () => {
                                modelData.raise();
                            }
                            RowLayout {
                                id: innerRow
                                // Layout.margins: 10
                                spacing: 8

                                Rectangle {
                                    Layout.leftMargin: 1
                                    implicitWidth: 3
                                    implicitHeight: player_popup.implicitHeight - 3
                                    radius: 2
                                    color: modelData.playbackState === MprisPlaybackState.Playing ? "#88FF00" : "transparent"
                                }

                                BarText {
                                    id: player_popup
                                    text: modelData.identity
                                    color: modelData.playbackState === MprisPlaybackState.Playing ? Themes.toxicGreen : "#B8C1C9"
                                    elide: Text.elideRight
                                }

                                BarText {
                                    id: title_popup
                                    renderNative: true
                                    text: modelData?.trackTitle ?? "❌"
                                    color: Themes.mprisTextColor
                                    font: Themes.quick_medium
                                    elide: Text.elideRight
                                }
                            }
                        }
                    }
                }
            }
        }

        Timer {
            id: hideVolumeTimer
            interval: 1000
            repeat: false
            running: false
            onTriggered: mprisRoot.showVolume = false
        }

        onExited: {
            hideVolumeTimer.restart();
        }

        onClicked: mouse => {
            mouse.accepted = true; // Prevent background click
            if (mouse.button == Qt.LeftButton)
                MprisState.player?.togglePlaying();
            else if (mouse.button == Qt.RightButton)
                MprisState.player?.next();
            else if (mouse.button == Qt.MiddleButton)
                MprisState.player?.raise();
            else if (mouse.button == Qt.ForwardButton)
                showPopup = !showPopup;
        // MprisState.player?.next();
        // else if (mouse.button == Qt.BackButton)
        //     MprisState.player?.previous();
        }

        onWheel: event => {
            if (!MprisState.player?.isPlaying)
                return;

            if (MprisState.player?.volumeSupported) {
                
              let vol = MprisState.player.volume * 100; // Convert current volume (0.0–1.0) to percent

              vol += event.angleDelta.y > 0 ? 4 : -4; // Scroll up increases, down decreases

              vol = Math.max(0, Math.min(vol, 100)); // Clamp between 0% and 100%

              MprisState.player.volume = vol / 100; // Apply back to player

              mprisRoot.showVolume = true;
            }
        }

        RowLayout {
            visible: mprisRoot.showPlayer

            ClippingWrapperRectangle {
                id: albumArt
                // TODO Hover To view alburm art in bigger size
                visible: MprisState.mprisArtVisible
                radius: height / 2
                implicitWidth: 24
                implicitHeight: 24
                Image {
                    id: albumArtImage
                    anchors.fill: parent
                    source: MprisState.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }
            }

            BarText {
                id: title
                renderNative: true
                text: {
                    let strLength = 50;
                    var str = MprisState.player?.trackTitle ?? "";
                    return str.length > strLength ? str.slice(0, strLength) + '..' : str;
                }
                color: Themes.mprisTextColor
                font: Themes.quick_medium
            }

            BarText {
                id: volumePlayer
                visible: mprisRoot.showVolume
                text: Math.round(MprisState.player?.volume * 100) ?? ""
                font: Themes.lato
                color: Themes.mprisVolumeColor
            }
        }
    }
}
