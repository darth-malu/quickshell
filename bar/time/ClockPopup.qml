import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.themes

PopupWindow {
    id: popup
    required property var hostt
    visible: hostt.showPopup
    color: 'transparent'
    anchor {
        window: host
        rect {
            y: 33
            x: parent.x - 105
        }
    }
    implicitWidth: 250
    implicitHeight: 180

    property date currentDate: new Date()

    Timer {
        interval: 60000 // Check every minute
        running: true
        repeat: true
        onTriggered: popup.currentDate = new Date()
    }

    Rectangle {
        radius: 6
        color: Qt.rgba(0.1, 0.04, 0.18, 0.7)
        anchors.fill: parent
        border.width: 1
        border.color: '#A020F0'
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 3

        Text {
            font: Themes.quicksand
            color: Themes.calendarHeader
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(popup.currentDate, "MMMM yyyy")
        }

        DayOfWeekRow {
            Layout.fillWidth: parent
            // required property string shortName

            font: Themes.quicksand
            delegate: Text {
                horizontalAlignment: Text.AlignHCenter
                color: Themes.calendarDayRow
                text: model.shortName
            }
        }

        MonthGrid {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            month: popup.currentDate.getMonth()
            year: popup.currentDate.getFullYear()

            delegate: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: model.day
                font: Themes.quicksand
                color: model.today ? Themes.calendarToday : (model.month === grid.month ? Themes.calendarActiveMonth : Themes.calendarInactiveMonth)
            }
        }
    }
}
