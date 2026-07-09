import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Shapes
import "modules"
import "modules/SystemStats"

ShellRoot {
    id: desktop
    SystemStats { }
    Clock { }
}
