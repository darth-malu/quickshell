import Quickshell
import QtQuick.Layouts
import qs.customItems
import QtQuick

PopupWindow {
    id: popup
    anchor {
        window: host
        rect {
            x: mprisLoader.x - 100
            y: 35
        }
    }
    visible: showPopup
    color: 'transparent'
    implicitWidth: child.width

    Rectangle {
        id: parentRect
        radius: 6
        color: 'white'
        anchors.fill: parent
        implicitWidth: playersContainer.width

        ColumnLayout {
            id: playersContainer
            anchors.fill: parent

            Repeater {
                id: playerRepeater
                model: Mpris.players
                delegate: RowLayout {
                    id: innerRow
                    Layout.margins: 10
                    spacing: 2

                    BarText {
                        id: player_popup
                        text: modelData.identity
                        color: 'red'
                    }

                    BarText {
                        id: title_popup
                        renderNative: true
                        text: {
                            let strLength = 50;
                            var str = modelData?.trackTitle ?? "";
                            return str.length > strLength ? str.slice(0, strLength) + '..' : str;
                        }
                        color: Themes.mprisTextColor
                        font: Themes.quick_medium
                    }
                }
            }
        }
    }
}
