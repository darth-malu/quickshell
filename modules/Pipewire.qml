import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
//import "../"

BarBlock {
  id: text
  visible: Pipewire.ready

  content: BarText {
    symbolText: `🔈 ${volume}`
    font.pixelSize: 13
    font.family: "Mononoki Nerd Font"
    color: '#ccccccff'
   //font.family: "VictorMono Nerd Font"
  }

  property PwNode sink: Pipewire.defaultAudioSink
  property string volume: Pipewire.ready ? `${Math.floor(sink.audio.volume * 100)}` : ""

  PwObjectTracker { objects: [ sink ] }

    /* MouseArea { */
    /*   anchors.fill: parent */
    /*   onClicked: Hyprland.dispatch("workspace " + modelData.id) */
    /*   onWheel: (wheel) => { */
    /*       if (wheel.angleDelta.y > 0) { */
    /*         Hyprland.dispatch("workspace m-1") */
    /*       } else if (wheel.angleDelta.y < 0) { */
    /*         Hyprland.dispatch("workspace m+1") */
    /*       } */
    /*   } */
    /* } */
}
