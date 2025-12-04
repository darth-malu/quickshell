import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import qs.customItems
import qs.services
import qs.themes

RowLayout {
    id: root
    visible: tog
    readonly property real upload: NetworkState.upload
    // readonly property string currentSpeed: NetworkState.readings
    readonly property real download: NetworkState.download
    property bool tog: false
    spacing: 10

    BarBlock {
        id: download

        content: BarText {
            // symbolText: download
            // symbolText: `↘ ${root.download}`
            symbolText: root.download < 0.2 ? "" : `↘ ${root.download}`
            font: Themes.quick_medium
        }
    }
    BarBlock {
        id: upload

        content: BarText {
            symbolText: root.upload < 0.2 ? "" : `↘ ${root.upload}`
            // symbolSize: 12
            font: Themes.quick_medium
        }
    }

    IpcHandler {
        target: "netspeed"
        function toggleNet(): void {
            root.tog = !root.tog;
        }
    }
}
