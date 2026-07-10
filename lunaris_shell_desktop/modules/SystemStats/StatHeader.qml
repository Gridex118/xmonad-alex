import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes

Item {
    required property var root

    Shape {
        id: stat_header_box
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 8

        ShapePath {
            fillGradient: LinearGradient {
                x1: 0
                x2: root.width
                GradientStop {
                    position: 0.0
                    color: "#df4abfd6"
                }
                GradientStop {
                    position: 1.0
                    color: "#dfadf1ff"
                }
            }
            strokeColor: "transparent"
            PathLine {
                x: root.width - 10
                y: 0
            }
            PathLine {
                x: root.width - 30
                y: stat_header_box.height
            }
            PathLine {
                x: 0
                y: stat_header_box.height
            }
        }
    }

    Process {
        id: hostname
        command: ["hostname"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: stat_header_text.text =
            "01 System `" + text.trim() + "`"
        }
    }

    Text {
        id: stat_header_text
        anchors.left: stat_header_box.left
        anchors.leftMargin: 30
        anchors.verticalCenter: stat_header_box.verticalCenter
        color: "#083865"
        font.pixelSize: 42
        font.weight: 800
        font.family: "JetBrainsMonoNL NFP"
    }
}
