import QtQuick
import Quickshell
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent
    opacity: 0.4
    Image {
        id: music_cover
        height: parent.height
        width: parent.width / 3
        fillMode: Image.PreserveAspectCrop
        source: ActivePlayer.getTrackCover();
        visible: false
        onStatusChanged: {
            if (status == Image.Error) {
                source = ActivePlayer.getTrackCover();
            }
        }
    }
    MultiEffect {
        source: music_cover
        anchors.fill: music_cover
        maskEnabled: true
        maskSource: music_cover_mask
    }
    Item {
        id: music_cover_mask
        anchors.fill: music_cover
        layer.enabled: true
        visible: false
        Rectangle {
            anchors.fill: parent
            topLeftRadius: 16
            bottomLeftRadius: 16
        }
    }
}
