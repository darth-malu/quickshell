pragma Singleton
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property var popupNotifs: []
    property var allNotifs: []
    property var defaultNotifTimeout: 5000
    property bool notifOverlayOpen: false // controls visibility of notBar/NotificationOverlay.qml
    property bool notifPanelOpen: false

    function togglePanel() {
        if (notifOverlayOpen && !notifPanelOpen)
            notifOverlayOpen = false; // close overlay if notifPanel is not open

        notifPanelOpen = !notifPanelOpen;
    }

    function onNewNotif(notif) {
        allNotifs = [notif, ...allNotifs];

        if (notif.lastGeneration) // if notif was carried over from last reload
            return;

        popupNotifs = [notif, ...popupNotifs];

        if (!notifPanelOpen)
            notifOverlayOpen = true;
    }

    function notifDismissByNotif(notif) {
        popupNotifs = popupNotifs.filter(n => n != notif);
        if (popupNotifs.length == 0)
            notifOverlayOpen = false;
    }

    function notifCloseByNotif(notif) {
        popupNotifs = popupNotifs.filter(n => n != notif); // filter out notif from popupNotifs
        allNotifs = allNotifs.filter(n => n != notif);
        notif.dismiss();
        if (popupNotifs.length == 0) // close overlay if no more pop ups in list
            notifOverlayOpen = false;
    }

    function notifDismissByPopup(idPopups) {
        let notif = popupNotifs[idPopups];
        notifDismissByNotif(notif);
    }

    function notifDismissByAll(idAll) {
        let notif = allNotifs[idAll];
        notifDismissByNotif(notif);
    }

    function notifCloseByAll(idAll) {
        let notif = allNotifs[idAll];
        notifCloseByNotif(notif);
    }

    function notifCloseByPopup(idPopup) {
        let notif = popupNotifs[idPopup];
        notifCloseByNotif(notif);
    }

    function dismissAll() {
        popupNotifs = [];
        notifOverlayOpen = false;
    }

    function closeAll() {
        allNotifs = [];
        notifOverlayOpen = false;
    }

    NotificationServer {
        id: notifServer
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: false
        bodyImagesSupported: false
        actionsSupported: true
        actionIconsSupported: false
        imageSupported: true
        onNotification: notif => {
            notif.tracked = true;
            root.onNewNotif(notif);
            notif.closed.connect(() => {
                notifDismissByNotif(notif);
            });
        }
    }
}
