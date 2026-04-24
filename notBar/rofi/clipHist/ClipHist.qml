import QtQuick
import Quickshell
import qs.services
import qs.notBar.rofi

Rofi {
    visible: RofiState.toggleClipHist

    // TODO: INGEST CLIPHIST MODEL
    modelIngest: RofiState.filterApps(searchField)

    delegateIngest: LauncherDelegate {
        required property var modelData
        // TODO: default for all ? way to do pictures?...
        // TODO: try Quickshell.clipboard
        iconUrl: Quickshell.iconPath(modelData.icon, "image-missing")
        // app: TextAppLauncherDelegate {}
    }
}
