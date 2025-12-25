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
}
