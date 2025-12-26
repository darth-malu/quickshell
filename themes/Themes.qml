pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // property string wallpaper: 'url'

    property color bar_bg: 'transparent'

    readonly property string quick_medium: {
        pixelSize: 12;
        bold: true;
        family: "quicksand medium";
    }
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 9a47f09 (+tang)

    readonly property string lato: {
        pixelSize: 7;
        bold: true;
        family: "lato";
    }
    // TODO: loook into declaring font items

    // WORKSPACE -> Colors
    readonly property color activeWorkspaceIdColor: "#5c0099"

    readonly property color inactiveTextColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 0.88)

    readonly property color activeWorkspaceColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)

    readonly property color currentMonitorNotActiveColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)
<<<<<<< HEAD
>>>>>>> 543f7c1 (IPC handler unified, barstate, fonts broken themes)
=======
>>>>>>> 9a47f09 (+tang)
}
