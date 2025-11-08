pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    readonly property bool pipewireReady: Pipewire.ready
    readonly property PwNode outputSink: Pipewire.defaultAudioSink
    readonly property PwNode inputSink: Pipewire.defaultAudioSource

    readonly property bool isMuted: outputSink.audio.muted
    readonly property var volume: Pipewire.ready ? isMuted ? "❌" : `${Math.floor(outputSink.audio.volume * 100)}` : ""

    PwObjectTracker { objects: [ outputSink] }
}
