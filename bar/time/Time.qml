pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string time: {
        Qt.formatDateTime(clock.date, "h:mm"); //ddd MMM d hh:mm:ss AP t yyyy
    }

    readonly property string date: {
        Qt.formatDateTime(clock.date, "d ddd, MMMM");
    }

    readonly property string dateTime: {
        Qt.formatDateTime(clock.date, "d ddd, MMMM - HH:mm");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes //Seconds::, Minutes
    }
}
