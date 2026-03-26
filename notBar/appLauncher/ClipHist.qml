import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: clipHist
    implicitWidth: 380
    implicitHeight: 250
    focusable: true
    color: "transparent"
    WlrLayershell.keyboardFocus: WlrLayerShell.OnDemand
    WlrLayershell.layer: WlrLayerShell.Overlay
}
