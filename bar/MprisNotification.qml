import Quickshell
import QtQuick
import qs.services

import Quickshell.Services.Mpris

Item {
    id: root
    property MprisPlayer currentPlayer: MprisState.player
    property string formatMpc

    function sendNotify() {
        let title = root.currentPlayer.trackTitle || "Unknown Title";
        let artist = root.currentPlayer.trackArtist || "Unknown Artist";
        let album = root.currentPlayer.trackAlbum || "Unknown Album";
        let art = root.currentPlayer.trackArtUrl || "audio-x-generic";
        let isMpd = root.currentPlayer.identity === "Music Player Daemon";

        if (isMpd) {
            Quickshell.execDetached(["bash", "-c", `pos=$(awk '/#/ {print $2}' <(mpc)); notify-send -a ncmpcpp -i "${art}" "$(mpc --format "[[󰎍    %title% \n] [     %audioformat%   $pos\n    %artist%  \n    %album%]] | [%file%]" current)"`]);
        } else {
            Quickshell.execDetached(["notify-send", "-a", "mzichi", "-i", art, `󰎍    ${title}`, `    ${artist}\n    ${album}`]);
        }
    }

    Connections {
        target: root.currentPlayer
        function onPostTrackChanged() {
            if (root.currentPlayer)
                root.sendNotify();
        }
    }
}
