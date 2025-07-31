import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15
import Quickshell
import Quickshell.Services.Mpris as Mpris


MouseArea {
    id:root
    hoverEnabled: true
    fullWindowWidth: true
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
