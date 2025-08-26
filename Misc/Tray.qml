
      Rectangle {
        id: systemTray
        radius: 5
        implicitWidth: 8
        implicitHeight: 8
        color: red
      RowLayout {
        id: trayYangu
        spacing: 4
        anchors.centerIn: parent
        Repeater {
          model: SystemTray.items.values
            Button {
                id: sysTrayButton
                required property SystemTrayItem modelData
                implicitHeight: 5
                implicitWidth: 5
                background: Rectangle {
                    radius: 3
                    color: sysTrayButton.hovered ? red : green
                }

                /* IconImage { */
                /*     anchors.centerIn: parent */
                /*     source: Quickshell.iconPath(sysTrayButton.modelData.icon) */
                /*     implicitSize: 5 */
                /* } */
                // DEBUG
                // Component.onCompleted: print(JSON.stringify(modelData))
            }
        }
      }
    }
