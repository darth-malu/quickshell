pragma Singleton

import Quickshell

/* import Quickshell.Io */
/* import QtQuick */

Singleton {
    id: root

    readonly property string time: {
        Qt.formatDateTime(clock.date, "h:mm"); //ddd MMM d hh:mm:ss AP t yyyy
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes //Seconds::, Minutes
    }
}
