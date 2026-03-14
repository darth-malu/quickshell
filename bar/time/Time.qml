pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string time: {
        Qt.formatDateTime(clock.date, "h:mm"); //ddd MMM d hh:mm:ss AP t yyyy
    }

    readonly property string dateYangu: {
        Qt.formatDateTime(clock.date, "d ddd, MMMM");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes //Seconds::, Minutes
    }
}
