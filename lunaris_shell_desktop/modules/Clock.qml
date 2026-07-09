import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes

PanelWindow {
    id: root
    implicitWidth: 650
    implicitHeight: 375

    anchors.left: true
    margins.left: 70
    anchors.bottom: true
    margins.bottom: -50
    exclusiveZone: 0

    WlrLayershell.layer: WlrLayer.Background
    color: "transparent"

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: -30
        RowLayout {
            id: clock_time
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            Text {
                id: clock_hours
                color: "#ccffffff"
                font.pixelSize: 168
                font.weight: 800
                font.family: "JetBrainsMonoNL NFP"
                text: Qt.formatDateTime(clock.date, "hh")
                Layout.alignment: Qt.AlignBaseline
            }
            Text {
                id: clock_min
                color: "#ccffffff"
                font.pixelSize: 128
                font.weight: 800
                font.family: "JetBrainsMonoNL NFP"
                text: Qt.formatDateTime(clock.date, ":mm")
                Layout.alignment: Qt.AlignBaseline
            }
            Text {
                id: clock_sec
                color: "#ccffffff"
                font.pixelSize: 100
                font.weight: 800
                font.family: "JetBrainsMonoNL NFP"
                text: Qt.formatDateTime(clock.date, ":ss")
                Layout.alignment: Qt.AlignBaseline
            }
        }
        Text {
            id: clock_date
            color: "#ccffffff"
            font.pixelSize: 64
            font.weight: 800
            font.family: "JetBrainsMonoNL NFP"
            text: Qt.formatDateTime(clock.date, "dddd, MMMM dd")
        }
    }
}
