//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.bar
import qs.notBar

ShellRoot {
    //TODO: scope vs shellroot
    Bar {}
    Volume {}
    IpcHandler {}
    NotificationOverlay {}
}
