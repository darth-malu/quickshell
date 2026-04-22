pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    readonly property var topLevelWindows: Hyprland.toplevels // RET list<toplevels>

    function filter(query) {
        const q = query.toLowerCase().trim();
        if (!q)
            return topLevelWindows;

        return topLevelWindows.values.filter(window => window.wayland.title.toLowerCase().includes(q));
    }
}
