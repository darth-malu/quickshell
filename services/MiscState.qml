pragma Singleton
import Quickshell

Singleton {
    id: root

    property bool activateLinux: false
    property bool toggleSysTray: false

    property date currentDate: new Date()

    property bool showPopup: false
}
