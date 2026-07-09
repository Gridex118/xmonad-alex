import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Shapes

PanelWindow {
    id: root
    implicitWidth: 781
    implicitHeight: 691

    anchors.right: true
    margins.right: 100
    anchors.top: true
    margins.top: 200
    exclusiveZone: 0

    WlrLayershell.layer: WlrLayer.Background
    color: "transparent"

    Column {
        anchors.fill: parent
        spacing: 10
        StatHeader {
            id: stat_header
            root: root
            width: parent.width
            height: 100
        }
        Rectangle {
            id: stats_container
            height: parent.height - stat_header.height - 100
            width: parent.width - 30
            color: "#88152d59"
            property int itemCount: 8
            Column {
                spacing: 10
                anchors.fill: parent
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                Repeater {
                    model: stats_container.itemCount
                    Rectangle {
                        width: parent.width
                        height: (parent.height
                                 - (stats_container.itemCount - 1)
                                 * parent.spacing)
                            / stats_container.itemCount
                        color: "#8802020A"
                    }
                }
            }
        }
    }
}
