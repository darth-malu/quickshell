import Quickshell
import QtQuick.Layouts
import QtQuick.Controls         /*Button*/
import QtQuick                  /*Text*/
import Quickshell.Io // process execution

ColumnLayout {
  property int clicks: 0

  function makeClicksLabel(): string {
    return "the button has been clicked " + clicks + " times!";
  }

  Button {
    text: "click me"
    onClicked: clicks += 1
  }

  Text {
    text: makeClicksLabel()
  }
}
