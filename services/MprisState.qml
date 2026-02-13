pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer player: null

    property MprisPlayer lastPlayer: null

    property bool mprisVisible: true

    property bool mprisArtVisible: true

    property var players: new Set()

    function updatePlayer() {
        let backup, leader = null;

        // let backup = (lastPlayer?.identity !== "mpv" && lastPlayer.desktopEntry !== "mpv") ? lastPlayer : null; // TODO see if needed

        for (let player of Mpris.players.values) {
            const ignored = ["mpv", "whatsapp", "chromium"];
            const isIgnored = ignored.some(app => player.identity.includes(app) || player.desktopEntry.includes(app));

            if (isIgnored)
                continue;
            else if (player.isPlaying) {
                backup = player;
                if (player?.trackArtist && player.trackArtist !== "")
                    leader = player;
            }
        }

        player = leader != null ? leader : backup;
    // console.log(`The current player is: ${player.identity}`);
    }

    function handlePlayerChanged(player: MprisPlayer) {
        if (!player.isPlaying)
            return;

        players.delete(player);
        players.add(player);
        lastPlayer = player ?? null;

        updatePlayer();
    }

    function playerDestroyed(player: MprisPlayer) {
        players.delete(player);
        lastPlayer = players[players.size] ?? null;

        updatePlayer();
    }

    Instantiator {
        model: Mpris.players    // ObjectModel: <MprisPlayer>

        Connections {
            required property MprisPlayer modelData
            target: modelData

            Component.onCompleted: root.handlePlayerChanged(modelData)
            Component.onDestruction: root.playerDestroyed(modelData)

            function onPlaybackStateChanged() {
                root.handlePlayerChanged(modelData);
            }
        }
    }
}
