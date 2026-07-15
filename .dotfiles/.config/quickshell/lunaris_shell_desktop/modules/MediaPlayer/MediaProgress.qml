import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Controls

Slider {
    id: root
    width: parent.width - 50
    height: 8
    from: 0; to: ActivePlayer.trackLength
    value: ActivePlayer.trackPosition

    background: Rectangle {
        color: "#b0ffffff"
        radius: 0
    }
    contentItem: Item {
        Rectangle {
            width: visualPosition * parent.width
            height: parent.height
            radius: 0
            color: "deepskyblue"
        }
    }
    handle: null

    onPressedChanged: () => {
        if (!pressed) {
            ActivePlayer.seekPosition(value);
        }
    }
}
