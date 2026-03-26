import QtQuick.Layouts
import QtQuick
import qs.customItems
import qs.themes
import Quickshell.Services.Mpris

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
            implicitWidth: innerRow.width
            onPressed: () => {
                modelData.raise();
            }
            RowLayout {
                id: innerRow
                spacing: 8

                Rectangle {
                    id: activeIndicator
                    visible: true
                    Layout.leftMargin: 1
                    implicitWidth: 3
                    implicitHeight: players.implicitHeight - 3
                    radius: 2
                    color: modelData.playbackState === MprisPlaybackState.Playing ? Themes.mprisIndicatorColor : "transparent"
                }

                BarText {
                    id: players
                    text: modelData.identity
                    color: modelData.playbackState === MprisPlaybackState.Playing ? Themes.toxicGreen : "#B8C1C9"
                    elide: Text.elideRight
                }

                BarText {
                    id: playersMediaPlaying
                    renderNative: true
                    text: modelData.trackTitle || "❌"
                    color: Themes.mprisTextColor
                    font: Themes.quick_medium
                    elide: Text.elideRight
                }
            }
        }
    }
}
