import qs.services
import QtQuick
import qs.bar
import Quickshell.Io

Item {
    id: root

    IpcHandler {
        target: 'mpris'

        // function pauseAll(): void {
        //     for (const player of Mpris.players.values) {
        //         if (player.canPause)
        //             player.pause();
        //     }
        // }

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
    }

    IpcHandler {
        target: 'notifications'
        function dismissAll(): void {
            NotificationState.dismissAll();
        }
    }

    /* IpcHandler { */
    /*     target: "bar" */
    /*     function toggleBar(): void { */
    /*         barr.visible = !barr.visible; */
    /*     } */
    /* } */
}
