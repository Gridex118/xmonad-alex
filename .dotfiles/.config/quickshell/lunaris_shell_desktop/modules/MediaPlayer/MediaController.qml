import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes
import QtQuick.Controls

PanelWindow {
    id: root
    implicitWidth: 500
    implicitHeight: 160

    anchors.left: true
    margins.left: 120
    anchors.top: true
    margins.top: 180
    exclusiveZone: 0

    WlrLayershell.layer: WlrLayer.Background
    color: "transparent";

    Process {
        id: media_progress_proc
        command: [
            "playerctl", "metadata",
            "--format", "{{position}} {{mpris:length}}",
            "--follow"
        ]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data && !media_progress.pressed) {
                    let [position, length] = data.trim().split(/\s+/)
                    media_progress.value = Number(position)
                    media_progress.to = Number(length)
                }
            }
        }
    }

    Process {
        id: media_progress_set_proc
        command: !media_progress.pressed? [
            "playerctl", "position",
            (media_progress.value / 1000000)
            // µs (metadata -f 'position') to s (position)
        ] : [ ]
    }

    Rectangle {
        anchors.fill: parent
        color: "#b0ffffff"
        radius: 16

        MediaNameLine {
            id: media_name_line
            width: parent.width
            height: parent.height / 3
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: - 20
        }

        Slider {
            id: media_progress
            width: parent.width - 50
            height: 8
            anchors.top: media_name_line.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            background: Rectangle {
                color: "#b0ffffff"
                radius: 0
            }
            contentItem: Item {
                Rectangle {
                    width: media_progress.visualPosition * parent.width
                    height: parent.height
                    radius: 0
                    color: "deepskyblue"
                }
            }
            handle: null
            onMoved: () => {
                media_progress_set_proc.running = true
            }
        }
    }
}
