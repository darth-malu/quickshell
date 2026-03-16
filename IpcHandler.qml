import qs.services
import qs.bar               
import QtQuick
import Quickshell.Io

Item {
    id: root

    IpcHandler {
        target: 'mpris'

        function pauseAll(): void {
            for (const player of MprisState.players.values) {
                if (player.canPause)
                    player.pause();
            }
        }

        function togglePlaying(): void {
            const player = MprisState.player;
            if (player && player.canTogglePlaying)
                player.togglePlaying();
        }

        function previous(): void {
            const player = MprisState.player;
            if (player && player.canGoPrevious)
                player.previous();
        }

        function next(): void {
            const player = MprisState.player;
            if (player && player.canGoNext)
                player.next();
        }

        function raise(): void {
            const player = MprisState.player;
            if (player && player.canRaise)
                player.raise();
        }

        function toggleMpris(): void {
            MprisState.mprisVisible = !MprisState.mprisVisible;
        }

        function toggleMprisArt(): void {
            MprisNotification.sendNotify();
        }

        function toggleMprisIcon(): void {
            MprisState.mprisArtVisible = !MprisState.mprisArtVisible;
        }
    }

    IpcHandler {
        target: 'notifications'
        function dismissAll(): void {
            NotificationState.dismissAll();
        }

        function showLast(): void {
            NotificationState.showLastNotif(NotificationState.lastNotif);
        }
    }

    IpcHandler {
        target: 'netspeed'
        function toggleNet(): void {
            NetworkState.netspeedVisible = !NetworkState.netspeedVisible;
        }
    }

    IpcHandler {
        target: 'resources'
        function toggleResources(): void {
            ResourcesState.resourcesVisible = !ResourcesState.resourcesVisible;
        }
    }

    IpcHandler {
        target: 'bar'
        function toggleBar(): void {
            BarState.enableBar = !BarState.enableBar;
        }
    }
}
