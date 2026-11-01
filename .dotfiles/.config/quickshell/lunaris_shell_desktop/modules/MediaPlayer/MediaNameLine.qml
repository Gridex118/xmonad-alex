import QtQuick
import Quickshell

Rectangle {
    id: root
    color: "#80ffffff"
    Item {
        width: parent.width * 0.8
        height: parent.height
        anchors.centerIn: parent
        Text {
            id: media_track_name
            width: parent.width
            elide: Text.ElideRight
            font.pixelSize: 22
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            color: "deepskyblue"
            text: ActivePlayer.player? `(${ActivePlayer.name}) ${ActivePlayer.trackTitle}` : "No Media"
        }
    }
}
