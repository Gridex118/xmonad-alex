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

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: () => {
            if (ActivePlayer.isPlaying() && !media_progress.pressed) {
                ActivePlayer.player.positionChanged();
            }
        }
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

        MediaProgress {
            id: media_progress
            anchors.top: media_name_line.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
        }
    }
}
