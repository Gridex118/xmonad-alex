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
                id: player_play_pause_button
                anchors.right: player_cycle_button.left
                width: player_cycle_button.width
                height: width
                anchors.rightMargin: 10
                readonly property string icon_play: `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="deepskyblue"><path d="M320-200v-560l440 280-440 280Zm80-280Zm0 134 210-134-210-134v268Z"/></svg>`
                readonly property string icon_play_hover: `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="skyblue"><path d="M320-200v-560l440 280-440 280Zm80-280Zm0 134 210-134-210-134v268Z"/></svg>`
                readonly property string icon_pause: `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="deepskyblue"><path d="M520-200v-560h240v560H520Zm-320 0v-560h240v560H200Zm400-80h80v-400h-80v400Zm-320 0h80v-400h-80v400Zm0-400v400-400Zm320 0v400-400Z"/></svg>`
                readonly property string icon_pause_hover: `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="skyblue"><path d="M520-200v-560h240v560H520Zm-320 0v-560h240v560H200Zm400-80h80v-400h-80v400Zm-320 0h80v-400h-80v400Zm0-400v400-400Zm320 0v400-400Z"/></svg>`
                property string icon: ActivePlayer.isPlaying()?
                    icon_pause : icon_play;
                property string icon_hover: ActivePlayer.isPlaying()?
                    icon_pause_hover : icon_play_hover;
                MouseArea {
                    anchors.fill: parent
                    onClicked: () => ActivePlayer.player?.togglePlaying();
                }
                HoverHandler {
                    id: hover_handler_play_pause
                }
                Image {
                    source: hover_handler_play_pause.hovered?
                        parent.icon_hover : parent.icon
                }
            }
            Item {
                id: player_cycle_button
                anchors.right: parent.right
                width: parent.height - 5
                height: width
                anchors.rightMargin: 20
                readonly property string icon: `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="deepskyblue"><path d="M280-120 80-320l200-200 57 56-104 104h607v80H233l104 104-57 56Zm400-320-57-56 104-104H120v-80h607L623-784l57-56 200 200-200 200Z"/></svg>`;
                readonly property string icon_hover: `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="skyblue"><path d="M280-120 80-320l200-200 57 56-104 104h607v80H233l104 104-57 56Zm400-320-57-56 104-104H120v-80h607L623-784l57-56 200 200-200 200Z"/></svg>`;
                MouseArea {
                    anchors.fill: parent
                    onClicked: () => ActivePlayer.cyclePlayer()
                }
                HoverHandler {
                    id: hover_handler_cycle
                }
                Image {
                    source: hover_handler_cycle.hovered?
                        parent.icon_hover : parent.icon
                }
            }
        }
    }
}
