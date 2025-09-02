// Tray.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.SystemTray
import Quickshell.Widgets

RowLayout {
    id: trayList
    Repeater {
        model: SystemTray.items
        Item {
            id: trayItem
            implicitWidth: icon.implicitWidth
            implicitHeight: icon.implicitHeight
            IconImage {
                id: icon
                source: modelData.icon
                implicitSize: 14
            }
        }

        MouseArea {
          id: delegate
          required property SystemTrayItem modelData
          property alias item: delegate.modelData

          Layout.fillHeight: true
          implicitWidth: icon.implicitWidth + 5

          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
          hoverEnabled: true

          onClicked: event => {
            if (event.button == Qt.LeftButton) {
              item.activate();
            } else if (event.button == Qt.MiddleButton) {
              item.secondaryActivate();
            } else if (event.button == Qt.RightButton) {
              menuAnchor.open();
            }
          }

          /* onWheel: event => { */
          /*   event.accepted = true; */
          /*   const points = event.angleDelta.y / 120 */
          /*   item.scroll(points, false); */
          /* } */

          IconImage {
            id: icon
            anchors {
                verticalCenter: parent.verticalCenter
            }
            source: item.icon
            implicitSize: 14
            asynchronous: true
          }

          /* QsMenuAnchor { */
          /*   id: menuAnchor */
          /*   menu: item.menu */

          /*   anchor.window: delegate.QsWindow.window */
          /*   anchor.adjustment: PopupAdjustment.Flip */

          /*   anchor.onAnchoring: { */
          /*     const window = delegate.QsWindow.window; */
          /*     const widgetRect = window.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height); */

          /*     menuAnchor.anchor.rect = widgetRect; */
          /*   } */
          /* } */

          /* Tooltip { */
          /*   relativeItem: delegate.containsMouse ? delegate : null */

          /*   Label { */
          /*     text: delegate.item.tooltipTitle || delegate.item.id */
          /*   } */
          /* } */
        }
    }
}
