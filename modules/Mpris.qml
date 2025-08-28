pragma Singleton
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    readonly property string test: {
        if (Mpris.players && Mpris.players[0]) {
            return Mpris.players.values[0].trackTitle || "Unknown track"
        }
        return "No media"
    }
}
