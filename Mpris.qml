import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris


RowLayout {
    id: mprisBlock
    anchors.fill: parent
}
Mpris {
}


    /* MouseArea { */
    /*     anchors.fill: parent */
    /*     onClicked: { */
    /*         if (player.playbackStatus === "Playing") { */
    /*             player.pause() */
    /*         } else { */
    /*             player.play() */
    /*         } */
    /*     } */
    /*     onWheel: { */
    /*         if (wheel.angleDelta.y > 0) */
    /*             player.next() */
    /*         else */
    /*             player.previous() */
    /*     } */
    /* } */
