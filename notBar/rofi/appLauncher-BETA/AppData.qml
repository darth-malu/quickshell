pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property var allApps: DesktopEntries.applications.values // Cache the values once

    // readonly property var sortedApps: allApps.sort((a, b) => a.name.localeCompare(b.name))

    function filter(query) {
        if (!query)
            return allApps;
        const lowerQuery = query.toLowerCase();
        return allApps.filter(app => app.name.toLowerCase().includes(lowerQuery));
    }
}
