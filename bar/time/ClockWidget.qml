import QtQuick
import Quickshell

import qs.customItems

BarBlock {
  id: masaa

  content: BarText {
      symbolText: Time.time
      font {pixelSize: 13; family: 'lato'; bold: true}
      baseColor: '#ff79c6'
      rightPadding: 13
  }
}
