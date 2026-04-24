//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.bar
import qs.notBar
import qs.notBar.misc
import qs.notBar.rofi.appLauncher
import qs.notBar.rofi.openWindows

ShellRoot {
    Bar {}
    Volume {}
    IpcHandler {}
    NotificationOverlay {}
    Activate {}
    AppLauncher {}
    OpenWindows {}
}
