import QtQuick
import qs.services
import qs.customItems
import Quickshell.Io
import QtQuick.Layouts

Loader {
    // active:
    id: loaderBig
    active: NetworkState.netspeedVisible
    visible: active
    sourceComponent: Rectangle {
        id: root

        implicitHeight: 20
        implicitWidth: childrenRect.width // Wraps rectangle around contents
        Layout.topMargin: 4

        color: 'transparent'

        property int refreshInterval: 1000
        property string iface

        property string rxColor: "#0080c0"
        property string txColor: "#fa7070"

        property real rxPrev: 0
        property real txPrev: 0

        // DARTH props
        property real rxRate
        property real txRate

        Process {
            id: defaultInterface
            command: ["ip", "route"]
            running: false

            stdout: SplitParser {
                onRead: data => {
                    if (data.startsWith("default via")) {
                        let line = data.split(/\s/);
                        root.iface = line[4];
                        console.log(root.iface);
                    }
                }
            }
        }

        Process {
            id: getRxTxBytes
            command: ["cat", "/proc/net/dev"]
            running: false

            stdout: SplitParser {
                onRead: data => {
                    if (data.startsWith(root.iface + ":")) {
                        console.log("This executed");
                        const parts = data.split(/\s+/);

                        // current values
                        let rx = parseInt(parts[1]);
                        let tx = parseInt(parts[9]);

                        if (root.rxPrev > 0) {
                            // Calculate Mbps: (bytes * 8 bits) / 1,000,000 bits per Mb
                            root.rxRate = ((rx - root.rxPrev) * 8) / 1000000;
                            root.txRate = ((tx - root.txPrev) * 8) / 1000000;
                        }
                        root.rxPrev = rx;
                        root.txPrev = tx;
                    }
                }
            }
        }

        Timer {
            interval: root.refreshInterval
            running: true
            repeat: true
            onTriggered: () => {
                defaultInterface.running = true;
                getRxTxBytes.running = true;
            }
        }

        RowLayout {
            spacing: 5
            BarText {
                textFormat: Text.RichText
                text: `${root.rxRate.toFixed(2)} ↘`
                font.pixelSize: 13
            }
            BarText {
                textFormat: Text.RichText
                text: `${root.txRate.toFixed(2)} ↗`
                font.pixelSize: 13
                color: 'black'
            }
        }
    }
}
