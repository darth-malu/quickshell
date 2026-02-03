import QtQuick
import qs.themes
import qs.customItems
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import Qt5Compat.GraphicalEffects

RowLayout {
    spacing: 2
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    Repeater {
        model: ScriptModel {
            values: {
                var seenEmpty = false;
                return [...Hyprland.workspaces.values].filter(ws => {
                    if (ws.monitor !== monitor || ws.name.includes("special"))
                        return false;

                    // There is a flickering that can happen when switching from one
                    // empty workspace to another where both empty workspaces are shown
                    // on the bar at the same time.  This ensures that only the first
                    // empty workspace is shown.
                    const isNumeric = /^\d+$/.test(ws.name);
                    if (!isNumeric)
                        return true;
                    if (!seenEmpty) {
                        seenEmpty = true;
                        return true;
                    }
                    return false;
                });
                // Sort workspaces by id
                // .sort((a, b) => a.id - b.id);
            }
        }

        BarBlock {
            id: rootBlock
            property HyprlandWorkspace ws: modelData
            property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === ws.id
            property bool isOpen: monitor.activeWorkspace?.id === ws.id
            property bool hasClients: ws.name.length > 2

            property color glassTint: isActive ? (hasClients ? Qt.rgba(1, 1, 1, 0.25) : "transparent") : Qt.rgba(1, 1, 1, 0.1)
            property color glassBorder: (isActive && hasClients) ? Qt.rgba(1, 1, 1, 0.2) : "transparent"

            dim: false
            // underline: isActive ? true : false
            // underlineColor: "#D295BF"
            border.color: glassBorder
            color: glassTint

            // layer.enabled: true

            radius: height / 2
            gradient: (isActive || isOpen) && hasClients ? Themes.buttonActiveGradient : Themes.buttonInactiveGradientV
            Layout.preferredWidth: content.width
            Layout.preferredHeight: content.height

            // Behavior on color {
            //     ColorAnimation {
            //         duration: 200
            //     }
            // }
            // Behavior on border.color {
            //     ColorAnimation {
            //         duration: 200
            //     }
            // }

            // Rectangle {
            //     visible: !isActive && !isOpen
            //     gradient: Themes.buttonInactiveGradientH
            //     implicitWidth: parent.width
            //     implicitHeight: parent.height
            //     radius: parent.radius
            //     z: -1
            // }

            // Rectangle {
            //     visible: Themes.buttonBorderShadow
            //     implicitWidth: parent.width - 1
            //     implicitHeight: parent.height - 1
            //     radius: parent.radius
            //     color: "transparent"
            //     border.color: parent.isActive || parent.isOpen ? "transparent" : "black" // Inner border color
            //     border.width: 1 // Inner border width
            //     x: 1
            //     y: 1
            //     z: -1
            // }

            onClicked: function () {
                Hyprland.dispatch(`workspace ${ws.id}`);
            }

            content: RowLayout {
                spacing: 0
                anchors.centerIn: parent

                Repeater {
                    id: therepeater
                    model: ScriptModel {
                        values: getChunks(ws.name)
                    }

                    delegate: Item {
                        property bool showText: modelData.type === "text"
                        property bool showIcon: modelData.type === "icon"
                        property int symbolSize: 18 // 18
                        property int spacerSize: 3

                        implicitWidth: {
                            if (showText)
                                return thetext.implicitWidth;
                            if (showIcon)
                                return symbolSize;
                            return spacerSize;
                        }
                        implicitHeight: {
                            if (showText)
                                return thetext.implicitHeight;
                            if (showIcon)
                                return symbolSize;
                            return spacerSize;
                        }
                        Layout.alignment: Qt.AlignCenter

                        Loader {
                            id: thetext
                            anchors.centerIn: parent
                            active: modelData.type === "text"
                            sourceComponent: BarText {
                                text: modelData.value
                                dim: !rootBlock.isActive
                                // paddingg: 0
                                rightPadding: 3
                                // color: parent.color.hsvLightness > 0.8 ? "#222222" : "#eeeeee"
                                color: dim ? "grey" : "#00FFF0" //5DFDCB, 23C9FF,#9CFFFA, 9400FF, 9CFF2E,00FFAB, 06FF00

                                // pointSize: 13
                            }
                        }

                        Loader {
                            id: theicon
                            anchors.centerIn: parent
                            active: modelData.type === "icon"
                            sourceComponent: Item {
                                implicitWidth: inside.implicitWidth
                                implicitHeight: inside.implicitHeight
                                IconImage {
                                    id: inside
                                    // anchors.centerIn: parent
                                    source: modelData.source
                                    implicitSize: symbolSize
                                    opacity: ws.active ? 1 : 0.7
                                    // mipmap: true
                                }
                                DropShadow {
                                    anchors.fill: parent
                                    verticalOffset: 1
                                    horizontalOffset: 1
                                    radius: 8.0
                                    color: "#000000"//"#000000"
                                    source: inside
                                    opacity: ws.active ? 1 : 0.2
                                }
                                Rectangle {
                                    visible: ws.mult > 1
                                    width: 10
                                    height: width
                                    radius: width / 2
                                    color: "black"
                                    opacity: 0.8
                                    BarText {
                                        text: ws.mult
                                        pointSize: 11
                                        dim: !rootBlock.isActive
                                        style: Text.Outline
                                        styleColor: "black"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function getChunks(text) {
        let chunks = [];
        let buffer = "";  // Temporary storage for text segments

        let symbolChunkInd = {};

        let nextIsActive = false;

        for (let c of text) {
            if (c === "󰀦") {
                nextIsActive = true;
                continue;
            }

            if (!(c in symbolImgMap)) {
                buffer += c;
                nextIsActive = false;
                continue;
            }

            if (buffer.length > 0 && !/^\s*$/.test(buffer)) {
                chunks.push({
                    type: "text",
                    value: buffer
                });
                buffer = ""; // Reset text buffer
            }

            if (!(c in symbolChunkInd)) {
                if (chunks[chunks.length - 1].type == "icon") {
                    chunks.push({
                        type: "spacer"
                    });
                }
                symbolChunkInd[c] = chunks.length;
                chunks.push({
                    type: "icon",
                    active: nextIsActive,
                    source: `image://icon/${symbolImgMap[c]}`,
                    mult: 1 // multiplicity; how many times this symbol was seen
                });
            } else {
                chunks[symbolChunkInd[c]].mult++;
                if (nextIsActive)
                    chunks[symbolChunkInd[c]].active = true;
            }
            nextIsActive = false;
        }

        if (buffer.length > 0 && !/^\s*$/.test(buffer)) {
            chunks.push({
                type: "text",
                value: buffer
            });
        }

        return chunks;
    }

    property var symbolImgMap: {
        "": "extra-scale-vim",
        "": "extra-firefox_flat",
        "": "extra-scale-TTY2",
        "󰇥": "extra-yazi",
        "": "extra-chrome7",
        "󰽉": "extra-libreoffice_draw",
        "󰷈": "extra-libreoffice_writer",
        "": "extra-libreoffice_calc",
        "󰈩": "extra-libreoffice_impress",
        "B": "extra-scale-qbittorrent",
        "🪛": "extra-sys5",
        "📂": "extra-scale-FILES2",
        "💬": "extra-wozzap2",
        "": "extra-pdf-svg",
        "": "extra-scale-spotify-SVG",
        "": "extra-ironman",
        "l": "extra-Lutris_Logo-svg",
        "😀": "extra-scale-lact",
        "😆": "extra-battlenet",
        "": "extra-dolphin",
        "󰓓": "extra-steam_blue",
        "": "extra-scale-bluetooth",
        "": "extra-scale-gimp",
        // "󰄄": "extra-scale-obs",
        "": "extra-photos",
        "m": "extra-mpv2",
        "": "extra-scale-emacs_SVG",
        "D": "extra-Dota",
        "Q": "extra-qutebrowser-svg",
        "f": "extra-yt2",
        // "󰻎": "extra-system-explorer-outline",
        // "󱍼": "extra-scale-vlc",
        "": "com.usebottles.bottles",
        // "": "Zoom",
        "🎁": "extra-wps-presentation",
        "📃": "extra-wps-spreadsheet",
        "📜": "extra-wps-office",
        // "󰊻": "teams-for-linux",
        "": "extra-scale-DISCORD"
    }
}
