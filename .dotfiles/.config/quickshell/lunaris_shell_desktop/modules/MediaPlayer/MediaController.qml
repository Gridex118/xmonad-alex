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

        Item {
            id: extra_buttons_container
            anchors.bottom: parent.bottom
            width: parent.width
            height: 35
            anchors.topMargin: 5
            Item {
                anchors.right: parent.right
                width: parent.height - 5
                height: width
                anchors.rightMargin: 20
                MouseArea {
                    anchors.fill: parent
                    onClicked: () => ActivePlayer.cyclePlayer()
                }
                HoverHandler {
                    id: hover_handler
                }
                Image {
                    source: hover_handler.hovered?
                        `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="skyblue"><path d="M280-120 80-320l200-200 57 56-104 104h607v80H233l104 104-57 56Zm400-320-57-56 104-104H120v-80h607L623-784l57-56 200 200-200 200Z"/></svg>`
                        : `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="deepskyblue"><path d="M280-120 80-320l200-200 57 56-104 104h607v80H233l104 104-57 56Zm400-320-57-56 104-104H120v-80h607L623-784l57-56 200 200-200 200Z"/></svg>`
                }
            }
        }
    }
}
