import qs.services
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
            console.log(`ncmpcpp name: ${player.identity}`);
            if (player && player.canRaise)
                player.raise();
        // if (player)
        //     // Quickshell.execDetached(["hyprctl", "dispatch workspace special:nc"]);
        //     console.log(`ncmpcpp name: ${player.identity}`);
        // Quickshell.execDetached(["sh", "-c", "notify-send 'Charger Disconnected' -u low -i /home/malu/.config/quickshell/assets/battery/unplug.png -a Shell && canberra-gtk-play -i bell"]);
        }

        function toggleMpris(): void {
            MprisState.mprisVisible = !MprisState.mprisVisible;
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
