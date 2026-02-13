pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property color barBg: 'transparent'

    readonly property font quick_medium: Qt.font({
        family: "Quicksand Medium",
        pixelSize: 13,
        bold: false
    })

    readonly property font quicksand: Qt.font({
        family: "quicksand",
        pixelSize: 12,
        bold: true
    })

    readonly property font lato: Qt.font({
        pixelSize: 13,
        family: 'lato',
        bold: true
    })

    readonly property color windowTextColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1) //#8390FA

    readonly property font windowTextFont: ({
            family: "Quicksand Medium",
            pixelSize: 13,
            bold: true
        })

    readonly property color activeWorkspaceIdColor: "#5c0099"

    readonly property color inactiveTextColor: Qt.rgba(0.67, 0.55, 0.93, 0.88)

    readonly property color activeWorkspaceColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)

    readonly property color activeWorkspaceTextColor: "#A020F0" //Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)

    readonly property color glassTintActiveHasClients: Qt.rgba(1, 1, 1, 0.25)

    readonly property color glassTintInactive: Qt.rgba(1, 1, 1, 0.1)

    readonly property color currentMonitorNotActiveColor: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 1)

    readonly property color inActiveWorkspaceTextColor: Qt.color("grey")

    readonly property color dropShadow: "#000000"

    readonly property color toxicGreen: "#88FF00"

    readonly property color mprisTextColor: "#FAAB8DED"
    readonly property color mprisVolumeColor: "#ff79c6"

    property string buttonBorderColor: "#99000000"

    property bool buttonBorderShadow: false

    property Gradient buttonInactiveGradientV: Gradient {
        GradientStop {
            position: 0.0
            color: Qt.rgba(1, 1, 1, 0.04)
        }
        GradientStop {
            position: 0.5
            color: Qt.rgba(1, 1, 1, 0.10)
        }
        GradientStop {
            position: 1.0
            color: Qt.rgba(1, 1, 1, 0.07)
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
            color: "#55000000"//Qt.rgba(1, 1, 1, 0.25)//"#99000000"
        }
        GradientStop {
            position: 0.3
            color: "#55000000"//"#55000000", Qt.rgba(1, 1, 1, 0.25)
        }
        GradientStop {
            position: 1.0
            color: Qt.rgba(171 / 255, 141 / 255, 237 / 255, 0.85)
        }
    }
}
