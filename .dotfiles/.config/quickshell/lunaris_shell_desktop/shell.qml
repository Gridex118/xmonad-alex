import QtQuick
import Quickshell
import "modules"
import "modules/SystemStats"
import "modules/MediaPlayer"

ShellRoot {
    id: desktop
    SystemStats { }
    Clock { }
    MediaController { }
}
