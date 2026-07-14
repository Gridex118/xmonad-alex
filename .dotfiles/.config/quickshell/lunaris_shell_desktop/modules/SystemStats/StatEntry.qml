import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes

Rectangle {
    id: root
    required property var container
    property string entryTitle
    property string entryValue
    property int fontSizePx: 28

    width: parent.width
    height: (parent.height
             - (container.itemCount - 1)
             * parent.spacing)
        / container.itemCount
    color: "#8802020A"

    Row {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 20

        Text {
            id: entry_title
            font.capitalization: Font.Capitalize
            font.pixelSize: root.fontSizePx
            font.weight: 600
            font.family: "JetBrainsMonoNL NFP"
            color: "#bdb8b8"
            text: entryTitle
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: entry_value
            property int padding: 8
            implicitWidth: value_text.width + padding * 2
            implicitHeight: value_text.height
            anchors.verticalCenter: parent.verticalCenter

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#51c0d3" }
                GradientStop { position: 0.8; color: "#afe2eb" }
                GradientStop { position: 1.0; color: "#ffffff" }
            }

            Text {
                id: value_text
                anchors.centerIn: parent
                font.pixelSize: root.fontSizePx
                font.weight: 600
                font.family: "JetBrainsMonoNL NFP"
                text: entryValue
            }
        }
    }
}
