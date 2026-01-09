import QtQuick
import QtQuick.Layouts
import qs.customItems
import qs.services
import qs.themes

RowLayout {
    id: root
    visible: NetworkState.netspeedVisible
    readonly property real upload: NetworkState.upload
    readonly property real download: NetworkState.download
    spacing: 10

    BarBlock {
        id: download

        content: BarText {
            symbolText: `↘ ${root.download}`
            font: Themes.quick_medium
        }
    }
    BarBlock {
        id: upload

        content: BarText {
            symbolText: `↗ ${root.upload}`
            font: Themes.quick_medium
        }
    }
}
