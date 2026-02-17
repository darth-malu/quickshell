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
                    text: modelData.trackTitle || "❌"
                    color: Themes.mprisTextColor
                    font: Themes.quick_medium
                    elide: Text.elideRight
                }
            }
        }
    }
}
