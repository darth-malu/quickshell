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

    property string buttonBorderColor: "#99000000"
    property bool buttonBorderShadow: false
    property Gradient buttonInactiveGradientV: Gradient {
        GradientStop {
            position: 0.0
            color: "#55FFFFFF"
        }
        GradientStop {
            position: 0.5
            color: "#22FFFFFF"
        }
        GradientStop {
            position: 1.0
            color: "black"
        }
    }

    property Gradient buttonInactiveGradientH: Gradient {
        orientation: Gradient.Horizontal
        GradientStop {
            position: 0.0
            color: "black"
        }
        GradientStop {
            position: 0.1
            color: "#00000000"
        }
    }
    property Gradient buttonActiveGradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#99000000"
        }
        GradientStop {
            position: 0.3
            color: "#55000000"
        }
        GradientStop {
            position: 1.0
            color: "#55000000"
        }
    }
}
